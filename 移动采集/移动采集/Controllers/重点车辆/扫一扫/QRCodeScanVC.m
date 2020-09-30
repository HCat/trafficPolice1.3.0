//
//  QRCodeScanVC.m
//  移动采集
//
//  Created by hcat on 2017/9/6.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "QRCodeScanVC.h"
#import "NSTimer+UnRetain.h"
#import "VehicleCarMoreVC.h"
#import <AVFoundation/AVFoundation.h>

#define HEIGHT SCREEN_HEIGHT-64
#define TOP (HEIGHT-200)/2
#define LEFT (SCREEN_WIDTH-200)/2

#define kScanRect CGRectMake(LEFT, TOP, 200, 200)


@interface QRCodeScanVC ()<AVCaptureMetadataOutputObjectsDelegate>{
    
    CAShapeLayer *cropLayer;
}


@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,assign) int num;
@property (nonatomic,assign) BOOL upOrdown;

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property (strong,nonatomic) UIImageView * line;
@property (strong,nonatomic) UIButton *btn_flash;
@property (strong,nonatomic) UILabel *lb_flash;

@end

@implementation QRCodeScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二维码识别";
    [self configView];
    [self setCropRect:kScanRect];
    [self setupCamera];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (_session != nil && _timer != nil) {
        [_session startRunning];
        [_timer setFireDate:[NSDate date]];
    }

}

#pragma mark - 配置UI

-(void)configView{
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:kScanRect];
    imageView.image = [UIImage imageNamed:@"icon_QRCode_bounds"];
    [self.view addSubview:imageView];
    
    self.upOrdown = NO;
    self.num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT, TOP+10, 200, 2)];
    _line.image = [UIImage imageNamed:@"icon_QRCode_line"];
    [self.view addSubview:_line];
    
    UILabel *t_label = [[UILabel alloc] initWithFrame:CGRectMake(LEFT, CGRectGetMaxY(imageView.frame)+10, 200, 30)];
    t_label.text = @"请将二维码放入框中即可自动扫描";
    t_label.textColor = [UIColor whiteColor];
    t_label.textAlignment = NSTextAlignmentCenter;
    t_label.font = [UIFont systemFontOfSize:13.f];
    [self.view addSubview:t_label];
    
    
//    self.btn_flash = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 58, 58)];
//    
//    [self.btn_flash setCenter:CGPointMake(SCREEN_WIDTH/2, CGRectGetMaxY(t_label.frame)+50)];
//    [self.btn_flash addTarget:self action:@selector(handlebtnFlashClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.btn_flash];
//    
//    self.lb_flash = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
//    self.lb_flash.center = CGPointMake(SCREEN_WIDTH/2, CGRectGetMaxY(self.btn_flash.frame)+5);
//    self.lb_flash.textAlignment = NSTextAlignmentCenter;
//    self.lb_flash.textColor = [UIColor whiteColor];
//    self.lb_flash.font = [UIFont systemFontOfSize:14.f];
//    [self.view addSubview:self.lb_flash];
    
    
    WS(weakSelf);
    self.timer = [NSTimer lr_scheduledTimerWithTimeInterval:.02 repeats:YES block:^(NSTimer *timer) {
        
        if (weakSelf.upOrdown == NO) {
            weakSelf.num ++;
            weakSelf.line.frame = CGRectMake(LEFT, TOP+10+2 * weakSelf.num, 200, 2);
            if (2 * weakSelf.num == 180) {
                weakSelf.upOrdown = YES;
            }
        }
        else {
            weakSelf.num --;
            weakSelf.line.frame = CGRectMake(LEFT, TOP+10+2 * weakSelf.num, 200, 2);
            if (weakSelf.num == 0) {
                weakSelf.upOrdown = NO;
            }
        }
        
        
    }];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    
    
}

#pragma mark - 配置扫描摄像

- (void)setupCamera
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device==nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置扫描区域
    CGFloat top = TOP/SCREEN_HEIGHT;
    CGFloat left = LEFT/SCREEN_WIDTH;
    CGFloat width = 200/SCREEN_WIDTH;
    CGFloat height = 200/SCREEN_HEIGHT;
    ///top 与 left 互换  width 与 height 互换
    [_output setRectOfInterest:CGRectMake(top,left, height, width)];
    

    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =[[UIScreen mainScreen] bounds];
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // Start
    [_session startRunning];
    
    
