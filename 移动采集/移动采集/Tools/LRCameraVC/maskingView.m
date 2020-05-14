//
//  maskingView.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/31.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "maskingView.h"

#define LineLength 20
#define LineWeight 2

@interface maskingView()

@property (nonatomic,strong) CAShapeLayer * shapeLayer;
@property (nonatomic,strong) UIBezierPath * circlePath;
@property (nonatomic,assign) BOOL isClearnBorder;

@property (nonatomic,strong) UIBezierPath * firstSidePath;
@property (nonatomic,strong) CAShapeLayer * firstSideLayer;

@property (nonatomic,strong) UIBezierPath * secondSidePath;
@property (nonatomic,strong) CAShapeLayer * secondSideLayer;

@property (nonatomic,strong) UIBezierPath * thirdSidePath;
@property (nonatomic,strong) CAShapeLayer * thirdSideLayer;

@property (nonatomic,strong) UIBezierPath * fourthSidePath;
@property (nonatomic,strong) CAShapeLayer * fourthSideLayer;

@end


@implementation maskingView

+(Class)layerClass{
    return [CAShapeLayer class];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.isClearnBorder = NO;
        self.shapeLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.shapeLayer];
        
        self.firstSideLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.firstSideLayer];
        
        self.secondSideLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.secondSideLayer];
        
        self.thirdSideLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.thirdSideLayer];
        
        self.fourthSideLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.fourthSideLayer];
        
    
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:[UIScreen mainScreen].bounds cornerRadius:0];
    
    CGRect myRect = CGRectZero;
    if (!_isLandscape) {
        //竖屏
        [self setType:_type];

    }else{
        //横屏
        CGFloat t_screenWidth   = ScreenWidth;
        CGFloat t_screenHeight  = ScreenHeight;
        
        if(_type == 1){
            myRect = CGRectMake(t_screenWidth/2-(t_screenWidth*3/10),t_screenHeight/2-(t_screenHeight/4),t_screenWidth*3/5, t_screenHeight/2);
        }else if (_type == 2){
            myRect = CGRectMake(t_screenWidth/2-(t_screenWidth*2/6),t_screenHeight/2-(t_screenHeight*2/6),t_screenWidth*2/3, t_screenHeight * 2/3);
        }
        
        [self setNeedsDisplay];
        self.isClearnBorder = YES;
        
        
        
        self.circlePath = [UIBezierPath bezierPathWithRect:myRect];
       
        [path appendPath:_circlePath];
        [path setUsesEvenOddFillRule:YES];
        
        //左上角
        self.firstSidePath                  = [UIBezierPath bezierPath];
        [self.firstSidePath moveToPoint:CGPointMake(CGRectGetMinX(myRect)+LineLength, CGRectGetMinY(myRect))];
        [self.firstSidePath addLineToPoint:CGPointMake(CGRectGetMinX(myRect), CGRectGetMinY(myRect))];
        [self.firstSidePath addLineToPoint:CGPointMake(CGRectGetMinX(myRect), CGRectGetMinY(myRect)+LineLength)];
        self.firstSideLayer.path            = self.firstSidePath.CGPath;
        self.firstSideLayer.lineWidth       = LineWeight;
        self.firstSideLayer.strokeColor     = [UIColor whiteColor].CGColor;
        
        //左下角
        self.secondSidePath                 = [UIBezierPath bezierPath];
        [self.secondSidePath moveToPoint:CGPointMake(CGRectGetMinX(myRect), CGRectGetMaxY(myRect)-LineLength)];
        [self.secondSidePath addLineToPoint:CGPointMake(CGRectGetMinX(myRect), CGRectGetMaxY(myRect))];
        [self.secondSidePath addLineToPoint:CGPointMake(CGRectGetMinX(myRect)+LineLength, CGRectGetMaxY(myRect))];
        self.secondSideLayer.path           = self.secondSidePath.CGPath;
        self.secondSideLayer.lineWidth      = LineWeight;
        self.secondSideLayer.strokeColor    = [UIColor whiteColor].CGColor;
        
        //右下角
        self.thirdSidePath                  = [UIBezierPath bezierPath];
        [self.thirdSidePath moveToPoint:CGPointMake(CGRectGetMaxX(myRect)-LineLength, CGRectGetMaxY(myRect))];
        [self.thirdSidePath addLineToPoint:CGPointMake(CGRectGetMaxX(myRect), CGRectGetMaxY(myRect))];
        [self.thirdSidePath addLineToPoint:CGPointMake(CGRectGetMaxX(myRect), CGRectGetMaxY(myRect)-LineLength)];
        self.thirdSideLayer.path            = self.thirdSidePath.CGPath;
        self.thirdSideLayer.lineWidth       = LineWeight;
        self.thirdSideLayer.strokeColor     = [UIColor whiteColor].CGColor;
        
        //右上角
        self.fourthSidePath                 = [UIBezierPath bezierPath];
        [self.fourthSidePath moveToPoint:CGPointMake(CGRectGetMaxX(myRect), CGRectGetMinY(myRect)+LineLength)];
        [self.fourthSidePath addLineToPoint:CGPointMake(CGRectGetMaxX(myRect), CGRectGetMinY(myRect))];
        [self.fourthSidePath addLineToPoint:CGPointMake(CGRectGetMaxX(myRect)-LineLength, CGRectGetMinY(myRect))];
        self.fourthSideLayer.path           = self.fourthSidePath.CGPath;
        self.fourthSideLayer.lineWidth      = LineWeight;
        self.fourthSideLayer.strokeColor    = [UIColor whiteColor].CGColor;

        _firstSideLayer.fillColor   = [UIColor clearColor].CGColor;
        _secondSideLayer.fillColor  = [UIColor clearColor].CGColor;
        _thirdSideLayer.fillColor   = [UIColor clearColor].CGColor;
        _fourthSideLayer.fillColor  = [UIColor clearColor].CGColor;

        
        self.shapeLayer.path        = path.CGPath;
        self.shapeLayer.fillRule    = kCAFillRuleEvenOdd;
        self.shapeLayer.fillColor   = [UIColor blackColor].CGColor;
        self.shapeLayer.opacity     = 0.95;
        
        WS(weakSelf);
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [weakSelf setNeedsDisplay];
            weakSelf.isClearnBorder = NO;
        });
        
    }

}

