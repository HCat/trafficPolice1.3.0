//
//  PowerAPI.m
//  移动采集
//
//  Created by hcat on 2017/7/19.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "PowerAPI.h"

@implementation PowListManger

- (NSString *)requestUrl
{
    return URL_IDENTIFY_LIST;
}


//返回参数
- (NSArray *)powList{
    
    if (self.responseModel.data) {
        return _powList = (NSArray *)self.responseModel.data;
    }
    
    return nil;
}

@end
