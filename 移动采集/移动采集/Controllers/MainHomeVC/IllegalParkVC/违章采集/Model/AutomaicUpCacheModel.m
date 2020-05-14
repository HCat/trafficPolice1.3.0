//
//  AutomaicUpCacheModel.m
//  移动采集
//
//  Created by hcat on 2018/10/16.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "AutomaicUpCacheModel.h"

@implementation AutomaicUpCacheModel

LRSingletonM(Default)

- (void)setIsAutoPark:(BOOL)isAutoPark{
    [[NSUserDefaults standardUserDefaults] setBool:isAutoPark forKey:USERDEFAULT_KEY_ISAUTOPARK];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isAutoPark{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISAUTOPARK];
    
}

- (void)setIsAutoReversePark:(BOOL)isAutoReversePark{
    [[NSUserDefaults standardUserDefaults] setBool:isAutoReversePark forKey:USERDEFAULT_KEY_ISAUTOREVERSEPARK];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isAutoReversePark{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISAUTOREVERSEPARK];
    
}

- (void)setIsAutoLockPark:(BOOL)isAutoLockPark{
    [[NSUserDefaults standardUserDefaults] setBool:isAutoLockPark forKey:USERDEFAULT_KEY_ISAUTOLOCKPARK];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isAutoLockPark{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISAUTOLOCKPARK];
    
}

- (void)setIsAutoCarInfoAdd:(BOOL)isAutoCarInfoAdd{
    [[NSUserDefaults standardUserDefaults] setBool:isAutoCarInfoAdd forKey:USERDEFAULT_KEY_ISAUTOCARINFOADD];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isAutoCarInfoAdd{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISAUTOCARINFOADD];
    
}

- (void)setIsAutoThrough:(BOOL)isAutoThrough{
    [[NSUserDefaults standardUserDefaults] setBool:isAutoThrough forKey:USERDEFAULT_KEY_ISAUTOTHROUGH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isAutoThrough{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISAUTOTHROUGH];
    
}

- (void)setIsAutoAccident:(BOOL)isAutoAccident{
    [[NSUserDefaults standardUserDefaults] setBool:isAutoAccident forKey:USERDEFAULT_KEY_ISAUTOACCIDENT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isAutoAccident{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISAUTOACCIDENT];
    
}
- (void)setIsAutoFastAccident:(BOOL)isAutoFastAccident{
    [[NSUserDefaults standardUserDefaults] setBool:isAutoFastAccident forKey:USERDEFAULT_KEY_ISAUTOFASTACCIDENT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isAutoFastAccident{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISAUTOFASTACCIDENT];
    
}

@end
