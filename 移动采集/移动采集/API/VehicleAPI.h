//
//  VehicleAPI.h
//  移动采集
//
//  Created by hcat on 2017/9/5.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "MemberInfoModel.h"
#import "VehicleModel.h"
#import "VehicleRemarkModel.h"
#import "VehicleDriverModel.h"
#import "VehicleGPSModel.h"
#import "VehicleRouteModel.h"
#import "VehicleAlarmModel.h"
#import "VehicleUpDetailModel.h"

#pragma mark -返回重点车辆信息

@interface VehicleImageModel : NSObject

@property (nonatomic,copy) NSString *mediaId;       //照片Id
@property (nonatomic,copy) NSString *mediaUrl;
@property (nonatomic,copy) NSString *mediaThumbUrl; //缩略图url
@property (nonatomic,copy) NSString *mediaThumbWaterUrl;   //压缩水印图片url
@property (nonatomic,copy) NSString *resType;   //图片类型
@property (nonatomic,copy) NSString *isID;      //是否是身份证


@end


@interface VehicleDetailReponse : NSObject

@property (nonatomic,strong) VehicleModel * vehicle;                //车辆信息
@property (nonatomic,strong)   NSMutableArray <VehicleImageModel *> * vehicleImgList; //车辆证件照片

@property (nonatomic,strong) MemberInfoModel * memberInfo;          //运输主体信息
@property (nonatomic,copy)   NSString * memberArea;                 //运输主体所在区域
@property (nonatomic,copy)   NSArray <VehicleImageModel *> * memberImgList;  //运输主体资质照片

@property (nonatomic,copy)   NSArray <VehicleRemarkModel *> * vehicleRemarkList; //车辆备注信息
@property (nonatomic,copy)   NSArray <VehicleDriverModel *> * driverList;        //驾驶员资料

@property (nonatomic,strong) VehicleRouteModel *vehicleRoute;       //车辆路线信息
@property (nonatomic,strong) NSNumber *isReportEdit;    //车辆路线信息
@property (nonatomic,strong) NSNumber *isBindGps;       //是否绑定gps,1绑定,0没绑定
@property (nonatomic,strong) NSNumber *isOnline;        //绑定才有这个值,1在线,0不在线

@end


#pragma mark - 根据二维码编号获取车辆、运输主体、驾驶员信息

@interface VehicleDetailByQrCodeManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * qrCode;

/****** 返回数据 ******/
@property (nonatomic, strong) VehicleDetailReponse * vehicleDetailReponse;

@end


#pragma mark - 根据车牌号获取车辆、运输主体、驾驶员信息

@interface VehicleDetailByPlateNoManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * plateNo;

/****** 返回数据 ******/
@property (nonatomic, strong) VehicleDetailReponse * vehicleDetailReponse;

@end



#pragma mark - 获取一定范围内车辆信息


@interface VehicleRangeLocationManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * lng;       //经度
@property (nonatomic, strong) NSNumber * lat;       //纬度
@property (nonatomic, strong) NSNumber * range;     //范围
@property (nonatomic, strong) NSNumber * carType;   //车辆类型 1警务车 2土方车

/****** 返回数据 ******/
@property (nonatomic, strong) NSArray <VehicleGPSModel *> * vehicleGpsList;

@end

#pragma mark - 获取全部车辆信息


@interface VehicleLocationManger:LRBaseRequest

/****** 请求数据 ******/

@property (nonatomic, strong) NSNumber * carType;   //车辆类型 1警务车 2土方车

/****** 返回数据 ******/
@property (nonatomic, strong) NSArray <VehicleGPSModel *> * vehicleGpsList;

@end

#pragma mark - 通过车牌号获取车辆位置信息


@interface VehicleLocationByPlateNoManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * plateNo;

/****** 返回数据 ******/
@property (nonatomic, strong) VehicleGPSModel * vehicleGPSModel;

@end


#pragma mark - 根据车牌id获取车辆报备信息

@interface VehicleReportInfoReponse : NSObject


@property (nonatomic,copy)   NSString * carriageOutsideH;  //车辆外高度
@property (nonatomic,copy)   NSString * mediaId;  //晋工车辆照id
@property (nonatomic,copy)   NSString * mediaUrl;  //晋工车辆照Url
@property (nonatomic,copy)   NSString * mediaThumbUrl;  //晋工车辆缩略照Url
@property (nonatomic,copy)   NSString * mediaThumbWaterUrl;  //晋工车辆缩略水印照Url

@end

@interface VehicleReportInfoManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * vehicleId;

