//
//  StreetAPIS.h
//  移动采集
//
//  Created by 黄芦荣 on 2021/4/2.
//  Copyright © 2021 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "IllegalParkListModel.h"
#import "IllegalParkAPI.h" //添加是为了获取IllegalListModel这个对象
#import "IllegalAPI.h"

#pragma mark - 违章采集增加API

@interface StreetSaveManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) IllegalSaveParam * param;
@property (nonatomic, assign) CGFloat progress;

@end


#pragma mark - 违章采集列表API

@interface StreetListPagingParam : NSObject

@property (nonatomic,assign) NSInteger  start;   //开始的索引号 从0开始
@property (nonatomic,assign) NSInteger  length;  //显示的记录数 默认为10
@property (nonatomic,copy)   NSString * search;  //搜索的关键字
@property (nonatomic,strong) NSNumber *  state;   //上报状态

@end

@interface StreetListPagingReponse : NSObject

@property (nonatomic,copy) NSArray < IllegalParkListModel *> * list;    //包含IllegalParkListModel对象
@property (nonatomic,assign) NSInteger total;                           //总数
@property (nonatomic,strong) NSNumber * permission;                     //确认异常权限 true有 false没有

@end

@interface StreetListPagingManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) StreetListPagingParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) StreetListPagingReponse * illegalReponse;

@end


#pragma mark - 查询是否有违停记录API(新)

@interface StreetCarNoRecordReponse : NSObject

@property (nonatomic,strong) NSArray <IllegalListModel *> * illegalList;
@property (nonatomic,copy)   NSString * deckCarNo;
@property (nonatomic,strong) NSNumber * illegalId;

@end

@interface StreetCarNoRecordManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * carNo;    //车牌号
@property (nonatomic, strong) NSNumber * roadId; //道路ID
@property (nonatomic, strong) NSNumber * type;   //选填，默认1:违停，1001:朝向错误，1002:锁车，2001:信息录入


/****** 返回数据 ******/

@property (nonatomic,strong) NSArray <IllegalListModel *> * illegalList;
@property (nonatomic,copy) NSString * deckCarNo;

/****** 返回数据 ******/
@property (nonatomic, strong) StreetCarNoRecordReponse * illegalReponse;

@end
