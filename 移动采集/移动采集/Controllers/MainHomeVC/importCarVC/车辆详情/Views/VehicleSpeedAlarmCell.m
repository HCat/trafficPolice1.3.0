//
//  VehicleSpeedAlarmCell.m
//  移动采集
//
//  Created by hcat on 2018/5/23.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleSpeedAlarmCell.h"

@interface VehicleSpeedAlarmCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_speed;

@property (weak, nonatomic) IBOutlet UILabel *lb_address;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;


@end


@implementation VehicleSpeedAlarmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSpeedAlarmModel:(VehicleSpeedAlarmModel *)speedAlarmModel{
    
    _speedAlarmModel = speedAlarmModel;
    
    if (_speedAlarmModel) {
        _lb_speed.text = [NSString stringWithFormat:@"%@km/h",_speedAlarmModel.speed];
        _lb_address.text = _speedAlarmModel.location;
        _lb_time.text = [ShareFun timeWithTimeInterval:_speedAlarmModel.alarmTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
}


#pragma mark -buttonAction

- (IBAction)handleBtnMapClicked:(id)sender {
    
    if (self.block) {
        self.block();
    }
    
}


#pragma mark -dealloc

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
