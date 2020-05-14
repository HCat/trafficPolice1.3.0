//
//  vehicleDriverModel.m
//  移动采集
//
//  Created by hcat on 2017/9/5.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "VehicleDriverModel.h"
#import "VehicleAPI.h"


@implementation VehicleDriverModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"driverImgList" : [VehicleImageModel class],
             @"vehicleImgList" : [VehicleImageModel class]
            
             };
}

@end
