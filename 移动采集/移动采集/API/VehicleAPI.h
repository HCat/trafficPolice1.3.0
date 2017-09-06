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

#pragma mark -返回重点车辆信息

@interface VehicleDetailReponse : NSObject

@property (nonatomic,strong) MemberInfoModel * memberInfo;          //运输主体信息
@property (nonatomic,copy)   NSString * memberArea;                 //包含IdentifyModel对象
@property (nonatomic,assign) NSArray <NSString *> * memberImgList;  //运输主体资质照片
@property (nonatomic,strong) VehicleModel * vehicle;                //车辆信息
@property (nonatomic,assign) NSArray <NSString *> * vehicleImgList; //车辆证件照片
@property (nonatomic,assign) NSArray <VehicleRemarkModel *> * vehicleRemarkList; //车辆证件照片
@property (nonatomic,assign) NSArray <VehicleDriverModel *> * driverList;        //车辆证件照片

@end


#pragma mark - 根据二维码编号获取车辆、运输主体、驾驶员信息

@interface VehicleDetailByQrCodeManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * qrCode;

/****** 返回数据 ******/
@property (nonatomic, strong) VehicleDetailReponse * vehicleDetailReponse;

@end


#pragma mark - 根据车牌号获取车辆、运输主体、驾驶员信息

@interface VehicleDetailByPlateNoManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * plateNo;

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



