//
//  ArtAnimationRecordView.m
//  ArtStudio
//
//  Created by lbq on 2017/2/8.
//  Copyright © 2017年 kimziv. All rights reserved.
//

#import "ArtAnimationRecordView.h"
#import <Masonry.h>
//#import "ArtMicroVideoConfig.h"

#define kCircleLineWidth 7.
// 视频录制 时长
#define kRecordTime        30.0

@interface ArtAnimationRecordView()<CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *readyImageView;
@property (nonatomic, strong) UIImageView *startImageView;


@property (nonatomic, assign) CFTimeInterval startTime;
//@property (nonatomic, assign) CFTimeInterval stopTime;

@property (nonatomic, strong) CAShapeLayer *arcLayer;

@property (nonatomic, assign) BOOL isRecoad;

@end

@implementation ArtAnimationRecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
        self.isRecoad = NO;
    }
    return self;
}
   
- (void)makeUI
{
    [self.readyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80.);
        make.height.equalTo(@80.);
        make.center.equalTo(self);
    }];
    
    [self.startImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80.);
        make.height.equalTo(@80.);
        make.center.equalTo(self);
    }];
    
    UITapGestureRecognizer *tapPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapPress];
    
}

- (void)addCircleLayer
{
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGRect rect = CGRectMake(0, 0, 80., 80.);
    [path addArcWithCenter:CGPointMake(40., 40.) radius:((rect.size.height - kCircleLineWidth)/2.) startAngle:-M_PI_2 endAngle:2*M_PI clockwise:YES];
    if (self.arcLayer) {
        [self.arcLayer removeAnimationForKey:@"CircleAnimantion"];
        [self.arcLayer removeFromSuperlayer];
        self.arcLayer = nil;
    }
    self.arcLayer = [CAShapeLayer layer];
    self.arcLayer.path = path.CGPath;//46,169,230
    self.arcLayer.fillColor = [UIColor clearColor].CGColor;
    self.arcLayer.strokeColor = UIColorFromRGB(0x4281E8).CGColor;
    self.arcLayer.lineWidth = kCircleLineWidth;
    self.arcLayer.frame = rect;
    [self.startImageView.layer addSublayer:self.arcLayer];
    [self drawLineAnimation];
}
//定义动画过程
-(void)drawLineAnimation
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = kRecordTime;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [self.arcLayer addAnimation:bas forKey:@"CircleAnimantion"];
}

- (void)handleTapGesture:(UIGestureRecognizer *)gesture{

    self.isRecoad = !_isRecoad;
    
    if (self.isRecoad) {
        //开始录像
        NSLog(@"began");
        [self startAnimation];
    }else{
        //结束录像
        NSLog(@"end");
        [self endAnimation];
    }
    
}

- (void)startAnimation
{

    [UIView animateWithDuration:0.2 animations:^{
        self.readyImageView.alpha = 0.;
        self.startImageView.alpha = 1.0;
        [self layoutIfNeeded];
    }completion:^(BOOL finished) {
        [self addCircleLayer];
    }];
}

- (void)endAnimation
{

    [self.arcLayer removeAnimationForKey:@"CircleAnimantion"];
    [self.arcLayer removeFromSuperlayer];
    [UIView animateWithDuration:0.2 animations:^{
        self.readyImageView.alpha = 1.;
        self.startImageView.alpha = 0.;
        [self layoutIfNeeded];
    }completion:^(BOOL finished) {
        [self.arcLayer removeAnimationForKey:@"CircleAnimantion"];
        [self.arcLayer removeFromSuperlayer];
        self.arcLayer = nil;
    }];
}

//MARK: CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    self.startTime = CACurrentMediaTime();
    NSLog(@"leoliu=====didStart time = %f",self.startTime);
    
    if (self.startRecord) {
        self.startRecord();
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CFTimeInterval didStopTime = CACurrentMediaTime() - self.startTime;
    NSLog(@"leoliu=====stop flag = %tu  stopTime = %f",flag,didStopTime);
    [self endAnimation];
    if (self.completeRecord) {
        self.completeRecord(didStopTime);
    }
}

//MARK: lazy
- (UIImageView *)readyImageView
{
    if(!_readyImageView){
        _readyImageView = [[UIImageView alloc] init];
        _readyImageView.image = [UIImage imageNamed:@"video_unRecoard"];
        _readyImageView.alpha = 1.;
        _readyImageView.userInteractionEnabled = YES;
        [self addSubview:_readyImageView];
    }
    return _readyImageView;
}

- (UIImageView *)startImageView
{
    if(!_startImageView){
        _startImageView = [[UIImageView alloc] init];
        _startImageView.image = [UIImage imageNamed:@"video_recoard"];
        _startImageView.alpha = 0.;
        _startImageView.userInteractionEnabled = YES;
        [self addSubview:_startImageView];
    }
    return _startImageView;
}
@end
