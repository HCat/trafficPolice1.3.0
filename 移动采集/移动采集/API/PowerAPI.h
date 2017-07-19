//
//  PowerAPI.h
//  移动采集
//
//  Created by hcat on 2017/7/19.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"

@interface PowListManger:LRBaseRequest

/****** 返回数据 ******/
@property (nonatomic, copy) NSArray * powList;

@end
