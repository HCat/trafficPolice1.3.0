//
//  VehicleAreaAlarmCell.m
//  移动采集
//
//  Created by hcat on 2018/5/21.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleAreaAlarmCell.h"

@interface VehicleAreaAlarmCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_speed;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@end


@implementation VehicleAreaAlarmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setAreaAlarmModel:(VehicleAreaAlarmModel *)areaAlarmModel{
    
    _areaAlarmModel = areaAlarmModel;
    
    if (_areaAlarmModel) {
        _lb_speed.text = [NSString stringWithFormat:@"%@km/h",_areaAlarmModel.speed];
        _lb_address.text = _areaAlarmModel.location;
        _lb_time.text = [ShareFun timeWithTimeInterval:_areaAlarmModel.alarmTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
}




@end
