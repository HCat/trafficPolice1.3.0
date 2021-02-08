//
//  PoliceDistributeAPI.h
//  移动采集
//
//  Created by hcat on 2018/12/19.
//  Copyright © 2018 Hcat. All rights reserved.
//

//  警力分布API

#import "LRBaseRequest.h"
#import "PoliceLocationModel.h"
#import "VehicleGPSModel.h"
#import "SignModel.h"

NS_ASSUME_NONNULL_BEGIN


#pragma mark - 获取警员位置信息

@interface PoliceDistributeGetListParam : NSObject

@property (nonatomic, strong) NSNumber * lng;    //经度
@property (nonatomic, strong) NSNumber * lat;    //纬度
@property (nonatomic, strong) NSNumber * range;  //范围

@end


@interface PoliceDistributeGetListManger : LRBaseRequest

@property (nonatomic, strong) PoliceDistributeGetListParam * param;     //
@property (nonatomic, strong) NSArray <PoliceLocationModel *> * userGpsList;    //车辆信息列表

@end

#pragma mark - 区域广播

@interface PoliceDistributeSendNoticeParam : NSObject

@property (nonatomic, copy) NSString * userIds;     //通知人员id
@property (nonatomic, copy) NSString * content;     //搜索类型

@end


@interface PoliceDistributeSendNoticeManger : LRBaseRequest

@property (nonatomic, strong) PoliceDistributeSendNoticeParam * param;     //


@end


#pragma mark - 搜索

@interface PoliceDistributeSearchParam  : NSObject

@property (nonatomic, copy) NSString * keywords;     //string
@property (nonatomic, strong) NSNumber * type;     //0全部，1警员，2警车

@end

@interface PoliceDistributeSearchManger : LRBaseRequest

@property (nonatomic, strong) PoliceDistributeSearchParam * param;     //

@property (nonatomic, strong) NSArray <PoliceLocationModel *> * resultList;    //警员信息列表

@property (nonatomic, strong) NSArray <VehicleGPSModel *> * carList;    //车辆信息列表

@end





#pragma mark - 勤务管理列表

@interface PoliceAnalyzeModel : NSObject

@property (nonatomic, strong) NSNumber * userId;        //用户Id
@property (nonatomic, copy) NSString * realName;        //用户名称
@property (nonatomic, copy) NSString * shiftName;       //早班",
@property (nonatomic, strong) NSNumber * workTime;      //工作时长
@property (nonatomic, copy) NSString * workDateStr;     //日期
@property (nonatomic, copy) NSString * workTimeStr;     //工作时长


@end


@interface PoliceAnalyzeListParam  : NSObject

@property (nonatomic, copy) NSString * workDateStr;         //时间
@property (nonatomic, strong) NSNumber * parentId;          //ID
@property (nonatomic, strong) NSNumber * start;             //以0开始
@property (nonatomic, strong) NSNumber * length;            //大于0

@end

@interface PoliceAnalyzeListManger : LRBaseRequest

@property (nonatomic, strong) PoliceAnalyzeListParam * param;     //

@property (nonatomic, strong) NSArray <PoliceAnalyzeModel *> * analyzeList;    //警员信息列表

@end

#pragma mark - 获取签到列表


@interface PoliceSignListParam  : NSObject

@property (nonatomic, copy) NSString * workDateStr;         //时间
@property (nonatomic, strong) NSNumber * userId;            //用户ID

@end

@interface PoliceSignListManger : LRBaseRequest

@property (nonatomic, strong) PoliceSignListParam * param;     //

@property (nonatomic, strong) NSArray <SignModel *> * signList;    //警员信息列表

@end


#pragma mark - (2021年2月5号)新的获取警员位置信息


@interface PoliceDistributeTotalListModel : NSObject

@property (nonatomic, strong) NSNumber * offline;   //离线人数
@property (nonatomic, strong) NSNumber * online;    //在线人数

@end


@interface PoliceDistributeNewGetListManger : LRBaseRequest

@property (nonatomic, strong) NSArray <PoliceLocationModel *> * userGpsList;    //车辆信息列表

@property (nonatomic, strong) NSArray <PoliceDistributeTotalListModel *> * totalList;    //车辆信息列表

@end





NS_ASSUME_NONNULL_END
