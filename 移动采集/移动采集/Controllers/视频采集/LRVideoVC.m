//
//  LRVideoVC.m
//  trafficPolice
//
//  Created by hcat on 2017/6/6.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "LRVideoVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <Masonry.h>

#import "ArtAnimationRecordView.h"
#import "ArtPlayerView.h"
#import "ArtVideoModel.h"

#import "ArtVideoUtil.h"
#import "UIButton+Block.h"

#define DataOutputType 1 //代表是通过AVAssetWriter导出视频

@interface LRVideoVC ()<
//AVCaptureFileOutputRecordingDelegate,
AVCaptureVideoDataOutputSampleBufferDelegate,
AVCaptureAudioDataOutputSampleBufferDelegate>
{
    AVCaptureSession *_videoSession;
    AVCaptureVideoPreviewLayer *_videoPreLayer;
    AVCaptureDevice *_videoDevice;
    AVCaptureDevice *_audioDevice;
    AVCaptureDeviceInput        *_videoInput;
    AVCaptureDeviceInput        *_audioInput;
    
    //通过AVCaptureMovieFileOutput 导出视频
    AVCaptureMovieFileOutput    *_movieOutput;
    
    //通过AVAssetWriter 导出输出视频
    AVCaptureVideoDataOutput *_videoDataOut;
    AVCaptureAudioDataOutput *_audioDataOut;
    AVAssetWriter *_assetWriter;
    AVAssetWriterInputPixelBufferAdaptor *_assetWriterPixelBufferInput;
    AVAssetWriterInput *_assetWriterVideoInput;
    AVAssetWriterInput *_assetWriterAudioInput;
    CMTime _currentSampleTime;
    
    
    BOOL _isCancelRecord;
    
    NSString *_savePath;
    
    dispatch_queue_t _recoding_queue;
}

@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOut;
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioDataOut;

@property (nonatomic, strong) UIButton *btn_back;           //返回按钮
@property (nonatomic, strong) UILabel *lb_tip;              //提示按钮
@property (nonatomic, strong) UIButton *btn_send;           //发送按钮
@property (nonatomic, strong) UIButton *btn_cancel;         //取消按钮
@property (nonatomic, strong) ArtAnimationRecordView *btn_record;    //录制按钮

@property (nonatomic, strong) UIView *videoView;            //录制视图
@property (nonatomic, strong) ArtPlayerView *playerView;    //播放视图

@property (nonatomic, assign) BOOL recoding;                //是否在录制
@property (nonatomic, strong) ArtVideoModel *currentRecord; //视频录像模型

@end

@implementation LRVideoVC

#pragma mark - viewlife

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化UI
    [self makeUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self setupVideo];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showBtn];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



#pragma mark - 配置UI

- (void)makeUI
{
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.btn_record mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@80);
        make.bottom.equalTo(self.view).offset(-30);
        make.centerX.equalTo(self.view);
    }];
    
    [self.lb_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.btn_record.mas_top).offset(-22);
        make.centerX.equalTo(self.btn_record);
    }];
    
    [self.btn_send mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btn_record);
        make.trailing.equalTo(self.view).offset(-30);
        
    }];
    [self.btn_back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btn_record);
        make.leading.equalTo(self.view).offset(30);
    }];

    
    [self.btn_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btn_record);
        make.leading.equalTo(self.view).offset(30);
    }];
    
    
    WS(weakSelf);
    self.btn_record.startRecord = ^(){
        SW(strongSelf, weakSelf);
        [strongSelf startRecord];
        [strongSelf hideBtn];
    };
    
    self.btn_record.completeRecord = ^(CFTimeInterval recordTime){
        weakSelf.recoding = NO;
        if (recordTime < 1.) {
            [LRShowHUD showTextOnly:@"录制时间太短了哦" duration:1.f inView:weakSelf.view config:nil];
            return ;
        }
        [weakSelf saveVideo:^(NSURL *outFileURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!outFileURL) {
                    //[ArtProgressHUD showInfoWithStatus:@"视频录制失败"];
                }
                [weakSelf stopRecord];
                [weakSelf addPlayerView];
            });
        }];
        [weakSelf remakeBtnLayout];
    };
}

