//
//  IllegalThroughSecDetailModel.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/21.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalThroughSecDetailModel.h"

@implementation IllegalThroughSecDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pictures" : [AccidentPicListModel class]
             };
}


@end
