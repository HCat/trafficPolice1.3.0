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
#import "DeliveryIllegalModel.h"
#import "DeliveryIllegalDetailModel.h"
#import "DeliveryIllegalTypeModel.h"

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


#pragma mark - 违章记录列表

@interface TakeOutReportPageManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * deliveryId;

/****** 返回数据 ******/
@property (nonatomic,copy) NSArray < DeliveryIllegalModel *> * list;    //包含IllegalParkListModel对象

@end


#pragma mark - 快递小哥违章记录详情


@interface TakeOutReportDetailManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * reportId;

/****** 返回数据 ******/
@property (nonatomic, strong) DeliveryIllegalDetailModel * takeOutReponse;

@end

#pragma mark - 违章类型列表


@interface TakeOutIllegalTypeManger:LRBaseRequest

/****** 返回数据 ******/
@property (nonatomic,copy) NSArray < DeliveryIllegalTypeModel *> * list;    //包含IllegalParkListModel对象

@end

#pragma mark - 上报快递小哥违章

@interface TakeOutSaveParam :  NSObject

@property (nonatomic,strong,nullable) NSNumber * roadId;               //道路ID 必填，从通用值【道路】获取ID
@property (nonatomic,copy,nullable)   NSString * roadName;             //道路名字 如果roadId为0的时候设置
@property (nonatomic,copy,nullable)   NSString * address;              //事故地点 必填
@property (nonatomic,copy,nullable)   NSString * remark;               //地址备注 非必填
@property (nonatomic,strong,nullable) NSNumber * lng;                  //经度 必填
@property (nonatomic,strong,nullable) NSNumber * lat;                  //纬度 必填
@property (nonatomic,copy,nullable)   NSArray  * files;                //事故图片 列表，最多可上传30张
@property (nonatomic,strong,nullable) NSNumber * reportType;           //采集类型 默认 3014
@property (nonatomic,copy,nullable)   NSString * driver;               //快递小弟编号
@property (nonatomic,copy,nullable)   NSString * illegalType;          //违法类型

@end

@interface TakeOutSaveManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) TakeOutSaveParam * param;
@property (nonatomic, assign) CGFloat progress;

@end

NS_ASSUME_NONNULL_END