#pragma mark - 添加播放视图

- (void)addPlayerView {
    
    NSURL *videoURL = [NSURL fileURLWithPath:self.currentRecord.videoAbsolutePath];
    self.playerView = [[ArtPlayerView alloc] initWithFrame:[UIScreen mainScreen].bounds videoUrl:videoURL];
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.playerView play];
    [self stopRunning];
    
    [self.view insertSubview:self.playerView aboveSubview:self.videoView];
}



#pragma mark - 设置录像视图

- (void)setupVideo {
    NSString *unUseInfo = nil;
    if (TARGET_IPHONE_SIMULATOR) {
        unUseInfo = @"模拟器不可以的..";
    }
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(videoAuthStatus == ALAuthorizationStatusRestricted || videoAuthStatus == ALAuthorizationStatusDenied){
        unUseInfo = @"相机访问受限...";
    }
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(audioAuthStatus == ALAuthorizationStatusRestricted || audioAuthStatus == ALAuthorizationStatusDenied){
        unUseInfo = @"录音访问受限...";
    }
    
    [self configureSession];
}

#pragma mark - 配置相关视频需要的AVFoundtion 

- (void)configureSession
{
    _recoding_queue = dispatch_queue_create("com.artstudio.queue", DISPATCH_QUEUE_SERIAL);
    
    _videoSession = [[AVCaptureSession alloc] init];
    if ([_videoSession canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        _videoSession.sessionPreset = AVCaptureSessionPreset640x480;
    }
    
    [_videoSession beginConfiguration];
    
    [self addVideo];    //添加视频硬件
    [self addAudio];    //添加音频硬件
    [self addPreviewLayer];
    
    [_videoSession commitConfiguration];
    
    [_videoSession startRunning];
}

- (void)addVideo
{
    _videoDevice = [self deviceWithMediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    [self addVideoInput];
#ifdef DataOutputType
    [self addVideoOutput];
#else
    [self addMovieOutput];
#endif
}

- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType position:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = devices.firstObject;
    
    for (AVCaptureDevice *device in devices)
    {
        if (device.position == position)
        {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

- (void)addVideoInput
{
    if (!_videoDevice || !_videoSession)
    {
        return;
    }
    
    NSError *error;
    
    // 视频输入对象
    // 根据输入设备初始化输入对象，用户获取输入数据
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:&error];
    if (error)
    {
        NSLog(@"获取摄像头出错--->>>%@",error);
        return;
    }
    
    // 将视频输入对象添加到会话 (AVCaptureSession) 中
    if ([_videoSession canAddInput:_videoInput])
    {
        [_videoSession addInput:_videoInput];
    }
}

- (void)addAudio
{
    NSError *error;
    // 添加一个音频输入设备
    _audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    //  音频输入对象
    _audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:_audioDevice error:&error];
    if (error)
    {
        NSLog(@"获取音频设备出错--->>>%@",error);
        return;
    }
    // 将音频输入对象添加到会话 (AVCaptureSession) 中
    if ([_videoSession canAddInput:_audioInput])
    {
        [_videoSession addInput:_audioInput];
    }
    
#ifdef DataOutputType
    [self addAudioOutput];
#else
#endif
}

- (void)addVideoOutput
{
    _videoDataOut = [[AVCaptureVideoDataOutput alloc] init];
    _videoDataOut.videoSettings = @{(__bridge NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};
    _videoDataOut.alwaysDiscardsLateVideoFrames = YES;
    [_videoDataOut setSampleBufferDelegate:self queue:_recoding_queue];
    if ([_videoSession canAddOutput:_videoDataOut]) {
        [_videoSession addOutput:_videoDataOut];
    }
    AVCaptureConnection *captureConnection = [_videoDataOut connectionWithMediaType:AVMediaTypeVideo];
    captureConnection.enabled = YES;
    [captureConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
}

- (void)addAudioOutput
{
    _audioDataOut = [[AVCaptureAudioDataOutput alloc] init];
    [_audioDataOut setSampleBufferDelegate:self queue:_recoding_queue];
    if ([_videoSession canAddOutput:_audioDataOut]) {
        [_videoSession addOutput:_audioDataOut];
    }
}

- (void)addMovieOutput
{
    if (!_videoSession)
    {
        return;
    }
    // 拍摄视频输出对象
    // 初始化输出设备对象，用户获取输出数据
    _movieOutput = [[AVCaptureMovieFileOutput alloc] init];
    //  [_movieOutput connectionWithMediaType:AVMediaTypeVideo].videoOrientation=AVCaptureVideoOrientationPortrait;
    
    if ([_videoSession canAddOutput:_movieOutput])
    {
        [_videoSession addOutput:_movieOutput];
        
        AVCaptureConnection *captureConnection = [_movieOutput connectionWithMediaType:AVMediaTypeVideo];
        if([captureConnection isVideoOrientationSupported])
        {
            [captureConnection setVideoOrientation:[[UIDevice currentDevice] orientation]];
        }
        
        if ([captureConnection isVideoStabilizationSupported])
        {
            if ([captureConnection respondsToSelector:@selector(setPreferredVideoStabilizationMode:)])
            {
                captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
            }
        }
        
        captureConnection.videoScaleAndCropFactor = captureConnection.videoMaxScaleAndCropFactor;
    }
}

//创建预览层
- (void)addPreviewLayer
{
    _videoPreLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_videoSession];
    _videoPreLayer.frame = [UIScreen mainScreen].bounds;
    _videoPreLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
#ifdef DataOutputType
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        _videoPreLayer.connection.videoOrientation = orientation == UIInterfaceOrientationLandscapeLeft ? AVCaptureVideoOrientationLandscapeLeft : AVCaptureVideoOrientationLandscapeRight;
    }
#else
    _videoPreLayer.connection.videoOrientation = [_movieOutput connectionWithMediaType:AVMediaTypeVideo].videoOrientation;
#endif
    [_videoView.layer addSublayer:_videoPreLayer];
}


#pragma mark - privateMethods

- (void)startRecord
{
    self.currentRecord = [ArtVideoUtil createNewVideo];
    NSURL *outURL = [NSURL fileURLWithPath:self.currentRecord.videoAbsolutePath];
#ifdef DataOutputType
    NSLog(@"视频开始录制");
    [self createWriter:outURL];
    self.recoding = YES;
#else
    [_movieOutput startRecordingToOutputFileURL:outURL recordingDelegate:self];
#endif
    
}

- (void)stopRecord
{
    // 取消视频拍摄
    [_movieOutput stopRecording];
}

- (void)startRunning
{
    [_videoSession startRunning];
}

- (void)stopRunning
{
    [_videoSession stopRunning];
}

#pragma mark - UI操作

- (void)showBtn
{
    self.btn_back.hidden = NO;
    self.btn_cancel.hidden = YES;
    [self.view bringSubviewToFront:self.btn_back];
    [self.view sendSubviewToBack:self.btn_cancel];
    self.lb_tip.hidden = NO;
    self.lb_tip.alpha = 1.0;
    [UIView animateWithDuration:0.2 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.lb_tip.alpha = 0.;
    } completion:^(BOOL finished) {
        self.lb_tip.hidden = YES;
    }];
}

- (void)hideBtn {
    self.btn_back.hidden = YES;
    self.btn_cancel.hidden = NO;
    self.lb_tip.hidden = YES;
}

- (void)remakeBtnLayout
{

    [UIView animateWithDuration:0.25 animations:^{
        self.btn_send.alpha = 1.;
        self.btn_cancel.alpha = 1.;
        self.btn_record.alpha = 0.;
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:self.btn_cancel];
        [self.view sendSubviewToBack:self.btn_back];
    }];
}

