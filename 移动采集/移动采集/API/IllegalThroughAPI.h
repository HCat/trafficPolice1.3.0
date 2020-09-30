//
//  IllegalThroughAPI.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/21.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "IllegalThroughSecDetailModel.h"
#import "IllegalParkListModel.h"
#import "IllegalParkDetailModel.h"

#import "IllegalParkAPI.h"


#pragma mark - 违反禁令查询是否需要二次采集API(新)


@interface IllegalThroughCarNoSecReponse : NSObject

@property (nonatomic,strong) NSArray <IllegalListModel *> * illegalList;
@property (nonatomic,copy)   NSString * deckCarNo;
@property (nonatomic,strong) NSNumber * illegalId;

@end


@interface IllegalThroughCarNoSecManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * carNo;    //车牌号
@property (nonatomic, strong) NSNumber * roadId; //道路ID


/****** 返回数据 ******/

@property (nonatomic,strong) NSArray <IllegalListModel *> * illegalList;
@property (nonatomic,copy) NSString * deckCarNo;

/****** 返回数据 ******/
@property (nonatomic, strong) IllegalThroughCarNoSecReponse * illegalReponse;

/******
 code:0 超过90秒有一次采集记录，返回一次采集ID、采集时间，提示“同路段该车于yyyy-MM-dd已被拍照采集”，跳转至二次采集页面
 code:110 提示“同路段当天已有违章行为，请不要重复采集！”
 code:13 提示“同路段该车1分30秒内有采集记录，是否重新采集？”
 code:999 无采集记录,不用任何提示
 ******/

@end


#pragma mark - 违反禁令二次采集加载数据API

@interface IllegalThroughSecAddManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * illegalThroughId;

/****** 返回数据 ******/

@property (nonatomic, strong) IllegalThroughSecDetailModel * illegalThroughSecDetailModel;


@end

#pragma mark - 违反禁令二次采集保存数据API

@interface IllegalThroughSecSaveParam : NSObject

@property (nonatomic,strong) NSNumber  * illegalThroughId;  //id
@property (nonatomic,copy)   NSArray   * files;             //事故图片 列表，最多可上传30张
@property (nonatomic,copy)   NSString  * remarks;           //违停图片名称  违章图片名称，字符串列表。和图片一对一，名称统一命名，车牌近照（一张）、违停照片（可多张）
@property (nonatomic,copy)   NSString  * taketimes;         //拍照时间 拍照时间，字符串列表，格式yyyy-MM-dd HH:mm:ss，和图片一对一
@property (nonatomic,strong) NSNumber  * offtime;           //缓存时候的时间段

@end


@interface IllegalThroughSecSaveManger:LRBaseRequest

/****** 请求数据 ******/
/****** 请求数据 ******/
@property (nonatomic, strong) IllegalThroughSecSaveParam * param;

@property (nonatomic, assign) BOOL isUpCache;
@property (nonatomic, assign) CGFloat progress;

/****** 返回数据 ******/
//无返回参数

@end

#pragma mark - 违反禁令增加API

/*****
 违反禁令是指一个车牌号在同一个路段停车超过90秒，采集方式为：
 1、	第一次采集，记录路名、车牌号、违章图片，当路名或者车牌号有变化时，异步查询是否有一次采集记录，有以下四种情况
 a)	没有任何采集记录，不用做任何处理
 b)	90秒内有一次采集记录，提示“同路段该车1分30秒内有采集记录，是否重新采集？”
 c)	超过90秒有一次采集记录，提示“同路段该车于yyyy-MM-dd已被拍照采集”，跳转到二次采集页面
 d)	当天已经有二次采集记录，提示“同路段当天已有违章行为，请不要重复采集！”，跳转到新的页面采集。
 2、	90秒后再次采集同样路段同车牌号，视为生效。
 ******/


@interface IllegalThroughSaveManger:LRBaseRequest

/****** 请求数据 ******/
//备注：这里的请求参数和违停的请求参数
@property (nonatomic, strong) IllegalParkSaveParam * param;

@property (nonatomic, assign) BOOL isUpCache;
@property (nonatomic, assign) CGFloat progress;

/****** 返回数据 ******/
//无返回参数
/******
 0成功，100失败，110：90秒前有一次采集记录，返回一次采集记录的ID，跳转到二次采集页面
 ******/

@end

#pragma mark - 违反禁令采集列表API

@interface IllegalThroughListPagingParam : NSObject

@property (nonatomic,assign) NSInteger  start;   //开始的索引号 从0开始
@property (nonatomic,assign) NSInteger  length;  //显示的记录数 默认为10
@property (nonatomic,copy)   NSString * search;  //搜索的关键字

@end


@interface IllegalThroughListPagingReponse : NSObject

@property (nonatomic,copy) NSArray < IllegalParkListModel *> * list;    //包含IllegalParkListModel对象
@property (nonatomic,assign) NSInteger total;                           //总数

@end


@interface IllegalThroughListPagingManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) IllegalThroughListPagingParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) IllegalThroughListPagingReponse * illegalThroughListPagingReponse;

@end

#pragma mark - 违反禁令采集详情API


@interface IllegalThroughDetailManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * illegalThroughId;

/****** 返回数据 ******/
@property (nonatomic, strong) IllegalParkDetailModel * illegalDetailModel;

@end

