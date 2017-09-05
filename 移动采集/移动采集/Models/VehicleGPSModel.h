//
//  VehicleGPSModel.h
//  移动采集
//
//  Created by hcat on 2017/9/5.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehicleGPSModel : NSObject

@property (nonatomic,strong) NSNumber * longitude;      //经度
@property (nonatomic,strong) NSNumber * latitude;       //纬度
@property (nonatomic,strong) NSNumber * vehicleId;      //车辆Id
@property (nonatomic,strong) NSNumber * plateNo;        //车牌号


@end
