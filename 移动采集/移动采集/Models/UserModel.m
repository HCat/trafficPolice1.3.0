//
//  UserModel.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userId" : @"id",
             };
}


+ (void)setUserModel:(UserModel *)model{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [userDefaults setObject:data forKey:USERDEFAULT_KEY_USERMODEL];
    [userDefaults synchronize];
    
}

+ (UserModel *)getUserModel{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:USERDEFAULT_KEY_USERMODEL];
    UserModel *userModel = nil;
    if (data) {
        userModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return userModel;
}

#pragma mark - 获取事故录入权限

+ (BOOL)isPermissionForAccident{

    NSString *match = @"NORMAL_ACCIDENT_ADD";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;

}

#pragma mark - 获取快处录入权限

+ (BOOL)isPermissionForFastAccident{
    
    NSString *match = @"FAST_ACCIDENT_ADD";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark - 获取违停录入权限

+ (BOOL)isPermissionForIllegal{
    
    NSString *match = @"ILLEGAL_PARKING";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark - 获取闯禁令录入权限

+ (BOOL)isPermissionForThrough{
    
    NSString *match = @"ILLEGAL_THROUGH";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}


#pragma mark - 获取视频录入权限

+ (BOOL)isPermissionForVideoCollect{
    
    NSString *match = @"VIDEO_COLLECT";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark - 获取不按朝向采集权限

+ (BOOL)isPermissionForIllegalReverseParking{
    
    NSString *match = @"ILLEGAL_REVERSE_PARKING";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark - 获取违停锁车采集权限

+ (BOOL)isPermissionForLockParking{
    
    NSString *match = @"ILLEGAL_LOCK_PARKING";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark - 获取车辆录入权限

+ (BOOL)isPermissionForCarInfoAdd{
    
    NSString *match = @"CAR_INFO_ADD";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark - 获取重点车辆权限

+ (BOOL)isPermissionForImportantCar{
    
    NSString *match = @"IMPORTANT_CAR";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark - 获取勤务指挥权限

+ (BOOL)isPermissionForPoliceCommand{
    
    NSString *match = @"POLICE_COMMAND";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark - 获取路面实况权限

+ (BOOL)isPermissionForRoadInfo{
    
    NSString *match = @"ROAD_INFO";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}



#pragma mark - 获取事故权限列表

+ (BOOL)isPermissionForAccidentList{
    
    NSString *match = @"ACCIDENT_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 获取快处权限列表

+ (BOOL)isPermissionForFastAccidentList{
    
    NSString *match = @"FASTACC_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 获取违停权限列表

+ (BOOL)isPermissionForIllegalList{
    
    NSString *match = @"ILLEGAL_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark - 获取闯禁令权限列表

+ (BOOL)isPermissionForThroughList{
    
    NSString *match = @"THROUGH_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark - 获取警情权限列表

+ (BOOL)isPermissionForVideoCollectList{
    
    NSString *match = @"VIDEO_COLLECT_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark - 不按朝向列表权限

+ (BOOL)isPermissionForIllegalReverseList{
    
    NSString *match = @"ILLEGAL_REVERSE_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark - 违停锁车列表权限

+ (BOOL)isPermissionForIllegalLockList{
    
    NSString *match = @"ILLEGAL_LOCK_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark - 车辆列表权限

+ (BOOL)isPermissionForCarInfoList{
    
    NSString *match = @"CAR_INFO_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark - 获取联合执法权限

+ (BOOL)isPermissionForJointEnforcement{
    
    NSString *match = @"JOINT_LAW_ENFORCEMENT";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
    
    
}


#pragma mark - 获取事故结案权限

+ (BOOL)isPermissionForAccidentCase{
    
    NSString *match = @"accident-list-06";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].userPrivileges filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}



@end
