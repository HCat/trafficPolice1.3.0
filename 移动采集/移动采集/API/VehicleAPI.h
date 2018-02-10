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

