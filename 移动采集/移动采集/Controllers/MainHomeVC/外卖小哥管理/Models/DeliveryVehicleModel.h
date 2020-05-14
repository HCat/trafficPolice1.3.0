//
//  DeliveryVehicleModel.h
//  移动采集
//
//  Created by hcat on 2019/5/9.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeliveryVehicleModel : NSObject

@property (nonatomic,copy) NSString * vehicleId;   //车辆id
@property (nonatomic,copy) NSString * plateNo;     //车牌号
@property (nonatomic,copy) NSString * color;       //车身颜色
@property (nonatomic,copy) NSString * brandModel;  //厂牌型号
@property (nonatomic,copy) NSString * frameNo;     //车架号
@property (nonatomic,copy) NSString * vehicleType; //车辆类型
@property (nonatomic,copy) NSString * picUrl;      //车身照片



@end

NS_ASSUME_NONNULL_END