- (void) setType:(NSInteger)type{

    _type = type;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:[UIScreen mainScreen].bounds cornerRadius:0];
    CGRect myRect = CGRectZero;
    if (_type == 1) {
        myRect = CGRectMake(ScreenWidth/2-(ScreenWidth * 4/10),ScreenHeight/2-(ScreenHeight/10),ScreenWidth*4/5, ScreenHeight/5);
       
    }else if (_type == 2){
        myRect = CGRectMake(ScreenWidth/2-(ScreenWidth * 5/12),ScreenHeight/2-(ScreenHeight/6),ScreenWidth * 5/6, ScreenHeight/3);
    }
    
    
    [self setNeedsDisplay];
    self.isClearnBorder = YES;
    
    
    self.circlePath = [UIBezierPath bezierPathWithRect:myRect];
    [path appendPath:_circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    //左上角
    self.firstSidePath                  = [UIBezierPath bezierPath];
    [self.firstSidePath moveToPoint:CGPointMake(CGRectGetMinX(myRect)+ LineLength, CGRectGetMinY(myRect))];
    [self.firstSidePath addLineToPoint:CGPointMake(CGRectGetMinX(myRect), CGRectGetMinY(myRect))];
    [self.firstSidePath addLineToPoint:CGPointMake(CGRectGetMinX(myRect), CGRectGetMinY(myRect)+LineLength)];
    self.firstSideLayer.path            = self.firstSidePath.CGPath;
    self.firstSideLayer.lineWidth       = LineWeight;
    self.firstSideLayer.strokeColor     = [UIColor whiteColor].CGColor;
    
    //左下角
    self.secondSidePath                 = [UIBezierPath bezierPath];
    [self.secondSidePath moveToPoint:CGPointMake(CGRectGetMinX(myRect), CGRectGetMaxY(myRect)-LineLength)];
    [self.secondSidePath addLineToPoint:CGPointMake(CGRectGetMinX(myRect), CGRectGetMaxY(myRect))];
    [self.secondSidePath addLineToPoint:CGPointMake(CGRectGetMinX(myRect)+LineLength, CGRectGetMaxY(myRect))];
    self.secondSideLayer.path           = self.secondSidePath.CGPath;
    self.secondSideLayer.lineWidth      = LineWeight;
    self.secondSideLayer.strokeColor    = [UIColor whiteColor].CGColor;
    
    //右下角
    self.thirdSidePath                  = [UIBezierPath bezierPath];
    [self.thirdSidePath moveToPoint:CGPointMake(CGRectGetMaxX(myRect)-LineLength, CGRectGetMaxY(myRect))];
    [self.thirdSidePath addLineToPoint:CGPointMake(CGRectGetMaxX(myRect), CGRectGetMaxY(myRect))];
    [self.thirdSidePath addLineToPoint:CGPointMake(CGRectGetMaxX(myRect), CGRectGetMaxY(myRect)-LineLength)];
    self.thirdSideLayer.path            = self.thirdSidePath.CGPath;
    self.thirdSideLayer.lineWidth       = LineWeight;
    self.thirdSideLayer.strokeColor     = [UIColor whiteColor].CGColor;
    
    //右上角
    self.fourthSidePath                 = [UIBezierPath bezierPath];
    [self.fourthSidePath moveToPoint:CGPointMake(CGRectGetMaxX(myRect), CGRectGetMinY(myRect)+LineLength)];
    [self.fourthSidePath addLineToPoint:CGPointMake(CGRectGetMaxX(myRect), CGRectGetMinY(myRect))];
    [self.fourthSidePath addLineToPoint:CGPointMake(CGRectGetMaxX(myRect)-LineLength, CGRectGetMinY(myRect))];
    self.fourthSidePath.lineCapStyle    = kCGLineCapRound;
    self.fourthSidePath.lineJoinStyle   = kCGLineJoinRound;
    self.fourthSideLayer.path           = self.fourthSidePath.CGPath;
    self.fourthSideLayer.lineWidth      = LineWeight;
    self.fourthSideLayer.strokeColor    = [UIColor whiteColor].CGColor;
    
    _firstSideLayer.fillColor   = [UIColor clearColor].CGColor;
    _secondSideLayer.fillColor  = [UIColor clearColor].CGColor;
    _thirdSideLayer.fillColor   = [UIColor clearColor].CGColor;
    _fourthSideLayer.fillColor  = [UIColor clearColor].CGColor;
    
    _shapeLayer.path            = path.CGPath;
    _shapeLayer.fillRule        = kCAFillRuleEvenOdd;
    _shapeLayer.fillColor       = [UIColor blackColor].CGColor;
    _shapeLayer.opacity         = 0.95;
    
    WS(weakSelf);
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf setNeedsDisplay];
        weakSelf.isClearnBorder = NO;
        
    });

}


