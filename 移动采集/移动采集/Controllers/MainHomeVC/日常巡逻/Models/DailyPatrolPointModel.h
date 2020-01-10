//
//  DailyPatrolPointModel.h
//  移动采集
//
//  Created by hcat-89 on 2020/1/9.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailyPatrolPointModel : NSObject

@property (nonatomic, strong) NSNumber * partrolId;     //巡逻编号
@property (nonatomic, strong) NSNumber * longitude;     //经度
@property (nonatomic, strong) NSNumber * latitude;     //纬度
@property (nonatomic, copy) NSString * userId;     //地点名称

@end

NS_ASSUME_NONNULL_END
