//
//  ScreenAddCell.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/6/24.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ScreenAddCell.h"

@interface ScreenAddCell ()

@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;


@end


@implementation ScreenAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
    
    [self.tf_name setDelegate:(id<UITextFieldDelegate> _Nullable)self];
    
    RAC(self,name) = [self.tf_name.rac_textSignal skip:1];
    
    [RACObserve(self, name) subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        self.tf_name.text = x;
        
    }];

    
    [[_btn_cancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        if (self.block) {
            self.block(self.index);
        }
    
    }];
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.doneBlock) {
        self.doneBlock(self.index, self.name);
    }
    
}


@end
