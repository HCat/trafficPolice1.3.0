//
//  VehicleCameraVC.m
//  移动采集
//
//  Created by hcat on 2017/9/8.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "VehicleCameraVC.h"

#import <TOCropViewController.h>
#import "LLSimpleCamera.h"
#import "DeviceOrientation.h"

#import "PureLayout.h"
#import "maskingView.h"
#import "UIButton+Block.h"

#import "ImageFileInfo.h"

@interface VehicleCameraVC ()<TOCropViewControllerDelegate,DeviceOrientationDelegate>

//LLSimpleCamera是运用AVFoundation自定义的相机对象
@property (strong, nonatomic) LLSimpleCamera *camera;

//闪光灯按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_flash;
@property (weak, nonatomic) IBOutlet UILabel *lb_flash;

//关闭按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_close;

//拍照按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_snap;

@property (weak, nonatomic) IBOutlet maskingView *v_masking;

@property (weak, nonatomic) IBOutlet UILabel *lb_tip;

@property (nonatomic,strong) DeviceOrientation *deviceMotion;


@property (nonatomic,strong) ImageFileInfo *imageInfo;

@end

@implementation VehicleCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.isHandSearch = NO;
    
    [_btn_flash setEnlargeEdgeWithTop:20.f right:20.f bottom:20.f left:20.f];
    [_btn_close setEnlargeEdgeWithTop:20.f right:20.f bottom:20.f left:20.f];
    _v_masking.type = 1;
    _lb_tip.text = @"请扫描车牌号";
    
    //初始化照相机，通过AVFoundation自定义的相机
    [self initializeCamera];
    self.deviceMotion = [[DeviceOrientation alloc]initWithDelegate:self];
    [_deviceMotion startMonitor];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    _lb_tip.hidden = NO;
    WS(weakSelf);
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        weakSelf.lb_tip.hidden = YES;
    });
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.camera.direction = TgDirectionPortrait;
    [self.camera start];
    
    self.deviceMotion = [[DeviceOrientation alloc]initWithDelegate:self];
    [_deviceMotion startMonitor];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    //停止拍照
    [_deviceMotion stop];
    [self.camera stop];
    [super viewDidDisappear:animated];
}

#pragma mark - 请求数据

//拍照完之后请求服务端获取证件信息
- (void)getIdentifyRequest{
    
    WS(weakSelf);
    
    CommonIdentifyManger *manger = [[CommonIdentifyManger alloc] init];
    [manger configLoadingTitle:@"识别"];
    
    manger.imageInfo = self.imageInfo;
    manger.type = 1;
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            if (manger.commonIdentifyResponse) {
                
                strongSelf.commonIdentifyResponse = manger.commonIdentifyResponse;
                //这里待优化，需要判断服务端返回来的IdNo,name为""的情况，现阶段不做
                if (strongSelf.fininshCaptureBlock) {
                    strongSelf.fininshCaptureBlock(strongSelf);
                }
                [strongSelf dismissViewControllerAnimated:YES completion:^{
                }];
                
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        
    }];
    
}

#pragma mark - 初始化相机对象

-(void)initializeCamera{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    // 创建一个相机
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh  position:LLCameraPositionRear
                                             videoEnabled:YES];
    
    
    // 关联到具体的VC中
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    [self.camera.view configureForAutoLayout];
    [self.camera.view autoPinEdgesToSuperviewEdges];
    self.camera.fixOrientationAfterCapture = YES;
    self.camera.useDeviceOrientation = YES;
    
    
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        
        // 检查闪关灯状态
        if([camera isFlashAvailable]) {
            weakSelf.btn_flash.hidden = NO;
            
            if(camera.flash == LLCameraFlashOff) {
                weakSelf.lb_flash.text = @"关闭";
                [weakSelf.btn_flash setImage:[UIImage imageNamed:@"camera_flash_close"] forState:UIControlStateNormal];
                
            }else if(camera.flash == LLCameraFlashOn){
                weakSelf.lb_flash.text = @"开启";
                [weakSelf.btn_flash setImage:[UIImage imageNamed:@"camera_flash_open"] forState:UIControlStateNormal];
            }else{
                weakSelf.lb_flash.text = @"自动";
                [weakSelf.btn_flash setImage:[UIImage imageNamed:@"camera_flash_open"] forState:UIControlStateNormal];
            }
        }
        else {
            weakSelf.btn_flash.hidden = YES;
        }
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        
        LxPrintf(@"Camera error: %@", error);
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission) {
                [LRShowHUD showError:@"未获取相机权限" duration:1.5f inView:weakSelf.view config:nil];
            }
        }
    }];
    [self.view sendSubviewToBack:self.camera.view];
    
}

