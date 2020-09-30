//
//  LocationStorage.m
//  移动采集
//
//  Created by hcat on 2017/10/30.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "LocationStorage.h"

@implementation LocationStorageModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.streetName forKey:@"streetName"];
    [aCoder encodeObject:self.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
    [aCoder encodeObject:self.type forKey:@"type"];

}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.streetName = [aDecoder decodeObjectForKey:@"streetName"];
        self.longitude = [aDecoder decodeObjectForKey:@"longitude"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
    }
    return self;

}

@end

@implementation LocationStorage
LRSingletonM(Default)

- (void)initializationSwitchLocation{
    [self setIsPark:YES];
    [self setIsThrough:YES];
    [self setIsTowardError:YES];
    [self setIsLockCar:YES];
    [self setIsMotorBike:YES];
    [self setIsInforInput:YES];
    [self setIsVehicle:YES];
    [self setIsInhibitLine:YES];
    [self setIsTakeOut:YES];
    [self setIsIllegalExposure:YES];
    [self setIsIllegal:YES];
    [self setIsThroughManage:YES];
}

- (void)closeLocation:(ParkType)type{
    
    if (type == ParkTypePark) {
        [[LocationStorage sharedDefault] setIsPark:NO];
    }else if (type == ParkTypeReversePark){
        [[LocationStorage sharedDefault] setIsTowardError:NO];
    }else if (type == ParkTypeLockPark){
        [[LocationStorage sharedDefault] setIsLockCar:NO];
    }else if (type == ParkTypeViolationLine){
        [[LocationStorage sharedDefault] setIsInhibitLine:NO];
    }else if (type == ParkTypeMotorbikeAdd){
        [[LocationStorage sharedDefault] setIsMotorBike:NO];
    }else if (type == ParkTypeCarInfoAdd){
        [[LocationStorage sharedDefault] setIsInforInput:NO];
    }else if (type == ParkTypeThrough){
        [[LocationStorage sharedDefault] setIsThrough:NO];
    }else if (type == ParkTypeThroughManage){
        [[LocationStorage sharedDefault] setIsThroughManage:NO];
    }
    
}

- (void)startLocation:(ParkType)type{
    
    if (type == ParkTypePark) {
        [[LocationStorage sharedDefault] setIsPark:YES];
    }else if (type == ParkTypeReversePark){
        [[LocationStorage sharedDefault] setIsTowardError:YES];
    }else if (type == ParkTypeLockPark){
        [[LocationStorage sharedDefault] setIsLockCar:YES];
    }else if (type == ParkTypeViolationLine){
        [[LocationStorage sharedDefault] setIsInhibitLine:YES];
    }else if (type == ParkTypeMotorbikeAdd){
        [[LocationStorage sharedDefault] setIsMotorBike:YES];
    }else if (type == ParkTypeCarInfoAdd){
        [[LocationStorage sharedDefault] setIsInforInput:YES];
    }else if (type == ParkTypeThrough){
        [[LocationStorage sharedDefault] setIsThrough:YES];
    }else if (type == ParkTypeThroughManage){
        [[LocationStorage sharedDefault] setIsThroughManage:YES];
    }
    
}


#pragma mark -
- (void)setIsPark:(BOOL)isPark{
    [[NSUserDefaults standardUserDefaults] setBool:isPark forKey:USERDEFAULT_KEY_ISPARK];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isPark{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISPARK];
    
}

