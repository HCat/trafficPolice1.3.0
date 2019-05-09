//
//  TakeOutAPI.h
//  移动采集
//
//  Created by hcat on 2019/5/8.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "LRBaseRequest.h"
#import "DeliveryCourierModel.h"
#import "DeliveryInfoModel.h"
#import "DeliveryVehicleModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 根据条件查询快递员列表API

@interface TakeOutGetCourierListParam : NSObject

@property (nonatomic,strong) NSNumber * start;   //开始的索引号 从0开始
@property (nonatomic,strong) NSNumber * length;  //显示的记录数 默认为10
@property (nonatomic,copy)   NSString * key;  //搜索的关键字
@property (nonatomic,strong) NSNumber * type;   //字段类型:Integer，1姓名（如“梅”）2编号（如M000001）3车牌号(如闽A11111) 4车架号(如11111) 5 二维码编号(如000001)


@end


@interface TakeOutGetCourierListReponse : NSObject

@property (nonatomic,copy) NSArray < DeliveryCourierModel *> * list;    //包含IllegalParkListModel对象
@property (nonatomic,assign) NSInteger total;                           //总数

@end

@interface TakeOutGetCourierListManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) TakeOutGetCourierListParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) TakeOutGetCourierListReponse * takeOutReponse;

@end


#pragma mark - 查询快递员信息


@interface TakeOutGetCourierInfoManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * deliveryId;

/****** 返回数据 ******/
@property (nonatomic, strong) DeliveryInfoModel * takeOutReponse;

@end


#pragma mark - 查询车辆信息


@interface TakeOutGetVehicleInfoManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * vehicleId;

/****** 返回数据 ******/
@property (nonatomic, strong) DeliveryVehicleModel * takeOutReponse;

@end


NS_ASSUME_NONNULL_END
