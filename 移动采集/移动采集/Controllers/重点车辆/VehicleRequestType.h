//
//  VehicleRequestType.h
//  移动采集
//
//  Created by hcat on 2018/5/14.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#ifndef VehicleRequestType_h
#define VehicleRequestType_h

typedef NS_ENUM(NSInteger, VehicleRequestType) {
    VehicleRequestTypeQRCode,      //二维码
    VehicleRequestTypeCarNumber,   //车牌号码
};


typedef NS_ENUM(NSUInteger, VehicleCellType) {
    VehicleCellTypeVehicleCar,  //车辆信息
    VehicleCellTypeMember,      //运输主体
    VehicleCellTypeDriver,      //驾驶员信息
    VehicleCellTypeRemark,      //备注信息
    VehicleCellTypeRoute,       //行驶路线
    
};





#endif /* VehicleRequestType_h */
