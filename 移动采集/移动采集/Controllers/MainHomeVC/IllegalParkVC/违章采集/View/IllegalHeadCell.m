//
//  IllegalHeadCell.m
//  移动采集
//
//  Created by hcat on 2018/9/21.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalHeadCell.h"

@interface IllegalHeadCell()

@property (weak, nonatomic) IBOutlet UITextField *tf_carNumber;
@property (weak, nonatomic) IBOutlet UITextField *tf_road;
@property (weak, nonatomic) IBOutlet UITextField *tf_address;
@property (weak, nonatomic) IBOutlet UITextField *tf_remark;

@property (weak, nonatomic) IBOutlet UIButton *btn_position;

@property (weak, nonatomic) IBOutlet UIButton *btn_positionByUser;

@end

@implementation IllegalHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