/****** 返回数据 ******/
@property (nonatomic, strong) VehicleReportInfoReponse * vehicleReportInfo;

@end

#pragma mark - 更新车辆报备信息


@interface VehicleUpReportInfoParam : NSObject


@property (nonatomic, copy) NSString * vehicleId;  //车辆id
@property (nonatomic, copy) NSString * carriageOutsideH;  //车辆外高低
@property (nonatomic, copy) NSString *oldImgId;  //晋工车辆照旧id
@property (nonatomic, strong) ImageFileInfo * imgFile;  //晋工车辆照文件

@end

@interface VehicleUpReportInfoManger :LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) VehicleUpReportInfoParam *param;

/****** 返回数据 ******/
@property (nonatomic, strong) VehicleImageModel *imageModel;

@end

#pragma mark - 获取车辆列表

@interface VehicleListModel : NSObject

@property (nonatomic,copy)   NSString *vehicleid;   //车辆ID
@property (nonatomic,copy)   NSString * plateNo;    //车牌号
@property (nonatomic,copy)   NSString * selfNo;     //车辆自编号

@end

@interface VehicleGetVehicleListManger: LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * content; //搜索内容
@property (nonatomic, strong) NSNumber * searchType; //搜索类型 1 搜车牌 2搜晋工号

/****** 返回数据 ******/
@property (nonatomic, strong) NSArray <VehicleListModel *> * vehicleList;

@end

#pragma mark - 获取车辆相关报警信息

@interface VehicleAlarmRecordReponse:NSObject

@property (nonatomic, strong) VehicleAreaAlarmModel *areaSpeedAlarm; //区域超速信息
@property (nonatomic, strong) VehicleRoadAlarmModel   *roadSpeedAlarm; //路口超速信息
@property (nonatomic, strong) VehicleTiredAlarmModel  *fatigueAlarm; //疲劳驾驶信息
@property (nonatomic, strong) VehicleExpireAlarmModel *vehicleExpireAlarm; //到期报警信息
@property (nonatomic, strong) NSMutableArray <NSString *> * arr_type; //拥有的类型

@end


@interface VehicleAlarmRecordManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * vehicleId;

/****** 返回数据 ******/
@property (nonatomic, strong) VehicleAlarmRecordReponse * vehicleAlarmRecord;

@end

#pragma mark - 获取超速报警列表


@interface VehicleSpeedAlarmModel : NSObject


@property (nonatomic,copy)   NSString * speed;          // 时速    40,单位km/h
@property(nonatomic,strong)  NSNumber * alarmTime;      // 时间    时间戳
@property (nonatomic,copy)   NSString * location;       // 地点
@property(nonatomic,strong)  NSNumber * longitude;      // 经度    118.17847255
@property(nonatomic,strong)  NSNumber * latitude;       // 维度    24.492077006162006

@end


@interface VehicleSpeedAlarmListParam : NSObject

@property (nonatomic, assign) NSInteger  start;  //开始的索引号    从1开始
@property (nonatomic, assign) NSInteger length;  //显示的记录数    默认为10
@property (nonatomic, copy)   NSString * vehicleid;  //车辆id
@property (nonatomic, copy)   NSString * alarmType;  //超速报警类型    字符串 ‘1’区域超速，‘111’路口超速

@end

@interface VehicleSpeedAlarmListReponse : NSObject

@property (nonatomic,copy) NSArray <VehicleSpeedAlarmModel *> * list;  //包含AccidentListModel对象
@property (nonatomic,assign) NSInteger total;                     //总数


@end

@interface VehicleSpeedAlarmListManger: LRBaseRequest

/****** 请求数据 ******/

@property (nonatomic, strong) VehicleSpeedAlarmListParam *param;

/****** 返回数据 ******/
@property (nonatomic, strong) VehicleSpeedAlarmListReponse * speedAlarmListReponse;

@end



#pragma mark - 获取疲劳驾驶报警图片列表

@interface VehicleTiredImageListParam : NSObject

@property (nonatomic, copy)   NSString * plateNo;       //车牌    车牌号
@property (nonatomic, copy)   NSString * startTime;     //图片开始时间    字符串‘2018-05-03 14:59:06’
@property (nonatomic, copy)   NSString * endTime;       //图片结束时间    字符串‘2018-05-03 15:59:06’

@end


@interface VehicleTiredImageListManger: LRBaseRequest

/****** 请求数据 ******/

@property (nonatomic, strong) VehicleTiredImageListParam *param;

/****** 返回数据 ******/
@property (nonatomic,copy) NSArray <VehicleTiredImageModel *> * imageList;  //包含VehicleImageModel对象

