//
//  VehicleUpDetailModel.m
//  移动采集
//
//  Created by hcat on 2018/5/25.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleUpDetailModel.h"

@implementation VehcleUpImageModel



@end



@implementation VehicleUpDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"upId" : @"Id",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"imgList" : [VehcleUpImageModel class]
             };
}


@end
