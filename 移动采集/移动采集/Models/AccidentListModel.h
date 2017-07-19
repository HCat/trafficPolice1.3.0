//
//  AccidentListModel.h
//  trafficPolice
//
//  Created by hcat on 2017/5/19.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccidentListModel : NSObject

@property (nonatomic,strong) NSNumber * accidentId;         //事故ID
@property (nonatomic,copy)   NSString * departmentName;     //单位名称
@property (nonatomic,strong) NSNumber * happenTime;         //事故时间
@property (nonatomic,copy)   NSString * roadName;           //事故路段
@property (nonatomic,copy)   NSString * address;            //事故地址
@property (nonatomic,copy)   NSString * operatorName;       //经办民警

@end
