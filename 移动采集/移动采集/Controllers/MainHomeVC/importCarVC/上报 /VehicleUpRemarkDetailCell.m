//
//  VehicleUpRemarkDetailCell.m
//  移动采集
//
//  Created by hcat on 2018/5/29.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleUpRemarkDetailCell.h"

@interface VehicleUpRemarkDetailCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_remark;

@end

@implementation VehicleUpRemarkDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(VehicleUpDetailModel *)model{
    _model = model;
    
    if (_model) {
        _lb_remark.text = [ShareFun takeStringNoNull:_model.remark];
    }
    
}


#pragma mark - dealloc

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