- (void)resetBtnLayout
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
        self.btn_send.alpha = 0.;
        self.btn_cancel.alpha = 0.;
        self.btn_record.alpha = 1.;
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:self.btn_back];
        [self.view sendSubviewToBack:self.btn_cancel];

    }];
}


#pragma mark -

- (void)createWriter:(NSURL *)assetUrl {
    _assetWriter = [AVAssetWriter assetWriterWithURL:assetUrl fileType:AVFileTypeMPEG4 error:nil];
    int videoWidth = [UIScreen mainScreen].bounds.size.width;
    int videoHeight = [UIScreen mainScreen].bounds.size.height;
    
    
    NSDictionary *outputSettings = @{
                                     AVVideoCodecKey : AVVideoCodecH264,
                                     AVVideoWidthKey : @(videoWidth),
                                     AVVideoHeightKey : @(videoHeight),
                                     AVVideoScalingModeKey:AVVideoScalingModeResizeAspectFill,
                                     //                          AVVideoCompressionPropertiesKey:codecSettings
                                     };
    _assetWriterVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:outputSettings];
    _assetWriterVideoInput.expectsMediaDataInRealTime = YES;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        CGFloat rotation = orientation == UIInterfaceOrientationLandscapeRight ? 0. : M_PI;
        _assetWriterVideoInput.transform = CGAffineTransformMakeRotation(rotation);
    }
    
    
    NSDictionary *audioOutputSettings = @{
                                          AVFormatIDKey:@(kAudioFormatMPEG4AAC),
                                          AVEncoderBitRateKey:@(64000),
                                          AVSampleRateKey:@(44100),
                                          AVNumberOfChannelsKey:@(1),
                                          };
    
    _assetWriterAudioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:audioOutputSettings];
    _assetWriterAudioInput.expectsMediaDataInRealTime = YES;
    
    
    NSDictionary *SPBADictionary = @{
                                     (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
                                     (__bridge NSString *)kCVPixelBufferWidthKey : @(videoWidth),
                                     (__bridge NSString *)kCVPixelBufferHeightKey  : @(videoHeight),
                                     (__bridge NSString *)kCVPixelFormatOpenGLESCompatibility : ((__bridge NSNumber *)kCFBooleanTrue)
                                     };
    _assetWriterPixelBufferInput = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:_assetWriterVideoInput sourcePixelBufferAttributes:SPBADictionary];
    if ([_assetWriter canAddInput:_assetWriterVideoInput]) {
        [_assetWriter addInput:_assetWriterVideoInput];
    }else {
        NSLog(@"不能添加视频writer的input \(assetWriterVideoInput)");
    }
    if ([_assetWriter canAddInput:_assetWriterAudioInput]) {
        [_assetWriter addInput:_assetWriterAudioInput];
    }else {
        NSLog(@"不能添加视频writer的input \(assetWriterVideoInput)");
    }
}

