//
//  IllegalParkUpListCell.m
//  移动采集
//
//  Created by hcat on 2018/9/29.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalParkUpListCell.h"

@interface IllegalParkUpListCell()

@property (weak, nonatomic) IBOutlet UIButton *lb_abnormal;

@property (weak, nonatomic) IBOutlet UILabel *lb_carNumber;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;


@end


@implementation IllegalParkUpListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    LxPrintf(@"IllegalParkUpListCell dealloc");
}

@end
