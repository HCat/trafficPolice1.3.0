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
@property (nonatomic,copy)   NSString * operatorName;       //处理民警
@property (nonatomic,copy)   NSString * entryManName;       //采集人员
@property (nonatomic,strong) NSNumber * state;              //1为结案(已处理) 3为中队调解中(前端星标)

@end
