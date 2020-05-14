//
//  BoradPoliceView.m
//  移动采集
//
//  Created by hcat on 2017/9/12.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "BoradPoliceView.h"


@interface BoradPoliceView ()

@property (nonatomic,copy,readwrite) NSString *content;


@end


@implementation BoradPoliceView

+ (BoradPoliceView *)initCustomView{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"BoradPoliceView" owner:self options:nil];
    
    BoradPoliceView * t_view = [nibView objectAtIndex:0];
    return t_view;
}

- (void)dismiss{
    [self removeFromSuperview];
    
}


#pragma mark - button methods

- (IBAction)handleBtnMakeSureClicked:(id)sender {
    
    self.content = _tv_content.text;
    
    if (self.content == nil || self.content.length == 0) {
        [LRShowHUD showError:@"请输入广播内容" duration:1.5f];
        return;
    }
    
    if (self.block) {
        self.block(self.content);
    }
    

}

- (IBAction)handleBtnCancleClicked:(id)sender {
    [self dismiss];
    
}


#pragma mark - dealloc

- (void)dealloc{
    
    LxPrintf(@"BoradPoliceView dealloc");
    
}


@end
