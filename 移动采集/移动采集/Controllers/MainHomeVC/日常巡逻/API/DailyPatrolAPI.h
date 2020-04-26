//
//  DailyPatrolAPI.h
//  移动采集
//
//  Created by hcat-89 on 2020/1/8.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "LRBaseRequest.h"
#import "DailyPatrolListModel.h"
#import "DailyPatrolLocationModel.h"
#import "DailyPatroInfoModel.h"
#import "DailyPatrolPointModel.h"
#import "DailyPatrolSignModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 排班信息列表

@interface DailyPatrolListManger:LRBaseRequest

/****** 返回数据 ******/
@property (nonatomic,copy) NSArray < DailyPatrolListModel *> * list;    //包含IllegalParkListModel对象
@end

#pragma mark - 巡逻路线详情

@interface DailyPatrolDetailReponse : NSObject

@property (nonatomic,copy) NSArray < DailyPatrolLocationModel *> * patrolLocationList;    //包含DailyPatrolLocationModel对象
@property (nonatomic,copy) NSArray < DailyPatrolSignModel *> * patrolSignList;
@property (nonatomic,strong) DailyPatroInfoModel * patrolInfo;    //DailyPatroInfoModel对象
@property (nonatomic,strong) NSNumber * status;    //0时间未到 1正常 2超时



@end

@interface DailyPatrolDetailManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * partrolId;
@property (nonatomic, strong) NSNumber * shiftId;       //班次编号
/****** 返回数据 ******/
@property (nonatomic, strong) DailyPatrolDetailReponse * reponseModel;

@end

#pragma mark - 巡逻打卡

@interface DailyPatrolSendSignParam : NSObject

@property (nonatomic, strong) NSNumber * longitude;     //经度
@property (nonatomic, strong) NSNumber * latitude;      //纬度
@property (nonatomic, strong) NSNumber * point;         //第几个途经点
@property (nonatomic, strong) NSNumber * patrolId;      //巡逻编号
@property (nonatomic, strong) NSNumber * shiftId;       //班次编号
@property (nonatomic, strong) NSNumber * pointType;     //站岗离岗  0为站岗 1为离岗
@end

@interface DailyPatrolSendSignManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) DailyPatrolSendSignParam * param;
/****** 返回数据 ******/


@end

#pragma mark - 实时上报位置

@interface DailyPatrolLocationReportParam : NSObject

@property (nonatomic, strong) NSNumber * longitude;     //经度
@property (nonatomic, strong) NSNumber * latitude;      //纬度
//@property (nonatomic, strong) NSNumber * partrolId;      //巡逻编号
//@property (nonatomic, strong) NSNumber * shiftId;       //班次编号

@end

@interface DailyPatrolLocationReportManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) DailyPatrolLocationReportParam * param;
/****** 返回数据 ******/


@end


#pragma mark - 实时上报位置列表


@interface DailyPatrolPointListManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * partrolId;     //巡逻编号
@property (nonatomic, strong) NSNumber * shiftId;       //班次编号

/****** 返回数据 ******/
@property (nonatomic,copy) NSArray < DailyPatrolPointModel *> * list;    //包含IllegalParkListModel对象

@end


@interface DailyPatrolPointSignManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) DailyPatrolSendSignParam * param;
/****** 返回数据 ******/


@end

NS_ASSUME_NONNULL_END
