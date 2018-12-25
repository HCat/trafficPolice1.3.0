//
//  PoliceDistributeAnnotation.h
//  移动采集
//
//  Created by hcat on 2018/11/14.
//  Copyright © 2018 Hcat. All rights reserved.
//

//  地图上面显示的警员点或者警车点

#import <MAMapKit/MAMapKit.h>
#import "PoliceLocationModel.h"
#import "VehicleGPSModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PoliceDistributeAnnotation : MAPointAnnotation

@property (nonatomic,strong) PoliceLocationModel * policeModel;     //警员信息
@property (nonatomic,strong) VehicleGPSModel *vehicleCar;           //警车信息
@property (nonatomic,strong) NSNumber * policeType; //车辆类型, 1为警员,2为警车


@end

NS_ASSUME_NONNULL_END
