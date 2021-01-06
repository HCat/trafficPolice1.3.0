//
//  AccidentMoreAPIs.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/11/9.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "LRBaseRequest.h"
#import "AccidentListModel.h"

#pragma mark - 车牌查询违章次数


@interface AccidentMoreCountParam : NSObject


@property (nonatomic, copy) NSString * queryType;   //1 车牌号  2身份证  3报案手机

@property (nonatomic, copy) NSString * carNo;   //
@property (nonatomic, copy) NSString * callpoliceMan;   //
@property (nonatomic, copy) NSString * cardNo;   //身份证

@property (nonatomic, copy) NSString * accidentType;    //1 事故 2快处

@end

@interface AccidentMoreCountManger:LRBaseRequest

/****** 请求数据 ******/

@property (nonatomic, strong) AccidentMoreCountParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) NSNumber * carNoNumber;

@end


#pragma mark - 车牌查询违章查询列表API

@interface AccidentMoreListPagingParam : NSObject

@property (nonatomic,assign) NSInteger  start;
@property (nonatomic,assign) NSInteger  length;
@property (nonatomic, copy) NSString * queryType;   //1 车牌号  2身份证  3报案手机

@property (nonatomic, copy) NSString * carNo;   //
@property (nonatomic, copy) NSString * callpoliceMan;   //
@property (nonatomic, copy) NSString * cardNo;   //身份证

@property (nonatomic, copy) NSString * accidentType;    //1 事故 2快处

@end


@interface AccidentMoreListPagingReponse : NSObject

@property (nonatomic,copy) NSArray < AccidentListModel *> * list;    //包含IllegalParkListModel对象
@property (nonatomic,assign) NSInteger total;                           //总数

@end

@interface AccidentMoreListPagingManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) AccidentMoreListPagingParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) AccidentMoreListPagingReponse * accidentMoreReponse;

@end




