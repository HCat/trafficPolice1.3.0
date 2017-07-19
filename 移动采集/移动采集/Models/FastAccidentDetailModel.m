//
//  FastAccidentDetailModel.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/19.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "FastAccidentDetailModel.h"

@implementation FastAccidentDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"picList" : [AccidentPicListModel class]
             };
}

@end
