//
//  VehicleRoadAlarmCell.m
//  移动采集
//
//  Created by hcat on 2018/5/21.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleRoadAlarmCell.h"

@interface VehicleRoadAlarmCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_speed;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@end


@implementation VehicleRoadAlarmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRoadAlarmModel:(VehicleRoadAlarmModel *)roadAlarmModel{
    
    _roadAlarmModel = roadAlarmModel;
    
    if (_roadAlarmModel) {
        _lb_speed.text = [NSString stringWithFormat:@"%@km/h",_roadAlarmModel.speed];
        _lb_address.text = _roadAlarmModel.location;
        _lb_time.text = [ShareFun timeWithTimeInterval:_roadAlarmModel.alarmTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
