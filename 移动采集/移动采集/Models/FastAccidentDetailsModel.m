//
//  FastAccidentDetailsModel.m
//  移动采集
//
//  Created by hcat on 2018/7/25.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "FastAccidentDetailsModel.h"

@implementation FastAccidentDetailsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"picList" : [AccidentPicListModel class],
             @"accidentList" : [AccidentPeopleModel class]
             };
}
@end
