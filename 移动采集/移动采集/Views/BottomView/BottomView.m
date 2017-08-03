//
//  BottomView.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/17.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "BottomView.h"

@interface BottomView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *bottomView;

@end


@implementation BottomView

LRSingletonM(Default)

+ (void)showWindowWithBottomView:(UIView*)bottomView{
    
    BottomView *window = [BottomView sharedDefault];
    window.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:window];
    
    window.bottomView = bottomView;

    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^() {
                         
                         CGRect frame = window.bottomView.frame;
                         frame.origin.y -= frame.size.height;
                         window.bottomView.frame = frame;
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

+ (void)dismissWindow{

    BottomView *window = [BottomView sharedDefault];
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^() {
                         
                         CGRect frame = window.bottomView.frame;
                         frame.origin.y += frame.size.height;
                         window.bottomView.frame = frame;
                     } completion:^(BOOL finished) {
                         
                         [window.bottomView removeFromSuperview];
                         [window removeFromSuperview];
                         window.bottomView = nil;
                     }];
}

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self createUI];
}

- (void)createUI {
    [self addSubview:self.maskView];
    [self addSubview:self.bottomView];
}

#pragma mark - set && get

- (UIView*)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMaskViewViewAction)];
        [_maskView addGestureRecognizer:tap];
        _maskView.alpha = .5;
    }
    return _maskView;
}

#pragma mark -

- (void)tapMaskViewViewAction{
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^() {
                         
                         CGRect frame = self.bottomView.frame;
                         frame.origin.y += frame.size.height;
                         self.bottomView.frame = frame;
                     } completion:^(BOOL finished) {
                         
                         [self.bottomView removeFromSuperview];
                         [self removeFromSuperview];
                         self.bottomView = nil;
                     }];
    
}

@end
