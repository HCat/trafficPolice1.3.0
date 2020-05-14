//
//  DeliveryIllegalDetailModel.m
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "DeliveryIllegalDetailModel.h"

@implementation DeliveryIllegalImageModel

@end

@implementation DeliveryIllegalCollectModel

@end

@implementation DeliveryIllegalDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"picList" : [DeliveryIllegalImageModel class]
             };
}

@end
