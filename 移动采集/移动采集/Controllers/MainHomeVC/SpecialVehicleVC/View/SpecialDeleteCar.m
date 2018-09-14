//
//  SpecialDeleteCar.m
//  移动采集
//
//  Created by hcat on 2018/9/11.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "SpecialDeleteCar.h"

@interface SpecialDeleteCar()

@property (nonatomic, strong) UIWindow *keyWindow;

@end


@implementation SpecialDeleteCar


+ (SpecialDeleteCar *)initCustomView{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SpecialDeleteCar" owner:self options:nil];
    return [nibView objectAtIndex:0];
}


- (IBAction)handleBtnQuitClicked:(id)sender {
    [self hide];
    
}


- (IBAction)handleBtnDetermineClicked:(id)sender {
    
    if (_model) {
        
        WS(weakSelf);
        
        SpecialDeleteManger * manger = [[SpecialDeleteManger alloc] init];
        manger.groupId = _model.carId;
        [manger configLoadingTitle:@"删除"];
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            SW(strongSelf, weakSelf);
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SPECIAL_DELETECAR object:_model];
                [strongSelf performSelector:@selector(hide) withObject:nil afterDelay:1.5f];
                
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
        
        
    }

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
    
    LxPrintf(@"SpecialDeleteCar dealloc");
    
}


@end
