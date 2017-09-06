//
//  VehicleCarAnnotation.h
//  移动采集
//
//  Created by hcat on 2017/9/6.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "VehicleGPSModel.h"

@interface VehicleCarAnnotation : MAPointAnnotation

@property (nonatomic,strong) VehicleGPSModel *vehicleCar;
@property (nonatomic,strong) NSNumber *carType; //车辆类型, 1为警车,2为土方车

@end
