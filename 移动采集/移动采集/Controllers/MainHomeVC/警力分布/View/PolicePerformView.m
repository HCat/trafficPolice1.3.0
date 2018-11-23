//
//  PolicePerformView.m
//  移动采集
//
//  Created by hcat on 2018/11/20.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "PolicePerformView.h"

@interface PolicePerformView()

@property (nonatomic, strong) UIWindow *keyWindow;

@property (weak, nonatomic) IBOutlet UITextView *tv_userList;





@end

@implementation PolicePerformView


+ (PolicePerformView *)initCustomView{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PolicePerformView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}


- (IBAction)handleBtnEditClicked:(id)sender {
    
    if (self.editBlock) {
        self.editBlock();
    }
    
    [self hide];
}

- (IBAction)handleBtnHideClicked:(id)sender {
    
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
    
    LxPrintf(@"PolicePerformView dealloc");
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
