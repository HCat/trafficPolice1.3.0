//
//  AccidentListModel.m
//  trafficPolice
//
//  Created by hcat on 2017/5/19.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AccidentListModel.h"

@implementation AccidentListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"accidentId" : @"id",
             };
}

@end
