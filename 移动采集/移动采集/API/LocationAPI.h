//
//  LocationAPI.h
//  移动采集
//
//  Created by hcat on 2017/9/11.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "UserGpsListModel.h"

#pragma mark - 获取一定范围内车辆信息


@interface LocationGetListManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * lng;       //经度
@property (nonatomic, strong) NSNumber * lat;       //纬度
@property (nonatomic, strong) NSNumber * range;     //范围 单位km，默认5km


/****** 返回数据 ******/
@property (nonatomic, strong) NSArray <UserGpsListModel *> * userGpsList;

@end