- (void)saveVideo:(void(^)(NSURL *outFileURL))complier {
    
    if (_recoding) return;
    
    if (!_recoding_queue){
        complier(nil);
        return;
    };
    
    WS(weakSelf);
    dispatch_async(_recoding_queue, ^{
        SW(strongSelf, weakSelf);
        NSURL *outputFileURL = [NSURL fileURLWithPath:_currentRecord.videoAbsolutePath];
        NSLog(@"=====writer status = %tu",_assetWriter.status);
        if (_assetWriter.status != AVAssetWriterStatusWriting) {
            complier(nil);
            return ;
        }
        //_assetWriter.status == 0 时调用该方法会崩溃
        [_assetWriter finishWritingWithCompletionHandler:^{
            [ArtVideoUtil saveThumImageWithVideoURL:outputFileURL second:1 errorBlock:^(NSError *error) {
                //[weakSelf showErrorText:[error localizedDescription]];
            }];
            if (complier) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    complier(outputFileURL);
                });
            }
            if (strongSelf.savePhotoAlbum) {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputFileURL];
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    if (!error && success) {
                        NSLog(@"保存相册成功!");
                    }
                    else {
                        NSLog(@"保存相册失败! :%@",error);
                    }
                }];
            }
        }];
    });
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    if (!_recoding) return;
    
    @autoreleasepool {
        _currentSampleTime = CMSampleBufferGetOutputPresentationTimeStamp(sampleBuffer);
        if (_assetWriter.status != AVAssetWriterStatusWriting) {
            [_assetWriter startWriting];
            [_assetWriter startSessionAtSourceTime:_currentSampleTime];
        }
        if (captureOutput == _videoDataOut) {
            if (_assetWriterPixelBufferInput.assetWriterInput.isReadyForMoreMediaData) {
                CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
                BOOL success = [_assetWriterPixelBufferInput appendPixelBuffer:pixelBuffer withPresentationTime:_currentSampleTime];
                if (!success) {
                    NSLog(@"Pixel Buffer没有append成功");
                }
            }
        }
        if (captureOutput == _audioDataOut) {
            [_assetWriterAudioInput appendSampleBuffer:sampleBuffer];
        }
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
}


