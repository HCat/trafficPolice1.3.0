//
//  DataStatisticsAPI.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/11/11.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "LRBaseRequest.h"
#import "AccidentListModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface DataStatisticsReponse : NSObject

@property (nonatomic,strong) NSNumber * thirty;                           //总数
@property (nonatomic,strong) NSNumber * sixty;
@property (nonatomic,strong) NSNumber * ninety;

@end

@interface DataStatisticsManger:LRBaseRequest


@property (nonatomic, strong) NSNumber * accidentState;

/****** 返回数据 ******/
@property (nonatomic, strong) DataStatisticsReponse * dataStatisticsReponse;

@end


#pragma mark - 事故列表API

@interface DataStatisticsListPagingParam : NSObject

@property (nonatomic,assign) NSInteger  start;      //开始的索引号 从0开始
@property (nonatomic,assign) NSInteger  length;     //显示的记录数 默认为10
@property (nonatomic,copy)   NSString * timeType;     //1: 一个月 2：二个月 3 二个月前
@property (nonatomic,assign)   NSInteger accidentState;     //0 未结案 1结案


@end


@interface DataStatisticsListPagingReponse : NSObject

@property (nonatomic,copy)   NSArray<AccidentListModel * > * list;    //包含AccidentListModel对象
@property (nonatomic,assign) NSInteger total;    //总数


@end


@interface DataStatisticsListPagingManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) DataStatisticsListPagingParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) DataStatisticsListPagingReponse * accidentListPagingReponse;

@end





NS_ASSUME_NONNULL_END
