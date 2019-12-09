//
//  ParkCameraVC.m
//  移动采集
//
//  Created by hcat on 2019/10/16.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkCameraVC.h"
#import <TOCropViewController.h>
#import "LLSimpleCamera.h"
#import "DeviceOrientation.h"
#import "UIButton+NoRepeatClick.h"


#import "PureLayout.h"
#import "maskingView.h"



@interface ParkCameraVC ()<TOCropViewControllerDelegate,DeviceOrientationDelegate>

//LLSimpleCamera是运用AVFoundation自定义的相机对象
@property (strong, nonatomic) LLSimpleCamera *camera;

//闪光灯按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_flash;

//关闭按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_close;

//拍照按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_snap;

@property (weak, nonatomic) IBOutlet maskingView *v_masking;

@property (weak, nonatomic) IBOutlet UILabel *lb_tip;
@property (weak, nonatomic) IBOutlet UILabel *lb_park;



@property (nonatomic,strong) DeviceOrientation *deviceMotion;


@end

@implementation ParkCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    if(_type == 1) {
        
        _v_masking.type = 1;
        _lb_tip.text = @"请扫描车牌号";
    
    }else{
        
        _v_masking.hidden = YES;
        [_v_masking removeFromSuperview];
        
    }
    
    self.btn_flash.isIgnore = YES;
    self.btn_close.isIgnore = YES;
    
    //初始化照相机，通过AVFoundation自定义的相机
    [self initializeCamera];
    self.deviceMotion = [[DeviceOrientation alloc]initWithDelegate:self];
    [_deviceMotion startMonitor];
    
    
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    _lb_tip.hidden = NO;
    if (self.park_string) {
        _lb_park.text = [NSString stringWithFormat:@"泊位号：%@",self.park_string];
    }
    
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
    
    [self.lb_park mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(25);
        
    }];
    
    self.deviceMotion = [[DeviceOrientation alloc] initWithDelegate:self];
    [_deviceMotion startMonitor];

}

- (void)viewDidDisappear:(BOOL)animated{
    
    //停止拍照
    [_deviceMotion stop];
    [self.camera stop];
    [super viewDidDisappear:animated];
}

#pragma mark - 初始化相机对象

-(void)initializeCamera{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    // 创建一个相机
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh  position:LLCameraPositionRear
                                             videoEnabled:NO];
    
    
    // 关联到具体的VC中
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    [self.camera.view configureForAutoLayout];
    [self.camera.view autoPinEdgesToSuperviewEdges];
    self.camera.fixOrientationAfterCapture = YES;
    self.camera.useDeviceOrientation = YES;
    
    
    WS(weakSelf);
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        SW(strongSelf, weakSelf);
        
        // 检查闪关灯状态
        if([camera isFlashAvailable]) {
            strongSelf.btn_flash.hidden = NO;
            
            if(camera.flash == LLCameraFlashOff) {

                [strongSelf.btn_flash setImage:[UIImage imageNamed:@"camera_flash_off"] forState:UIControlStateNormal];
                
            }else if(camera.flash == LLCameraFlashOn){

                [strongSelf.btn_flash setImage:[UIImage imageNamed:@"camera_flash_on"] forState:UIControlStateNormal];
            }else{
                 
                 [strongSelf.btn_flash setImage:[UIImage imageNamed:@"camera_flash_zidong"] forState:UIControlStateNormal];
            }
        }
        else {
            strongSelf.btn_flash.hidden = YES;
        }
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        SW(strongSelf, weakSelf);
        LxPrintf(@"Camera error: %@", error);
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission) {
                [LRShowHUD showError:@"未获取相机权限" duration:1.5f inView:strongSelf.view config:nil];
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
            
            SW(strongSelf, weakSelf);
            //拍照成功之后，如果成功调用TOCropViewController 对照片进行裁剪
            
            LxDBAnyVar(image.size.width);
            LxDBAnyVar(image.size.height);
            
            if (strongSelf.type == 1) {
                
                CGRect t_frame = CGRectZero;
                
                if (strongSelf.v_masking.isLandscape) {
                    t_frame = CGRectMake(image.size.width/2-(image.size.width*3/10),image.size.height/2-(image.size.height/4),image.size.width*3/5, image.size.height/2);
                }else{
                    t_frame = CGRectMake(image.size.width/2-(image.size.width * 4/10),image.size.height/2-(image.size.height/10),image.size.width*4/5, image.size.height/5);
                }
                image = [self ct_imageFromImage:image inRect:t_frame];
                
                LxPrintf(@"截图结束。。。。。。。。。。。。");
                
            }
            
            TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
            cropController.delegate = strongSelf;
            cropController.cropView.gridOverlayView.hidden = YES;
            cropController.toolbar.clampButtonHidden = YES;
            cropController.toolbar.rotateCounterclockwiseButtonHidden = YES;
            cropController.toolbar.rotateClockwiseButtonHidden = YES;

            
            [strongSelf presentViewController:cropController animated:YES completion:nil];
            
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
            
            [self.btn_flash setImage:[UIImage imageNamed:@"camera_flash_on"] forState:UIControlStateNormal];
        }
    }else if(self.camera.flash == LLCameraFlashOn){
        
        BOOL done = [self.camera updateFlashMode:LLCameraFlashAuto];
        if(done) {

            [self.btn_flash setImage:[UIImage imageNamed:@"camera_flash_zidong"] forState:UIControlStateNormal];
        }
    }else{
        
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOff];
        if(done) {
            [self.btn_flash setImage:[UIImage imageNamed:@"camera_flash_off"] forState:UIControlStateNormal];
        }
        
    }
    
}