- (void) drawRect:(CGRect)rect {
    
    if (_isClearnBorder) {
        _circlePath.lineWidth           = 2;
        UIColor *color                  = [UIColor clearColor];
        [color set];
        _circlePath.lineCapStyle        = kCGLineCapRound;
        _circlePath.lineJoinStyle       = kCGLineJoinRound;
        [_circlePath stroke];
        
        _firstSideLayer.strokeColor     = [UIColor clearColor].CGColor;
        _secondSideLayer.strokeColor    = [UIColor clearColor].CGColor;
        _thirdSideLayer.strokeColor     = [UIColor clearColor].CGColor;
        _fourthSideLayer.strokeColor    = [UIColor clearColor].CGColor;
        
    }else{
        _circlePath.lineWidth           = 2;
        UIColor *color                  = [UIColor clearColor];
        [color set];
        _circlePath.lineCapStyle        = kCGLineCapRound;
        _circlePath.lineJoinStyle       = kCGLineJoinRound;
        [_circlePath stroke];
        
        _firstSideLayer.strokeColor     = [UIColor whiteColor].CGColor;
        _secondSideLayer.strokeColor    = [UIColor whiteColor].CGColor;
        _thirdSideLayer.strokeColor     = [UIColor whiteColor].CGColor;
        _fourthSideLayer.strokeColor    = [UIColor whiteColor].CGColor;
        
    }
    
}

@end
