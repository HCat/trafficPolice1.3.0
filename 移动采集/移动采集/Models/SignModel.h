//
//  SignModel.h
//  移动采集
//
//  Created by hcat on 2017/9/4.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignModel : NSObject

@property (nonatomic,strong) NSNumber *workstate;   //状态：0签退1签到
@property (nonatomic,copy) NSString *address;       //地址
@property (nonatomic,copy) NSString *createTime;    //时间

@end
