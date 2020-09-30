//
//  LocationStorage.h
//  移动采集
//
//  Created by hcat on 2017/10/30.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationStorageModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *streetName;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, copy) NSString *type;

@end

@interface LocationStorage : NSObject
LRSingletonH(Default)


@property (nonatomic, assign) BOOL isPark;              //违法停车（晋江）
@property (nonatomic, assign) BOOL isThrough;           //违反禁令
@property (nonatomic, assign) BOOL isTowardError;       //不按朝向
@property (nonatomic, assign) BOOL isLockCar;           //违停锁车
@property (nonatomic, assign) BOOL isMotorBike;         //摩托车采集
@property (nonatomic, assign) BOOL isInforInput;        //车辆录入
@property (nonatomic, assign) BOOL isVehicle;
@property (nonatomic, assign) BOOL isInhibitLine;       //违反禁止线
@property (nonatomic, assign) BOOL isTakeOut;           //外卖监管
@property (nonatomic, assign) BOOL isIllegalExposure;   //违法录入
@property (nonatomic, assign) BOOL isIllegal;              //违章采集(石狮)
@property (nonatomic, assign) BOOL isThroughManage;     //闯禁令管理


@property (nonatomic, strong) LocationStorageModel *park;
@property (nonatomic, strong) LocationStorageModel *through;
@property (nonatomic, strong) LocationStorageModel *towardError;
@property (nonatomic, strong) LocationStorageModel *lockCar;
@property (nonatomic, strong) LocationStorageModel *motorBike;
@property (nonatomic, strong) LocationStorageModel *inforInput;
@property (nonatomic, strong) LocationStorageModel *vehicle;
@property (nonatomic, strong) LocationStorageModel *inhibitLine;
@property (nonatomic, strong) LocationStorageModel *takeOut;
@property (nonatomic, strong) LocationStorageModel *illegalExposure;
@property (nonatomic, strong) LocationStorageModel *illegal;            //石狮违停采集
@property (nonatomic, strong) LocationStorageModel *throughManage;






- (void)initializationSwitchLocation; //默认开启定位开关
- (void)closeLocation:(ParkType)type;
- (void)startLocation:(ParkType)type;

@end
