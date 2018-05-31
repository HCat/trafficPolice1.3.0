//
//  VehicleSpeedAlarmCell.h
//  移动采集
//
//  Created by hcat on 2018/5/23.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleAPI.h"

typedef void(^VehicleSpeedAlarmCellBlock)(void);

@interface VehicleSpeedAlarmCell : UITableViewCell

@property(nonatomic,strong) VehicleSpeedAlarmModel *speedAlarmModel;
@property(nonatomic,copy) VehicleSpeedAlarmCellBlock block;

@end