#pragma mark -
- (void)setIsThrough:(BOOL)isThrough{
    [[NSUserDefaults standardUserDefaults] setBool:isThrough forKey:USERDEFAULT_KEY_ISTHROUGH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isThrough{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISTHROUGH];
    
}



#pragma mark -
- (void)setIsTowardError:(BOOL)isTowardError{
    [[NSUserDefaults standardUserDefaults] setBool:isTowardError forKey:USERDEFAULT_KEY_ISTOWARDERROR];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isTowardError{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISTOWARDERROR];
    
}




#pragma mark -
- (void)setIsLockCar:(BOOL)isLockCar{
    [[NSUserDefaults standardUserDefaults] setBool:isLockCar forKey:USERDEFAULT_KEY_ISLOCKCAR];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isLockCar{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISLOCKCAR];
    
}

#pragma mark -
- (void)setIsMotorBike:(BOOL)isMotorBike{
    [[NSUserDefaults standardUserDefaults] setBool:isMotorBike forKey:USERDEFAULT_KEY_ISMOTORBIKE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isMotorBike{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISMOTORBIKE];
}



#pragma mark -
- (void)setIsInforInput:(BOOL)isInforInput{
    [[NSUserDefaults standardUserDefaults] setBool:isInforInput forKey:USERDEFAULT_KEY_ISINFORINPUT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isInforInput{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISINFORINPUT];
    
}


#pragma mark -
- (void)setIsVehicle:(BOOL)isVehicle{
    [[NSUserDefaults standardUserDefaults] setBool:isVehicle forKey:USERDEFAULT_KEY_ISVEHICLE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isVehicle{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISVEHICLE];
    
}

- (void)setIsInhibitLine:(BOOL)isInhibitLine{
    [[NSUserDefaults standardUserDefaults] setBool:isInhibitLine forKey:USERDEFAULT_KEY_ISINHIBITLINE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isInhibitLine{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISINHIBITLINE];
    
}

- (void)setIsTakeOut:(BOOL)isTakeOut{
    [[NSUserDefaults standardUserDefaults] setBool:isTakeOut forKey:USERDEFAULT_KEY_ISTAKEOUT];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isTakeOut{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISTAKEOUT];
    
}

- (void)setIsIllegalExposure:(BOOL)isIllegalExposure{
    [[NSUserDefaults standardUserDefaults] setBool:isIllegalExposure forKey:USERDEFAULT_KEY_ISILLEGALEXPOSURE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isIllegalExposure{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISILLEGALEXPOSURE];
    
}

- (void)setIsIllegal:(BOOL)isIllegal{
    [[NSUserDefaults standardUserDefaults] setBool:isIllegal forKey:USERDEFAULT_KEY_ISILLEGAL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (BOOL)isIllegal{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISILLEGAL];
    
}

- (void)setIsThroughManage:(BOOL)isThroughManage{
    [[NSUserDefaults standardUserDefaults] setBool:isThroughManage forKey:USERDEFAULT_KEY_ISTHROUGHMANAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isThroughManage{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ISTHROUGHMANAGE];
    
}


#pragma mark -
- (void)setPark:(LocationStorageModel *)park{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:park];
    [userDefaults setObject:data forKey:USERDEFAULT_KEY_PARK];
    [userDefaults synchronize];
    
}

- (LocationStorageModel *)park{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:USERDEFAULT_KEY_PARK];
    LocationStorageModel *park = nil;
    if (data) {
        park = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return park;
    
}

#pragma mark -
- (void)setThrough:(LocationStorageModel *)through{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:through];
    [userDefaults setObject:data forKey:USERDEFAULT_KEY_THROUGH];
    [userDefaults synchronize];
    
    
}

- (LocationStorageModel *)through{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:USERDEFAULT_KEY_THROUGH];
    LocationStorageModel *through = nil;
    if (data) {
        through = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return through;
    
}


#pragma mark -
- (void)setTowardError:(LocationStorageModel *)towardError{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:towardError];
    [userDefaults setObject:data forKey:USERDEFAULT_KEY_TOWARDERROR];
    [userDefaults synchronize];
    
}

- (LocationStorageModel *)towardError{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:USERDEFAULT_KEY_TOWARDERROR];
    LocationStorageModel *towardError = nil;
    if (data) {
        towardError = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return towardError;
    
}


#pragma mark -
- (void)setLockCar:(LocationStorageModel *)lockCar{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:lockCar];
    [userDefaults setObject:data forKey:USERDEFAULT_KEY_LOCKCAR];
    [userDefaults synchronize];
    
}

- (LocationStorageModel *)lockCar{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:USERDEFAULT_KEY_LOCKCAR];
    LocationStorageModel *lockCar = nil;
    if (data) {
        lockCar = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return lockCar;
    
}

#pragma mark -
- (void)setMotorBike:(LocationStorageModel *)motorBike{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:motorBike];
    [userDefaults setObject:data forKey:USERDEFAULT_KEY_MOTORBIKE];
    [userDefaults synchronize];
    
}

- (LocationStorageModel *)motorBike{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:USERDEFAULT_KEY_MOTORBIKE];
    LocationStorageModel *motorBike = nil;
    if (data) {
        motorBike = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return motorBike;
    
}



#pragma mark -
- (void)setInforInput:(LocationStorageModel *)inforInput{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:inforInput];
    [userDefaults setObject:data forKey:USERDEFAULT_KEY_INFORINPUT];
    [userDefaults synchronize];
    
}

- (LocationStorageModel *)inforInput{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:USERDEFAULT_KEY_INFORINPUT];
    LocationStorageModel *inforInput = nil;
    if (data) {
        inforInput = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return inforInput;
    
}

#pragma mark -
- (void)setVehicle:(LocationStorageModel *)vehicle{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:vehicle];
    [userDefaults setObject:data forKey:USERDEFAULT_KEY_VEHICLE];
    [userDefaults synchronize];
    
}

- (LocationStorageModel *)vehicle{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:USERDEFAULT_KEY_VEHICLE];
    LocationStorageModel *vehicle = nil;
    if (data) {
        vehicle = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return vehicle;
    
}

#pragma mark -
- (void)setInhibitLine:(LocationStorageModel *)inhibitLine{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:inhibitLine];
    [userDefaults setObject:data forKey:USERDEFAULT_KEY_INHIBITLINE];
    [userDefaults synchronize];
    
}

