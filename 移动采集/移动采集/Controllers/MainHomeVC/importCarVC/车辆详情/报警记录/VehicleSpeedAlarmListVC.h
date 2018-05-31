//
//  VehicleSpeedAlarmListVC.h
//  移动采集
//
//  Created by hcat on 2018/5/23.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"



@interface VehicleSpeedAlarmListVC : HideTabSuperVC

@property (nonatomic,copy) NSString * alarmType; //超速报警类型    字符串 ‘1’区域超速，‘111’路口超速
@property (nonatomic, copy)   NSString * vehicleid;
@end