#pragma mark - lazy Set && get
- (UIView *)videoView
{
    if(!_videoView){
        _videoView = [[UIView alloc] init];
        [self.view addSubview:_videoView];
    }
    return _videoView;
}

- (ArtAnimationRecordView *)btn_record
{
    if(!_btn_record){
        _btn_record = [[ArtAnimationRecordView alloc] init];
        [self.view addSubview:_btn_record];
    }
    return _btn_record;
}

- (UIButton *)btn_send
{
    if(!_btn_send){
        _btn_send = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_send setImage:[UIImage imageNamed:@"camera_send"] forState:UIControlStateNormal];
        [_btn_send setEnlargeEdgeWithTop:25.f right:25.f bottom:25.f left:25.f];
        [_btn_send addTarget:self action:@selector(handleBtnSendClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btn_send.alpha = 0.;
        [self.view addSubview:_btn_send];
    }
    return _btn_send;
}

- (UIButton *)btn_cancel
{
    if(!_btn_cancel){
        _btn_cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_cancel setImage:[UIImage imageNamed:@"camera_close"] forState:UIControlStateNormal];
        [_btn_cancel setEnlargeEdgeWithTop:25.f right:25.f bottom:25.f left:25.f];
        [_btn_cancel addTarget:self action:@selector(handleBtnCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btn_cancel.alpha = 0.;
        [self.view addSubview:_btn_cancel];
    }
    return _btn_cancel;
}

- (UIButton *)btn_back
{
    if(!_btn_back){
        _btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_back setImage:[UIImage imageNamed:@"camera_close"] forState:UIControlStateNormal];
        [_btn_back setEnlargeEdgeWithTop:25.f right:25.f bottom:25.f left:25.f];
        [_btn_back addTarget:self action:@selector(handleBtnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btn_back];
    }
    return _btn_back;
}

- (UILabel *)lb_tip
{
    if(!_lb_tip){
        _lb_tip = [[UILabel alloc] init];
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeMake(1, 1);
        shadow.shadowColor = [UIColor colorWithWhite:0 alpha:0.8];
        shadow.shadowBlurRadius = 6;
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc]initWithString:@"点击开始录制" attributes:@{
                                                                                                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:15.],
                                                                                                                 NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                                                 NSShadowAttributeName:shadow
                                                                                                                 }];
        _lb_tip.attributedText = one;
        [self.view addSubview:_lb_tip];
    }
    return _lb_tip;
}

#pragma mark - buttonMethods

- (void)handleBtnSendClicked:(id)sender{

    if (self.recordComplete) {
        self.recordComplete(self.currentRecord);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleBtnCancelClicked:(id)sender{

    [self showBtn];
    [self resetBtnLayout];
    [self.playerView stop];
    [self.playerView removeFromSuperview];
    self.playerView = nil;
    [self startRunning];
    [ArtVideoUtil deleteVideo:self.currentRecord.videoAbsolutePath];

}

- (void)handleBtnBackClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    LxPrintf(@"LRVideoVC dealloc");

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
