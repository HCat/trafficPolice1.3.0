//
//  ParkingManageListModel.m
//  移动采集
//
//  Created by hcat on 2019/9/19.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingManageListModel.h"

@implementation ParkingManageListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"parkingId" : @"id",
             };
}

@end
