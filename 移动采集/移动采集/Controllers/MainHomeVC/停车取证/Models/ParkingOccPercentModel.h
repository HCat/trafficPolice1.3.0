//
//  ParkingOccPercentModel.h
//  移动采集
//
//  Created by hcat on 2019/7/26.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ParkingOccPercentModel : NSObject

@property (nonatomic,strong) NSNumber * parkingstatus;      //停车状态   0=白色；1=黄色；2=黄色驶离；3=绿色；4=绿色驶离；5=红色；6=红色驶离；
@property (nonatomic,strong) NSNumber * workFlag;           //待处理施工工单状态          0=无；1=有；
@property (nonatomic,strong) NSNumber * repairFlag;         //待处理报障工单状态        0=无；1=有；
@property (nonatomic,strong) NSNumber * evidenceFlag;       //待处理取证工单状态       0=无；1=有；
@property (nonatomic,copy) NSString * parklotid;            //片区id        片区唯一标识
@property (nonatomic,copy) NSString * parklotname;          //片区名
@property (nonatomic,copy) NSString * parkplaceid;          //车位ID
@property (nonatomic,copy) NSString * placenum;             //泊位号
@property (nonatomic,copy) NSString * area;                 //所属区域
@property (nonatomic,strong) NSNumber * parktype;           //车位类型
@property (nonatomic,strong) NSNumber * longtitude;         //车位经度
@property (nonatomic,strong) NSNumber * latitude;           //车位纬度
@property (nonatomic,strong) NSNumber * status;             //车位状态         0、空闲 1、使用中
@property (nonatomic,strong) NSNumber * updatetime;           //状态更新时间



@end

NS_ASSUME_NONNULL_END