- (LocationStorageModel *)inhibitLine{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:USERDEFAULT_KEY_INHIBITLINE];
    LocationStorageModel *inhibitLine = nil;
    if (data) {
        inhibitLine = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return inhibitLine;
    
}

#pragma mark -

- (void)setTakeOut:(LocationStorageModel *)takeOut{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:takeOut];
    [userDefaults setObject:data forKey:USERDEFAULT_KEY_TAKEOUT];
    [userDefaults synchronize];
    
}

- (LocationStorageModel *)takeOut{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:USERDEFAULT_KEY_TAKEOUT];
    LocationStorageModel *takeOut = nil;
    if (data) {
        takeOut = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return takeOut;
    
}


#pragma mark -

- (void)setIllegalExposure:(LocationStorageModel *)illegalExposure{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:illegalExposure];
    [userDefaults setObject:data forKey:USERDEFAULT_KEY_ILLEGALEXPOSURE];
    [userDefaults synchronize];
    
}

- (LocationStorageModel *)illegalExposure{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:USERDEFAULT_KEY_ILLEGALEXPOSURE];
    LocationStorageModel *illegalExposure = nil;
    if (data) {
        illegalExposure = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return illegalExposure;
    
}

#pragma mark -

- (void)setIllegal:(LocationStorageModel *)illegal{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:illegal];
    [userDefaults setObject:data forKey:USERDEFAULT_KEY_ILLEGAL];
    [userDefaults synchronize];
    
}

- (LocationStorageModel *)illegal{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:USERDEFAULT_KEY_ILLEGAL];
    LocationStorageModel *illegal = nil;
    if (data) {
        illegal = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return illegal;
    
}


#pragma mark -

- (void)setThroughManage:(LocationStorageModel *)throughManage{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:throughManage];
    [userDefaults setObject:data forKey:USERDEFAULT_KEY_THROUGHMANAGE];
    [userDefaults synchronize];
    
}

- (LocationStorageModel *)throughManage{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:USERDEFAULT_KEY_THROUGHMANAGE];
    LocationStorageModel *throughManage = nil;
    if (data) {
        throughManage = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return throughManage;
    
}



@end
