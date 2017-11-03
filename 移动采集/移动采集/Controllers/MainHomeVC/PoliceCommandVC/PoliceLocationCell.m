//
//  PoliceLocationCell.m
//  移动采集
//
//  Created by hcat on 2017/9/13.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "PoliceLocationCell.h"

@interface PoliceLocationCell()



@end


@implementation PoliceLocationCell



- (void)setPoi:(AMapPOI *)poi{

    _poi = poi;
    
    if (_poi) {
        _lb_name.text = _poi.name;
        _lb_address.text = _poi.address;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