#pragma mark - DeviceOrientaionDelegate

- (void)directionChange:(TgDirection)direction {
    
    switch (direction) {
        case TgDirectionPortrait:{
            
            self.camera.direction = TgDirectionPortrait;
            self.v_masking.isLandscape = NO;
            
            self.lb_park.transform = CGAffineTransformMakeRotation(0);
            
            [self.lb_park mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view.mas_centerX);
                make.top.equalTo(self.view.mas_top).with.offset(25);
                
            }];
            
            self.lb_tip.transform = CGAffineTransformMakeRotation(0);
            
            LxPrintf(@"TgDirectionPortrait");
        }
            break;
        case TgDirectionDown:{
            
            self.camera.direction = TgDirectionDown;
            self.v_masking.isLandscape = NO;
            
            self.lb_park.transform = CGAffineTransformMakeRotation(0);
            
            [self.lb_park mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view.mas_centerX);
                make.top.equalTo(self.view.mas_top).with.offset(25);
                
            }];
            
            self.lb_tip.transform = CGAffineTransformMakeRotation(0);
                       
            LxPrintf(@"TgDirectionDown");
        }
            break;
        case TgDirectionRight:{
            
            self.camera.direction = TgDirectionRight;
            self.v_masking.isLandscape = YES;
            
            self.lb_park.transform = CGAffineTransformMakeRotation(-M_PI / 2);
            
            [self.lb_park mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.view.mas_centerY);
                make.leading.equalTo(self.view.mas_leading).with.offset(-35);
                
            }];
            self.lb_tip.transform = CGAffineTransformMakeRotation(-M_PI / 2);
            
           
            LxPrintf(@"TgDirectionRight");
         }
            break;
        case TgDirectionleft:{
            
            self.camera.direction = TgDirectionleft;
            self.v_masking.isLandscape = YES;
            
            self.lb_park.transform = CGAffineTransformMakeRotation(M_PI / 2);
            
            [self.lb_park mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.view.mas_centerY);
                make.right.equalTo(self.view.mas_right).with.offset(35);
                
            }];
            self.lb_tip.transform = CGAffineTransformMakeRotation(M_PI / 2);
            
            LxPrintf(@"TgDirectionleft");
        }
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
            
            strongSelf.imageInfo = [[ImageFileInfo alloc] initWithImage:image withName:key_files];
            
            if (strongSelf.fininshCaptureBlock) {
                strongSelf.fininshCaptureBlock(strongSelf.imageInfo);
            }
            
            [strongSelf dismissViewControllerAnimated:YES completion:^{
                [hud hide];
            }];
            
        });
        
    });

}


- (UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGFloat scale = 1 ;

    CGRect rect2 = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, scale * rect.size.width, scale * rect.size.height);

    CGImageRef cgImg = CGImageCreateWithImageInRect(image.CGImage, rect2);

    UIImage *clippedImg = [UIImage imageWithCGImage:cgImg];

    CGImageRelease(cgImg);
    
    return clippedImg;
    
}



#pragma mark - dealloc

- (void)dealloc{
    LxPrintf(@"ParkCameraVC dealloc");

    [_camera stop];
    _camera = nil;
}

@end
