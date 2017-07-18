//
//  LRCountDownButton.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/17.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "LRCountDownButton.h"
#import "NSTimer+UnRetain.h"


/**
 *  注意事项:
 *  在XIB,SB,或者是在代码中创建Button的时候,Button的样式要设置成为 Custom 样式,否则在倒计时过程中 Button 的Tittle 会闪动.
 */

@interface LRCountDownButton ()


/** 保存起始状态下的title */
@property (nonatomic, copy) NSString *originalTitle;

/** 保存倒计时的时长 */
@property (nonatomic, assign) NSInteger tempDurationOfCountDown;

/** 定时器对象 */
@property (nonatomic,strong) NSTimer *timer_countDown;

/** 避免开始计时时快速连续点击显示问题 */
@property (nonatomic,assign) int count;

@end



@implementation LRCountDownButton

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    // 倒计时过程中title的改变不更新originalTitle
    
    [self setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    if (self.tempDurationOfCountDown == self.durationOfCountDown) {
        self.originalTitle = title;
        
        self.originalColor = self.titleLabel.textColor;
    }
}

#pragma mark - set or get

- (void)setDurationOfCountDown:(NSInteger)durationOfCountDown {
    _durationOfCountDown = durationOfCountDown;
    self.tempDurationOfCountDown = _durationOfCountDown;
}

- (void)setOriginalColor:(UIColor *)originalColor {
    
    _originalColor = originalColor;
    
    [self setTitleColor:originalColor forState:UIControlStateNormal];
}

- (void)setProcessColor:(UIColor *)processColor {
    
    _processColor = processColor;
    
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        if (self.originalColor) {
            
            [self setTitleColor:self.originalColor forState:UIControlStateNormal];
        } else {
            
            //默认颜色红色
            [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        
        self.count = 0;
        // 设置默认的倒计时时长为60秒
        self.durationOfCountDown = 60;
        // 设置button的默认标题为“获取验证码”
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        if (self.originalColor) {
            [self setTitleColor:self.originalColor forState:UIControlStateNormal];
        } else {
            //默认颜色白色
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        self.count = 0;
        // 设置默认的倒计时时长为60秒
        self.durationOfCountDown = 60;
        // 设置button的默认标题为“获取验证码”
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    return self;
}

#pragma mark - UITouch

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self.count ++;
    // 若正在倒计时，不响应点击事件
    if (self.tempDurationOfCountDown != self.durationOfCountDown||self.count != 1) {
        self.count = 0;
        self.enabled = NO;
        return NO;
    }
    // 若未开始倒计时，响应并传递点击事件，开始倒计时
    if (self.beginBlock) {
        self.beginBlock();
    }
    return [super beginTrackingWithTouch:touch withEvent:event];
}

#pragma mark - public methods

//创建定时器，开始倒计时
- (void)startCountDown {
    
    /*** 这里运用 NSTimer+UnRetain 分类防止计时器循环引用，iOS10 中 有相应的block方法，原理和这个分类一样
     ****/
    // 创建定时器
    __weak typeof(self) weakSelf = self;
    self.timer_countDown = [NSTimer lr_scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer *timer) {
        __strong typeof(self) strongSelf = weakSelf;
        
        //更新LRCountDownButton的title为倒计时剩余的时间

        if (strongSelf.tempDurationOfCountDown == 0) {
            // 设置LRCountDownButton的title为开始倒计时前的title
            [strongSelf setTitle:strongSelf.originalTitle forState:UIControlStateNormal];
            if (strongSelf.originalColor) {
                [strongSelf setTitleColor:strongSelf.originalColor forState:UIControlStateNormal];
            } else {
                //默认颜色 白色
                [strongSelf setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
            [strongSelf setBackgroundColor:strongSelf.originalBGColor];
            // 恢复LRCountDownButton开始倒计时
            strongSelf.tempDurationOfCountDown = self.durationOfCountDown;
            [strongSelf.timer_countDown invalidate];
            strongSelf.timer_countDown = nil;
            strongSelf.count = 0;
            strongSelf.enabled = YES;
        } else {
            // 设置LRCountDownButton的title为当前倒计时剩余的时间
            [strongSelf setTitle:[NSString stringWithFormat:@"重新发送验证码(%zds)", self.tempDurationOfCountDown--] forState:UIControlStateNormal];
             [strongSelf setBackgroundColor:strongSelf.processBGColor];
            if (strongSelf.processColor) {
                [strongSelf setTitleColor:strongSelf.processColor forState:UIControlStateNormal];
            } else {
                //默认颜色 白色
                [strongSelf setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
            if (strongSelf.processFont) {
                [self.titleLabel setFont:self.processFont];
            }else{
                [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
            }
        }
    }];
    
    // 将定时器添加到通用的NSRunLoopCommonModes中
    [[NSRunLoop currentRunLoop] addTimer:self.timer_countDown forMode:NSRunLoopCommonModes];
    
}

- (void)endCountDown{

    [self setTitle:self.originalTitle forState:UIControlStateNormal];
    if (self.originalColor) {
        [self setTitleColor:self.originalColor forState:UIControlStateNormal];
    } else {
        //默认颜色 白色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (self.originalFont) {
         [self.titleLabel setFont:self.originalFont];
    }else{
        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    
    [self setBackgroundColor:self.originalBGColor];
    // 恢复LRCountDownButton开始倒计时
    self.tempDurationOfCountDown = self.durationOfCountDown;
    if (self.timer_countDown) {
        [self.timer_countDown invalidate];
        self.timer_countDown = nil;
    }
    
    self.count = 0;
    self.enabled = YES;


}


@end
