//
//  VehicleAlarmModel.h
//  移动采集
//
//  Created by hcat on 2018/5/22.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehicleAreaAlarmModel : NSObject

@property(nonatomic,copy) NSString *speed; // 时速   40，单位km/h
@property(nonatomic,copy) NSString *location; // 地点
@property(nonatomic,strong) NSNumber *alarmTime; // 时间   时间戳

@end


@interface VehicleRoadAlarmModel : NSObject

@property(nonatomic,copy) NSString *speed; // 时速   40，单位km/h
@property(nonatomic,copy) NSString *location; // 地点
@property(nonatomic,strong) NSNumber *alarmTime; // 时间   时间戳

@end


@interface VehicleTiredAlarmModel : NSObject

@property(nonatomic,copy) NSString *location; // 地点
@property(nonatomic,strong) NSNumber * alarmTime; // 时间   时间戳
@property(nonatomic,strong) NSNumber * startTime; // 时间  开始时间
@property(nonatomic,strong) NSNumber * endTime; // 时间   结束时间

@end


@interface VehicleExpireAlarmModel : NSObject

@property(nonatomic,strong) NSNumber * inspectTimeEnd; //         年检到期    1到期，0未到期
@property(nonatomic,strong) NSNumber * inspectTimeEndDate; //年检到期日期    时间戳

@property(nonatomic,strong) NSNumber * compInsuranceTimeEnd; //   强制险到期    1到期，0未到期
@property(nonatomic,strong) NSNumber * compInsuranceTimeEndDate; //强制险到期日期    时间戳

@property(nonatomic,strong) NSNumber * bussInsuranceTimeEnd; //   商业险到期    1到期，0未到期
@property(nonatomic,strong) NSNumber * bussInsuranceTimeEndDate; //商业险到期日期    时间戳

@property(nonatomic,strong) NSNumber * affiliatdTimeEnd; //       挂靠协议到期    1到期，0未到期
@property(nonatomic,strong) NSString * affiliatdTimeEndDate; //挂靠协议到期日期    字符串，‘2018-05-20’‘长期’


@end

@interface VehicleTiredImageModel : NSObject

@property(nonatomic,copy) NSString *url; // 地点
@property(nonatomic,strong) NSNumber * createDate; // 时间   时间戳

@end

