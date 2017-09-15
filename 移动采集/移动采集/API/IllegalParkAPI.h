//
//  IllegalParkAPI.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/21.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "IllegalParkListModel.h"
#import "IllegalParkDetailModel.h"

#pragma mark - 违停采集增加API

@interface IllegalParkSaveParam :  NSObject

@property (nonatomic,strong) NSNumber * roadId;               //道路ID 必填，从通用值【道路】获取ID
@property (nonatomic,copy)   NSString * roadName;             //道路名字 如果roadId为0的时候设置
@property (nonatomic,copy)   NSString * address;              //事故地点 必填
@property (nonatomic,copy)   NSString * addressRemark;        //地址备注 非必填
@property (nonatomic,copy)   NSString * carNo;                //车牌号 必填
@property (nonatomic,strong) NSNumber * longitude;            //经度 必填
@property (nonatomic,strong) NSNumber * latitude;             //纬度 必填
@property (nonatomic,copy)   NSArray  * files;                //事故图片 列表，最多可上传30张
@property (nonatomic,copy)   NSString * remarks;              //违停图片名称  违章图片名称，字符串列表。和图片一对一，名称统一命名，车牌近照（一张）、违停照片（可多张）
@property (nonatomic,copy)   NSString * taketimes;            //拍照时间 拍照时间，字符串列表，格式yyyy-MM-dd HH:mm:ss，和图片一对一
//两个参数同时不为空才有效，没有则不填
@property (nonatomic,copy)   NSString * cutImageUrl;          //裁剪近照url
@property (nonatomic,copy)   NSString * taketime;             //裁剪时间
@property (nonatomic,strong) NSNumber * type;                 //选填，默认1:违停，1001:朝向错误，1002:锁车，2001:信息录入

@end


@interface IllegalParkSaveManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) IllegalParkSaveParam * param;

/****** 返回数据 ******/
//无返回参数

@end

#pragma mark - 违停采集列表API

@interface IllegalParkListPagingParam : NSObject

@property (nonatomic,assign) NSInteger  start;   //开始的索引号 从0开始
@property (nonatomic,assign) NSInteger  length;  //显示的记录数 默认为10
@property (nonatomic,copy)   NSString * search;  //搜索的关键字

@end


@interface IllegalParkListPagingReponse : NSObject

@property (nonatomic,copy) NSArray < IllegalParkListModel *> * list;    //包含IllegalParkListModel对象
@property (nonatomic,assign) NSInteger total;                           //总数

@end

@interface IllegalParkListPagingManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) IllegalParkListPagingParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) IllegalParkListPagingReponse * illegalParkListPagingReponse;

@end

#pragma mark - 违停采集详情API


@interface IllegalParkDetailManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * illegalParkId;

/****** 返回数据 ******/
@property (nonatomic, strong) IllegalParkDetailModel * illegalDetailModel;

@end

#pragma mark - 违停、违法禁令上报异常API

@interface IllegalParkReportAbnormalManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * illegalParkId;

/****** 返回数据 ******/
//无返回数据

@end

#pragma mark - 查询是否有违停记录API

@interface IllegalParkQueryRecordManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * carNo;    //车牌号
@property (nonatomic, strong) NSNumber * roadId; //道路ID
@property (nonatomic, strong) NSNumber * type;   //选填，默认1:违停，1001:朝向错误，1002:锁车，2001:信息录入

/****** 返回数据 ******/

/******
 code:0 无记录
 code:110 有记录

 ******/

@end



