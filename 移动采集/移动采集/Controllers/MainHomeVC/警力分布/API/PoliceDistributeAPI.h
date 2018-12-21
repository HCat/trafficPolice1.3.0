//
//  PoliceDistributeAPI.h
//  移动采集
//
//  Created by hcat on 2018/12/19.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "LRBaseRequest.h"
#import "PoliceLocationModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PoliceDistributeGetListParam : NSObject

@property (nonatomic, strong) NSNumber * lng;    //经度
@property (nonatomic, strong) NSNumber * lat;    //纬度
@property (nonatomic, strong) NSNumber * range;  //范围

@end


@interface PoliceDistributeGetListManger : LRBaseRequest

@property (nonatomic, strong) PoliceDistributeGetListParam * param;     //
@property (nonatomic, strong) NSArray <PoliceLocationModel *> * userGpsList;    //车辆信息列表

@end

@interface PoliceDistributeSendNoticeParam : NSObject

@property (nonatomic, copy) NSString * userIds;     //通知人员id
@property (nonatomic, copy) NSString * content;     //搜索类型

@end


@interface PoliceDistributeSendNoticeManger : LRBaseRequest

@property (nonatomic, strong) PoliceDistributeSendNoticeParam * param;     //


@end



NS_ASSUME_NONNULL_END
