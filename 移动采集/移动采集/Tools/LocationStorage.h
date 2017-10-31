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


@property (nonatomic, assign) BOOL isPark;
@property (nonatomic, assign) BOOL isThrough;
@property (nonatomic, assign) BOOL isTowardError;
@property (nonatomic, assign) BOOL isLockCar;
@property (nonatomic, assign) BOOL isInforInput;


@property (nonatomic, strong) LocationStorageModel *park;
@property (nonatomic, strong) LocationStorageModel *through;
@property (nonatomic, strong) LocationStorageModel *towardError;
@property (nonatomic, strong) LocationStorageModel *lockCar;
@property (nonatomic, strong) LocationStorageModel *inforInput;


- (void)initializationSwitchLocation; //默认开启定位开关
- (void)closeLocation:(ParkType)type;
- (void)startLocation:(ParkType)type;

@end
