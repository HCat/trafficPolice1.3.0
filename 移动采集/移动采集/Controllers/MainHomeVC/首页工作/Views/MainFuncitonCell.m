//
//  MainFuncitonCell.m
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "MainFuncitonCell.h"

@interface MainFuncitonCell()

@property (weak, nonatomic) IBOutlet UIButton *btn_unSetUp;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_icon;
@property (weak, nonatomic) IBOutlet UILabel *lb_function;


@end

@implementation MainFuncitonCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.btn_unSetUp.layer.borderColor = DefaultColor.CGColor;
    self.btn_unSetUp.layer.borderWidth = 1.f;
    self.btn_unSetUp.layer.cornerRadius = 3.f;
    

    [RACObserve(self, menuModel) subscribeNext:^(CommonMenuModel * _Nullable x) {
       
        self.imageV_icon.image = [UIImage imageNamed:x.funImage];
        self.lb_function.text = x.funTitle;
        if ([x.isOrg isEqualToNumber:@1]) {
            self.btn_unSetUp.hidden = YES;
        }else{
            self.btn_unSetUp.hidden = NO;
        }
    
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
