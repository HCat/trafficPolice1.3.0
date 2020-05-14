//
//  AccidentDetailsModel.m
//  移动采集
//
//  Created by hcat on 2018/7/25.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "AccidentDetailsModel.h"

@implementation AccidentInfoModel

@end

@implementation AccidentDetailsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"picList" : [AccidentPicListModel class],
             @"accidentList" : [AccidentPeopleModel class]
             };
}

@end
