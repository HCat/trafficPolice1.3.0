//
//  DeliveryInfoModel.m
//  移动采集
//
//  Created by hcat on 2019/5/9.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "DeliveryInfoModel.h"

@implementation DeliveryCompanyModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"companyId" : @"id",
             };
}

@end

@implementation DeliveryVehicleInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"vehicleId" : @"id",
             };
}

@end

@implementation DeliveryInfoModel


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"deliveryId" : @"id",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"dcList" : [DeliveryCompanyModel class],
             @"dvList" : [DeliveryVehicleInfoModel class]
             };
}


@end
