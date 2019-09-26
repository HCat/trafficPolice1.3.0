//
//  ParkingForensicsModel.h
//  移动采集
//
//  Created by hcat on 2019/7/25.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ParkingForensicsModel : NSObject

@property (nonatomic,copy) NSString * parklotname;              //片区名
@property (nonatomic,copy) NSString * parkingForenId;           //工单ID
@property (nonatomic,copy) NSString * pkParkplaceId;            //泊位ID
@property (nonatomic,copy) NSString * parklotId;                //片区编号
@property (nonatomic,copy) NSString * placenum;                 //车位编号
@property (nonatomic,copy) NSNumber * updatetime;               //派单时间
@property (nonatomic,strong) NSNumber * pageNo;                 //页数
@property (nonatomic,strong) NSNumber * pageSize;               //条数
@property (nonatomic,strong) NSNumber * status;                //订单状态
@property (nonatomic,strong) NSNumber * distance;               //距离

@end

NS_ASSUME_NONNULL_END
