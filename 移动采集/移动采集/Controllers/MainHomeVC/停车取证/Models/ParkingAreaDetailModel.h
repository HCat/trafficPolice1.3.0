//
//  ParkingAreaDetailModel.h
//  移动采集
//
//  Created by hcat on 2019/7/28.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ParkingAreaTimeModel : NSObject

@property (nonatomic,strong) NSNumber * day;            //天
@property (nonatomic,strong) NSNumber * hour;           //小时
@property (nonatomic,strong) NSNumber * minute;         //分
@property (nonatomic,strong) NSNumber * seconde;         //秒


@end


@interface ParkingAreaDetailModel : NSObject

@property (nonatomic,copy)   NSString * parkRecordId;                   //停车记录ID
@property (nonatomic,copy)   NSString * parkPlaceId;                    //车位ID
@property (nonatomic,strong) NSNumber * startTime;                      //入场时间
@property (nonatomic,strong) ParkingAreaTimeModel * dateDiff;           //停留时间
@property (nonatomic,strong) NSNumber * payAmount;                      //应付金额
@property (nonatomic,strong) NSNumber * payedAmount;                    //已支付金额
@property (nonatomic,strong) NSNumber * waitPayAmount;                  //欠费金额
@property (nonatomic,strong) NSNumber * status;                         //泊位状态:0 空闲；1 有车未登记；2 有车已登记；3 有车已取证；"


@end

NS_ASSUME_NONNULL_END
