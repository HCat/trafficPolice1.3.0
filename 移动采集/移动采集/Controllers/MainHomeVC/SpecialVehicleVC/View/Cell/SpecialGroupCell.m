//
//  SpecialGroupCell.m
//  移动采集
//
//  Created by hcat on 2018/9/10.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "SpecialGroupCell.h"

@interface SpecialGroupCell()

@property (weak, nonatomic) IBOutlet UIView *v_selected;

@property (weak, nonatomic) IBOutlet UIView *v_add;

@property (weak, nonatomic) IBOutlet UILabel *lb_groupName;


@end


@implementation SpecialGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SpecialCarModel *)model{
    
    _model = model;
    
    _v_add.hidden = YES;
    _v_selected.hidden = YES;
    _lb_groupName.textColor = UIColorFromRGB(0x999999);
    
    
    if ([model.carId isEqualToNumber:@(-2)]) {
        _v_add.hidden = NO;
        _lb_groupName.text = @"";
    }
    
    if ([model.carId isEqualToNumber:_groupId]) {
        _v_selected.hidden = NO;
        _lb_groupName.textColor = DefaultColor;
    }
    
     _lb_groupName.text = [ShareFun takeStringNoNull:_model.name];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