#pragma mark - 按钮事件

//拍照按钮点击

- (IBAction)handlebtnSnapClicked:(id)sender {
    
    WS(weakSelf);
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
            
            //拍照成功之后，如果成功调用TOCropViewController 对照片进行裁剪
            
            LxDBAnyVar(image.size.width);
            LxDBAnyVar(image.size.height);
            
            TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
            cropController.delegate = weakSelf;
            [weakSelf presentViewController:cropController animated:YES completion:nil];
            
        }else {
            
            LxPrintf(@"An error has occured: %@", error);
            
        }
    } exactSeenImage:YES];
    
}

//关闭按钮点击
- (IBAction)handlebtnCloseClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//闪光灯按钮点击
- (IBAction)handlebtnFlashClicked:(id)sender {
    
    if(self.camera.flash == LLCameraFlashOff) {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOn];
        if(done) {
            self.lb_flash.text = @"开启";
            [self.btn_flash setImage:[UIImage imageNamed:@"camera_flash_open"] forState:UIControlStateNormal];
        }
    }else if(self.camera.flash == LLCameraFlashOn){
        BOOL done = [self.camera updateFlashMode:LLCameraFlashAuto];
        if(done) {
            self.lb_flash.text = @"自动";
            [self.btn_flash setImage:[UIImage imageNamed:@"camera_flash_open"] forState:UIControlStateNormal];
        }
    }else{
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOff];
        if(done) {
            self.lb_flash.text = @"关闭";
            [self.btn_flash setImage:[UIImage imageNamed:@"camera_flash_close"] forState:UIControlStateNormal];
        }
        
    }
    
}

//相册按钮点击
- (IBAction)handlebtnHandSearchClicked:(id)sender {
    
    self.isHandSearch = YES;
    
    if (self.fininshCaptureBlock) {
        self.fininshCaptureBlock(self);
    }
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}

#pragma mark - DeviceOrientaionDelegate

- (void)directionChange:(TgDirection)direction {
    
    switch (direction) {
        case TgDirectionPortrait:
            
            self.camera.direction = TgDirectionPortrait;
            self.v_masking.isLandscape = NO;
            LxPrintf(@"TgDirectionPortrait");
            
            break;
        case TgDirectionDown:
            
            self.camera.direction = TgDirectionDown;
            self.v_masking.isLandscape = NO;
            LxPrintf(@"TgDirectionDown");
            
            break;
        case TgDirectionRight:
            
            self.camera.direction = TgDirectionRight;
            self.v_masking.isLandscape = YES;
            LxPrintf(@"TgDirectionRight");
            
            break;
        case TgDirectionleft:
            
            self.camera.direction = TgDirectionleft;
            self.v_masking.isLandscape = YES;
            LxPrintf(@"TgDirectionleft");
            
            break;
            
        default:
            
            break;
    }
    [_v_masking layoutSubviews];
    
    
}


#pragma mark - TOCropViewControllerDelegate

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
    
    [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    WS(weakSelf);
    //获取的照片转换成ImageFileInfo对象来得到图片信息，并且赋值name用于服务端需要的key中
    LRShowHUD *hud = [LRShowHUD showWhiteLoadingWithText:@"图片压缩中..." inView:weakSelf.view config:nil];
    
    dispatch_async(dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SW(strongSelf, weakSelf);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            strongSelf.imageInfo = [[ImageFileInfo alloc] initWithImage:image withName:key_file];
            //请求数据获取证件信息
            [hud hide];
            [strongSelf getIdentifyRequest];
            
        });
        
    });
    
}





#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    LxPrintf(@"VehicleCameraVC dealloc");
    [_camera stop];
    _camera = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
