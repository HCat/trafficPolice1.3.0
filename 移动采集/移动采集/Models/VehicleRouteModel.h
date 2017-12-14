//
//  VehicleRouteModel.h
//  移动采集
//
//  Created by hcat on 2017/12/14.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehicleRouteModel : NSObject

@property (nonatomic,copy)   NSString * jobSite;        //作业地点
@property (nonatomic,strong) NSNumber * quantity;       //土方运量
@property (nonatomic,strong) NSNumber * jobStartTime;   //开始时间
@property (nonatomic,strong) NSNumber * jobEndTime;     //结束时间
@property (nonatomic,copy)   NSString * route;          //行驶路线

@end
