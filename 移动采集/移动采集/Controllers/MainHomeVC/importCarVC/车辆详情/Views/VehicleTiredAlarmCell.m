//
//  VehicleTiredAlarmCell.m
//  移动采集
//
//  Created by hcat on 2018/5/21.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleTiredAlarmCell.h"

@interface VehicleTiredAlarmCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@end


@implementation VehicleTiredAlarmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTiredAlarmModel:(VehicleTiredAlarmModel *)tiredAlarmModel{
    _tiredAlarmModel = tiredAlarmModel;
    
    if (_tiredAlarmModel) {
        _lb_address.text = _tiredAlarmModel.location;
         _lb_time.text = [ShareFun timeWithTimeInterval:_tiredAlarmModel.alarmTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
    }

}



#pragma mark - dealloc

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
