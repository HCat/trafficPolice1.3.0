//
//  PoliceLocationModel.m
//  移动采集
//
//  Created by hcat on 2018/11/14.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "PoliceLocationModel.h"

@implementation PoliceLocationModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"groupIds" : [NSNumber class],
             @"groupNames" : [NSString class]
             };
}

@end
