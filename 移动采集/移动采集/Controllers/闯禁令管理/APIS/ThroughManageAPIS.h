//
//  ThroughManageAPIS.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/10.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "LRBaseRequest.h"
#import "IllegalParkAPI.h"
#import "IllegalThroughAPI.h"

#pragma mark - 另外一个叫违反禁令

#pragma mark - 闯禁令管理一次采集API

@interface ThroughManageSaveParam :  NSObject

@property (nonatomic,strong) NSNumber * roadId;               //道路ID 必填，从通用值【道路】获取ID
@property (nonatomic,copy)   NSString * roadName;             //道路名字 如果roadId为0的时候设置
@property (nonatomic,copy)   NSString * userName;             //车主姓名
@property (nonatomic,copy)   NSString * identNo;              //车主身份证
@property (nonatomic,copy)   NSString * address;              //事故地点 必填
@property (nonatomic,copy)   NSString * addressRemark;        //地址备注 非必填
@property (nonatomic,copy)   NSString * carNo;                //车牌号 必填
@property (nonatomic,copy)   NSString * carColor;             //车牌颜色 必填
@property (nonatomic,strong) NSNumber * longitude;            //经度 必填
@property (nonatomic,strong) NSNumber * latitude;             //纬度 必填
@property (nonatomic,copy)   NSArray  * files;                //事故图片 列表，最多可上传30张
@property (nonatomic,copy)   NSString * remarks;              //违停图片名称  违章图片名称，字符串列表。和图片一对一，名称统一命名，车牌近照（一张）、违停照片（可多张）
@property (nonatomic,strong) NSNumber * isManualPos;          //0自动定位，1手动定位，默认0
@property (nonatomic,strong) NSNumber * type;                 //闯禁令:5010

@property (nonatomic,copy)   NSString * cutImageUrl;          //裁剪车牌近照url

@property (nonatomic,copy)   NSString * carTypeName;

@end

@interface ThroughManageSaveManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) ThroughManageSaveParam * param;

@property (nonatomic, assign) CGFloat progress;

/****** 返回数据 ******/
//无返回参数

@end


#pragma mark - 闯禁令管理是否需要二次采集API

@interface ThroughManageCarNoSecReponse : NSObject

@property (nonatomic,strong) NSArray <IllegalListModel *> * illegalList;
@property (nonatomic,copy)   NSString * deckCarNo;
@property (nonatomic,strong) NSNumber * illegalId;

@end


@interface ThroughManageCarNoSecManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * carNo;    //车牌号
@property (nonatomic, strong) NSNumber * roadId; //道路ID

/****** 返回数据 ******/
@property (nonatomic, strong) ThroughManageCarNoSecReponse * illegalReponse;

/******
 code:0 超过90秒有一次采集记录，返回一次采集ID、采集时间，提示“同路段该车于yyyy-MM-dd已被拍照采集”，跳转至二次采集页面
 code:110 提示“同路段当天已有违章行为，请不要重复采集！”
 code:13 提示“同路段该车1分30秒内有采集记录，是否重新采集？”
 code:999 无采集记录,不用任何提示
 code:1 套牌信息提醒 12小时和24小时同路段其他违章提醒
 ******/


@end


#pragma mark - 闯禁令违章车辆查询列表API

@interface ThroughManageListPagingParam : NSObject

@property (nonatomic,assign) NSInteger  start;
@property (nonatomic,assign) NSInteger  length;
@property (nonatomic,copy)   NSString * carNo;
@property (nonatomic,copy)   NSString * identNo;
@property (nonatomic,strong) NSNumber * queryType;
@property (nonatomic,strong) NSNumber * timeType;

@end


@interface ThroughManageListPagingReponse : NSObject

@property (nonatomic,copy) NSArray < IllegalParkListModel *> * list;    //包含IllegalParkListModel对象
@property (nonatomic,assign) NSInteger total;                           //总数

@end

@interface ThroughManageListPagingManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) ThroughManageListPagingParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) ThroughManageListPagingReponse * throughManageReponse;

@end


#pragma mark - 车牌查询违章次数

@interface ThroughManageCountCollectManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * carNo;

/****** 返回数据 ******/
@property (nonatomic, strong) NSNumber * carNoNumber;

@end


#pragma mark - 身份证位置次数查询

@interface ThroughManageCountIdentNoManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * identNo;

/****** 返回数据 ******/
@property (nonatomic, strong) NSNumber * identNoNumber;

@end

#pragma mark - 二次采集提交
@interface ThroughManageSecSaveManger:LRBaseRequest


/****** 请求数据 ******/
@property (nonatomic, strong) IllegalThroughSecSaveParam * param;

@property (nonatomic, assign) BOOL isUpCache;
@property (nonatomic, assign) CGFloat progress;

/****** 返回数据 ******/
//无返回参数

@end

#pragma mark - 闯禁令采集详情API


@interface ThroughManageDetailManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * illegalThroughId;

/****** 返回数据 ******/
@property (nonatomic, strong) IllegalParkDetailModel * illegalDetailModel;

@end