//    if(_device.flashMode == AVCaptureFlashModeAuto) {
//        self.lb_flash.text = @"自动";
//        [self.btn_flash setImage:[UIImage imageNamed:@"camera_flash_open"] forState:UIControlStateNormal];
//    } else if(_device.flashMode == AVCaptureFlashModeOn) {
//        self.lb_flash.text = @"开启";
//        [self.btn_flash setImage:[UIImage imageNamed:@"camera_flash_open"] forState:UIControlStateNormal];
//    } else if(_device.flashMode == AVCaptureFlashModeOff) {
//        self.lb_flash.text = @"关闭";
//        [self.btn_flash setImage:[UIImage imageNamed:@"camera_flash_close"] forState:UIControlStateNormal];
//    } else {
//        
//    }
}


#pragma mark - 设置毛玻璃

- (void)setCropRect:(CGRect)cropRect{
    
    cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, [[UIScreen mainScreen] bounds]);
    
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.6];
    
    
    [cropLayer setNeedsDisplay];
    
    [self.view.layer addSublayer:cropLayer];
    
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        [_timer setFireDate:[NSDate distantFuture]];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        NSLog(@"扫描结果：%@",stringValue);
        
        if (self.block) {
            self.block(stringValue);
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        NSArray *arry = metadataObject.corners;
        for (id temp in arry) {
            NSLog(@"%@",temp);
        }
        
        WS(weakSelf);
        [VehicleCarMoreVC loadVehicleRequest:VehicleRequestTypeQRCode withNumber:stringValue withBlock:^(VehicleDetailReponse *vehicleDetailReponse) {
            SW(strongSelf, weakSelf);
            VehicleCarMoreVC * t_vc = [[VehicleCarMoreVC alloc] init];
            t_vc.type = VehicleRequestTypeQRCode;
            t_vc.numberId = stringValue;
            t_vc.reponse = vehicleDetailReponse;
            [strongSelf.navigationController pushViewController:t_vc animated:YES];
            
        }];
        
    } else {
        NSLog(@"无扫描信息");
        return;
    }
    
}

#pragma mark - 按钮事件

//闪光灯按钮点击
- (IBAction)handlebtnFlashClicked:(id)sender {
    
    if(_device.flashMode == AVCaptureFlashModeOff) {
        BOOL done = [self updateFlashMode:AVCaptureFlashModeOn];
        if(done) {
            self.lb_flash.text = @"开启";
            [self.btn_flash setImage:[UIImage imageNamed:@"camera_flash_open"] forState:UIControlStateNormal];
        }
    }else if(_device.flashMode == AVCaptureFlashModeOn){
        BOOL done = [self updateFlashMode:AVCaptureFlashModeAuto];
        if(done) {
            self.lb_flash.text = @"自动";
            [self.btn_flash setImage:[UIImage imageNamed:@"camera_flash_open"] forState:UIControlStateNormal];
        }
    }else{
        BOOL done = [self updateFlashMode:AVCaptureFlashModeOff];
        if(done) {
            self.lb_flash.text = @"关闭";
            [self.btn_flash setImage:[UIImage imageNamed:@"camera_flash_close"] forState:UIControlStateNormal];
        }
        
    }
    
}

- (BOOL)updateFlashMode:(AVCaptureFlashMode)cameraFlash
{
    if(!self.session)
        return NO;
    
    AVCaptureFlashMode flashMode;
    
    if(cameraFlash == AVCaptureFlashModeOn) {
        flashMode = AVCaptureFlashModeOn;
    } else if(cameraFlash == AVCaptureFlashModeAuto) {
        flashMode = AVCaptureFlashModeAuto;
    } else {
        flashMode = AVCaptureFlashModeOff;
    }
    
    if([_device isFlashModeSupported:flashMode]) {
        NSError *error;
        if([_device lockForConfiguration:&error]) {
            _device.flashMode = flashMode;
            [_device unlockForConfiguration];
            
            return YES;
        } else {
            return NO;
        }
    }
    else {
        return NO;
    }
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    if (self.timer) {
        [self.timer timeInterval];
        self.timer = nil;
    }
    
    LxPrintf(@"QRCodeScanVC dealloc");

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
