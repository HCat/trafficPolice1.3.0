//
//  DailyPatrolListModel.h
//  移动采集
//
//  Created by hcat-89 on 2020/1/8.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailyPatrolListModel : NSObject

@property(strong, nonatomic) NSNumber * partrolId;  //巡逻编号
@property(copy, nonatomic) NSString * startHour;    //开始时间
@property(copy, nonatomic) NSString * startMinute;  //开始分钟
@property(copy, nonatomic) NSString * endHour;      //结束时间
@property(copy, nonatomic) NSString * endMinute;    //结束分钟
@property(strong, nonatomic) NSNumber * shiftId;     //班次
@property(strong, nonatomic) NSNumber * shiftNum;     //班次
@property(copy, nonatomic) NSString * partrolName;  //线路名称

@end

NS_ASSUME_NONNULL_END
