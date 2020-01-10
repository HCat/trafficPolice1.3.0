//
//  DailyPatrolListModel.m
//  移动采集
//
//  Created by hcat-89 on 2020/1/8.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "DailyPatrolListModel.h"

@implementation DailyPatrolListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"shiftId" : @"id",
             };
}

@end
