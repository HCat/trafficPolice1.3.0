//
//  ParkingManagementAPI.h
//  移动采集
//
//  Created by hcat on 2019/9/19.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "LRBaseRequest.h"
#import "ParkingManageListModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 在库车辆列表

@interface ParkingManageSearchListParam  : NSObject

@property (nonatomic, strong) NSNumber * start;     //分页起始
@property (nonatomic, strong) NSNumber * length;     //分页长度
@property (nonatomic, copy) NSString * searchWord;     //关键词    关键词
@property (nonatomic, strong) NSNumber * type;     //类型    0车牌号1强制单号 2 车架号

@end

@interface ParkingManageSearchListManger : LRBaseRequest

@property (nonatomic, strong) ParkingManageSearchListParam * param;     //

@property (nonatomic, strong) NSArray <ParkingManageListModel *> * resultList;    //在线车辆信息列表

@end

NS_ASSUME_NONNULL_END
