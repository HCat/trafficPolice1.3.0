//
//  UserTaskCell.m
//  移动采集
//
//  Created by hcat on 2017/11/3.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "UserTaskCell.h"

@interface UserTaskCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UIView *v_taskCancel;

@end


@implementation UserTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
