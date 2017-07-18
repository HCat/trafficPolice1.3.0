//
//  CommonAPI.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "ImageFileInfo.h"

#pragma mark - 获取当前天气API

@interface CommonGetWeatherManger:LRBaseRequest

/****** 请求数据 ******/

@property (nonatomic, copy) NSString *location; //经度+“,”+纬度,示例（118.184872,24.497949）

/****** 返回数据 ******/
@property (nonatomic, copy) NSString *weather; //天气

@end


#pragma mark - 证件识别API

@interface CommonIdentifyResponse : NSObject

@property (nonatomic, copy) NSString *carNo;        //车牌号
@property (nonatomic, copy) NSString *vehicleType;  //车辆类型
@property (nonatomic, copy) NSString *name;         //姓名，或者车辆所有人
@property (nonatomic, copy) NSString *idNo;         //证件号码

@end

@interface CommonIdentifyManger:LRBaseRequest

/****** 请求数据 ******/

@property (nonatomic, strong) ImageFileInfo *imageInfo; //文件
@property (nonatomic, assign) NSInteger type; //文件类型1：车牌号 2：身份证 3：驾驶证 4：行驶证

/****** 返回数据 ******/
@property (nonatomic, copy) CommonIdentifyResponse *commonIdentifyResponse; //证件信息

@end

#pragma mark - 获取路名API

@interface CommonGetRoadModel : NSObject

@property (nonatomic,copy) NSNumber *getRoadId;     //通用值id
@property (nonatomic,copy) NSString *getRoadName;   //通用值名称


@end


@interface CommonGetRoadManger : LRBaseRequest

/****** 请求数据 ******/
/***请求参数中有token值，运用统一添加参数的办法添加到后面所有需要token参数的请求中,具体调用LRBaseRequest中的+ (void)setupRequestFilters:(NSDictionary *)arguments 方法***/

/****** 返回数据 ******/
@property (nonatomic, copy) NSArray<CommonGetRoadModel *> *commonGetRoadResponse; //证件信息

@end

#pragma mark - 获取图片轮播API

@interface CommonGetImgPlayModel : NSObject

@property (nonatomic,copy) NSString *getImgPlayTitle;     //图片名称(预留)
@property (nonatomic,copy) NSString *getImgPlayImgUrl;   //图片地址
@property (nonatomic,copy) NSString *getImgPlayUrl;   //图片地址

@end


@interface CommonGetImgPlayManger : LRBaseRequest

/****** 请求数据 ******/
/***请求参数中有token值，运用统一添加参数的办法添加到后面所有需要token参数的请求中,具体调用LRBaseRequest中的+ (void)setupRequestFilters:(NSDictionary *)arguments 方法***/

/****** 返回数据 ******/
@property (nonatomic, copy) NSArray<CommonGetImgPlayModel *> *commonGetImgPlayModel; //轮播图片信息

@end

#pragma mark - 版本更新API

@interface CommonVersionUpdateModel : NSObject

@property (nonatomic,copy) NSString *versionCode;     //版本号
@property (nonatomic,copy) NSString *versionName;   //版本名称
@property (nonatomic,copy) NSString *versionUrl;   //下载地址
@property (nonatomic,copy) NSString *versionMemo;   //版本说明
@property (nonatomic,assign) BOOL isForce;   //是否强制更新

@end


@interface CommonVersionUpdateManger : LRBaseRequest

/****** 请求数据 ******/
/***请求参数中有token值，运用统一添加参数的办法添加到后面所有需要token参数的请求中,具体调用LRBaseRequest中的+ (void)setupRequestFilters:(NSDictionary *)arguments 方法***/

/****** 返回数据 ******/
@property (nonatomic, strong) CommonVersionUpdateModel *commonVersionUpdateModel; //版本信息信息

@end

#pragma mark - 投诉建议API

@interface CommonAdviceManger : LRBaseRequest

/****** 请求数据 ******/
/***请求参数中有token值，运用统一添加参数的办法添加到后面所有需要token参数的请求中,具体调用LRBaseRequest中的+ (void)setupRequestFilters:(NSDictionary *)arguments 方法***/
@property(nonatomic,copy) NSString *msg;

/****** 返回数据 ******/
//无返回参数

@end

#pragma mark - 查询是否需要游客登录API

@interface CommonValidVisitorManger : LRBaseRequest

/****** 请求数据 ******/
/***请求参数中有token值，运用统一添加参数的办法添加到后面所有需要token参数的请求中,具体调用LRBaseRequest中的+ (void)setupRequestFilters:(NSDictionary *)arguments 方法***/

/****** 返回数据 ******/
//msg 0 不显示游客登录  1显示游客登录


@end







