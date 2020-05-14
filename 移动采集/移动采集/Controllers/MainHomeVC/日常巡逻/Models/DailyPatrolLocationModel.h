//
//  DailyPatrolLocationModel.h
//  移动采集
//
//  Created by hcat-89 on 2020/1/9.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailyPatrolLocationModel : NSObject

@property (nonatomic, strong) NSNumber * partrolId;    //巡逻编号
@property (nonatomic, strong) NSNumber * longitude;    //经度
@property (nonatomic, strong) NSNumber * latitude;     //纬度
@property (nonatomic, copy) NSString   * placeName;      //地点名称
@property (nonatomic, strong) NSNumber * status;       //是否签到 0是未签到 1是已签到
@property (nonatomic, strong) NSNumber * sort;         //第几个途经点
@property (nonatomic, copy) NSString * signTime;     //签到时间
@property (nonatomic, strong) NSNumber * type;         // 0为路线 1为途经点
@property (nonatomic, strong) NSNumber * pointType;  // 0为签到 1为签退  2为未签到和未签退
@property (nonatomic, strong) NSNumber * signInTime; //到岗签到时间
@property (nonatomic, strong) NSNumber * signOutTime; //退岗签到时间

@end

NS_ASSUME_NONNULL_END