@end


#pragma mark - 车辆上报功能

@interface VehicleCarlUpParam : NSObject
@property (nonatomic,copy)    NSString * creatorId;       //录入者ID
@property (nonatomic,copy)    NSString * plateNo;         //车牌号 必填
@property (nonatomic,copy)    NSString * driver;          //驾驶员姓名 必填，可用身份证、驾驶证识别
@property (nonatomic,copy)    NSString * idCardNum;       //驾驶员身份证号码 必填，可用身份证、驾驶证识别
@property (nonatomic,strong)  NSNumber * roadId;          //道路ID 必填，从通用值【道路】获取ID
@property (nonatomic,copy)    NSString * road;            //道路名字 如果roadId为0的时候设置
@property (nonatomic,copy)    NSString * position;        //事故地点 必填
@property (nonatomic,copy)  NSString * illegalType;      //违法类型

@property (nonatomic,copy)    NSArray  * files;           //上传上报图片 列表，最多可上传30张
@property (nonatomic,copy)    NSString * remark;        //上报备注

@end

@interface  VehicleCarlUpManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) VehicleCarlUpParam *param;

/****** 返回数据 ******/
//无返回参数

@end

#pragma mark - 违法类型获取

@interface VehicleCodeInfo : NSObject

@property (nonatomic,copy)    NSString * typeCode;       //违法类型    ILLEGAL_TYPE
@property (nonatomic,copy)    NSString * typeName;       //违法名称    违法类型
@property (nonatomic,copy)    NSString * configName;     //具体违法内容    超载、闯红灯、发神经....
@property (nonatomic,strong)  NSNumber * configCode;     //具体违法内容的编号    11
@property (nonatomic,strong)  NSNumber * indexNo;        //内容顺序编号    11
@property (nonatomic,strong)  NSNumber * orgCode;        //机构编号

@end

@interface  VehicleGetCodeTypeManger:LRBaseRequest


/****** 返回数据 ******/
@property (nonatomic,copy) NSArray <VehicleCodeInfo *> * list;  //包含VehicleImageModel对象


@end


#pragma mark - 获取上报录入列表

@interface VehicleUpCarListParam : NSObject

@property (nonatomic, assign) NSInteger  start;  //开始的索引号    从1开始
@property (nonatomic, assign) NSInteger length;  //显示的记录数    默认为10
@property (nonatomic, copy)   NSString * carId;  //车辆id
@property (nonatomic, copy)   NSString * plateNo;  //车牌号

@end

@interface VehicleUpCarListReponse : NSObject

@property (nonatomic,copy) NSArray <VehicleUpDetailModel *> * list;  //包含AccidentListModel对象
@property (nonatomic,assign) NSInteger total;                     //总数


@end

@interface VehicleUpCarListManger: LRBaseRequest

/****** 请求数据 ******/

@property (nonatomic, strong) VehicleUpCarListParam *param;

/****** 返回数据 ******/
@property (nonatomic, strong) VehicleUpCarListReponse * upCarListReponse;

@end

#pragma mark - 违法录入详细信息

@interface VehicleUpCarDetailManger: LRBaseRequest

/****** 请求数据 ******/

@property (nonatomic, copy) NSString *vehicleUpId;

/****** 返回数据 ******/
@property (nonatomic, strong) VehicleUpDetailModel * detailReponse;

@end


#pragma mark - 获取有效路线接口

@interface VehicleRouteAddressModel :NSObject

@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * name;

@end

@interface VehicleRouteDetailModel: NSObject

@property (nonatomic, copy) NSString * projectWorkTime1; //时段
@property (nonatomic, copy) NSString * projectWorkTime2; //时段
@property (nonatomic, copy) NSString * projectWorkTime3; //时段
@property (nonatomic, copy) NSString * projectWorkTime4; //时段
@property (nonatomic, copy) NSArray <VehicleRouteAddressModel *> * routeDetentionList; //滞纳场list
@property (nonatomic, copy) NSString * projectStartDate; //开始时间
@property (nonatomic, copy) NSString * projectendDate; //结束时间
@property (nonatomic, copy) NSString * acrossRoad; //途经路段
@property (nonatomic, copy) NSString * routePoints; //坐标



@end


@interface VehicleGetRouteApprovalManger: LRBaseRequest

/****** 请求数据 ******/

@property (nonatomic, copy) NSString *vehicleId;

/****** 返回数据 ******/
@property (nonatomic, strong) VehicleRouteDetailModel * detailReponse;

@end






