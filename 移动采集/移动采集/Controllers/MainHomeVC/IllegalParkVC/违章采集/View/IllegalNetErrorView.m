//
//  IllegalNetErrorView.m
//  移动采集
//
//  Created by hcat on 2018/9/29.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalNetErrorView.h"

@interface IllegalNetErrorView()

@property (nonatomic, strong) UIWindow *keyWindow;

@end


@implementation IllegalNetErrorView

+ (IllegalNetErrorView *)initCustomView{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"IllegalNetErrorView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}


- (IBAction)handleBtnSaveClicked:(id)sender {
    
    if (self.saveBlock) {
        self.saveBlock();
    }
    
    [self hide];
}

- (IBAction)handleBtnUpClicked:(id)sender {
    
    if (self.upBlock) {
        self.upBlock();
    }
    
    [self hide];
}


- (void)show{
    
    self.keyWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _keyWindow.backgroundColor = [UIColor clearColor];
    _keyWindow.windowLevel = UIWindowLevelAlert;
    
    self.frame = _keyWindow.bounds;
    
    [_keyWindow addSubview:self];
    [_keyWindow makeKeyAndVisible];
    
}

- (void)hide{
    
    [self removeFromSuperview];
    if (self.keyWindow) {
        [self.keyWindow resignKeyWindow];
        [[UIApplication sharedApplication].delegate.window makeKeyWindow];
    }
    
}

- (void)dealloc{
    
    LxPrintf(@"IllegalNetErrorView dealloc");
    
}


@end
