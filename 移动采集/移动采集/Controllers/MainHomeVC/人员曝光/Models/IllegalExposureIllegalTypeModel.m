//
//  IllegalExposureIllegalTypeModel.m
//  移动采集
//
//  Created by hcat on 2019/12/5.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "IllegalExposureIllegalTypeModel.h"

@implementation IllegalExposureIllegalTypeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"illegalId" : @"id",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"exposureTypeList" : [IllegalExposureIllegalTypeModel class]
             };
}

@end
