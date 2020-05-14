//
//  IllegalAPI.h
//  移动采集
//
//  Created by hcat-89 on 2020/2/13.
//  Copyright © 2020 Hcat. All rights reserved.
//

//新版采集功能。石狮采集接口。是否替换为新的采集功能待定

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "IllegalParkListModel.h"
#import "IllegalParkAPI.h" //添加是为了获取IllegalListModel这个对象
#import "AccidentPicListModel.h"
#import "IllegalCollectModel.h"



#pragma mark - 违章采集增加API

@interface IllegalSaveParam :  NSObject

@property (nonatomic,strong) NSNumber * roadId;               //道路ID 必填，从通用值【道路】获取ID
@property (nonatomic,copy)   NSString * roadName;             //道路名字 如果roadId为0的时候设置
@property (nonatomic,copy)   NSString * address;              //事故地点 必填
@property (nonatomic,copy)   NSString * addressRemark;        //地址备注 非必填
@property (nonatomic,copy)   NSString * carNo;                //车牌号 必填
@property (nonatomic,copy)   NSString * carColor;             //车牌颜色 必填
@property (nonatomic,strong) NSNumber * longitude;            //经度 必填
@property (nonatomic,strong) NSNumber * latitude;             //纬度 必填
@property (nonatomic,copy)   NSArray  * files;                //事故图片 列表，最多可上传30张
@property (nonatomic,copy)   NSString * remarks;              //违停图片名称  违章图片名称，字符串列表。和图片一对一，名称统一命名，车牌近照（一张）、违停照片（可多张）
@property (nonatomic,copy)   NSString * cutImageUrl;          //裁剪车牌近照url 两个参数同时不为空才有效，没有则不填
@property (nonatomic,copy)   NSString * taketime;             //裁剪车牌近照时间
@property (nonatomic,strong) NSNumber * isManualPos;          //0自动定位，1手动定位，默认0
@property (nonatomic,strong) NSNumber * offtime;              //缓存时候的时间段


@end


@interface IllegalSaveManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) IllegalSaveParam * param;
@property (nonatomic, assign) CGFloat progress;

/****** 返回数据 ******/
//无返回参数

@end

#pragma mark - 违章采集查询是否需要二次采集API

@interface IllegalCarNoSecReponse : NSObject

@property (nonatomic,strong) NSArray <IllegalListModel *> * illegalList;
@property (nonatomic,copy)   NSString * deckCarNo;
@property (nonatomic,strong) NSNumber * illegalId;

@end


@interface IllegalCarNoSecManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * carNo;    //车牌号
@property (nonatomic, strong) NSNumber * roadId; //道路ID

/****** 返回数据 ******/
@property (nonatomic, strong) IllegalCarNoSecReponse * illegalReponse;

/******
 code:0 超过90秒有一次采集记录，返回一次采集ID、采集时间，提示“同路段该车于yyyy-MM-dd已被拍照采集”，跳转至二次采集页面
 code:110 提示“同路段当天已有违章行为，请不要重复采集！”
 code:13 提示“同路段该车1分30秒内有采集记录，是否重新采集？”
 code:999 无采集记录,不用任何提示
 code:1 套牌信息提醒 12小时和24小时同路段其他违章提醒
 ******/


@end


#pragma mark - 违章采集二次采集加载数据API

@interface IllegalSecDetailModel : NSObject

@property (nonatomic,strong) IllegalCollectModel * illegalCollect; //事故对象
@property (nonatomic,copy)   NSString * roadName; //路名
@property (nonatomic,copy)   NSArray<AccidentPicListModel *> * pictures;

@end

@interface IllegalSecLoadManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * illegalId;

/****** 返回数据 ******/

@property (nonatomic, strong) IllegalSecDetailModel * illegalSecDetailModel;


@end

#pragma mark - 违反禁令二次采集保存数据API

@interface IllegalSecAddParam : NSObject

@property (nonatomic,strong) NSNumber  * illegalId;  //id
@property (nonatomic,copy)   NSArray   * files;             //事故图片 列表，最多可上传30张
@property (nonatomic,copy)   NSString  * remarks;           //违停图片名称  违章图片名称，字符串列表。和图片一对一，名称统一命名，车牌近照（一张）、违停照片（可多张）
@property (nonatomic,strong) NSNumber  * offtime;           //缓存时候的时间段

@end


@interface IllegalSecAddManger:LRBaseRequest

/****** 请求数据 ******/
/****** 请求数据 ******/
@property (nonatomic, strong) IllegalSecAddParam * param;

@property (nonatomic, assign) CGFloat progress;

/****** 返回数据 ******/
//无返回参数

@end


#pragma mark - 违章采集列表API

@interface IllegalListPagingParam : NSObject

@property (nonatomic,assign) NSInteger  start;   //开始的索引号 从0开始
@property (nonatomic,assign) NSInteger  length;  //显示的记录数 默认为10
@property (nonatomic,copy)   NSString * search;  //搜索的关键字
@property (nonatomic,strong) NSNumber *  state;   //上报状态

@end

@interface IllegalListPagingReponse : NSObject

@property (nonatomic,copy) NSArray < IllegalParkListModel *> * list;    //包含IllegalParkListModel对象
@property (nonatomic,assign) NSInteger total;                           //总数
@property (nonatomic,strong) NSNumber * permission;                     //确认异常权限 true有 false没有

@end

@interface IllegalListPagingManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) IllegalListPagingParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) IllegalListPagingReponse * illegalReponse;

@end

#pragma mark - 违章采集详情API


@interface IllegalAddDetailManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * illegalParkId;

/****** 返回数据 ******/
@property (nonatomic, strong) IllegalParkDetailModel * illegalDetailModel;

@end

#pragma mark - 确认异常API

@interface IllegalMakeSureAbnormalManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * illegalParkId;


@end



