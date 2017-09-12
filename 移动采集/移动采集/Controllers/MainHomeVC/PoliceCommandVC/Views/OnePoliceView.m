//
//  OnePoliceView.m
//  移动采集
//
//  Created by hcat on 2017/9/12.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "OnePoliceView.h"

@interface OnePoliceView ()

@property (weak, nonatomic) IBOutlet UITextField *tf_name;
@property (nonatomic,copy,readwrite) NSString * name;

@end


@implementation OnePoliceView

+ (OnePoliceView *)initCustomView{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"OnePoliceView" owner:self options:nil];
    
    OnePoliceView * t_view = [nibView objectAtIndex:0];
    return t_view;
}

- (void)dismiss{
    [self removeFromSuperview];

}

#pragma mark - button methods 

- (IBAction)handleBtnMakeSureClicked:(id)sender {
    
    self.name = _tf_name.text;
    
    if (self.name == nil || self.name.length == 0) {
        [LRShowHUD showError:@"请输入姓名" duration:1.5f];
        return;
    }
    
    if (self.block) {
        self.block(self.name);
    }
    
    [self dismiss];
    
}

- (IBAction)handleBtnCancleClicked:(id)sender {
    [self dismiss];

}

#pragma mark - dealloc

- (void)dealloc{
    
    LxPrintf(@"OnePoliceView dealloc");
    
}

@end
