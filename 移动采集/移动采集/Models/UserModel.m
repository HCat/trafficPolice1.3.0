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

+ (BOOL)isPermissionForThroughCollect{
    
    NSString *match = @"THROUGH_MANAGE";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

+ (BOOL)isPermissionForIllegalAdd{
    
    NSString *match = @"ILLEGAL_PARK_COLLECT";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}


+ (BOOL)isPermissionForExpressRegulation{
    
    NSString *match = @"LOGISTICS_MANAGE";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
    
}

+ (BOOL)isPermissionForExposure{
    
    NSString *match = @"ILLEGAL_EXPOSURE";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

+ (BOOL)isPermissionForStreet{
    
    NSString *match = @"STREETPARK_MANAGE";
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

#pragma mark - 获取违反禁止线权限
+ (BOOL)isPermissionForInhibitLine{
    NSString *match = @"ILLEGAL_INHIBIT_LINE";
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

#pragma mark - 获取摩托车违章权限

+ (BOOL)isPermissionForMotorBikeAdd{
    
    NSString *match = @"MOTOR_INFO_ADD";
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

#pragma mark - 违反禁止线列表权限

+ (BOOL)isPermissionForInhibitLineList{
    
    NSString *match = @"ILLEGAL_INHIBIT_LINE_LIST";
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

#pragma mark - 摩托车采集列表

+ (BOOL)isPermissionForMotorBikeList{
    
    NSString *match = @"MOTOR_INFO_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark - 违法曝光列表

+ (BOOL)isPermissionForExposureList{
    
    NSString *match = @"EXPOSURE_LIST";
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

#pragma mark - 特殊车辆权限

+ (BOOL)isPermissionForSpecialCar{
    
    NSString *match = @"SPECAIL_CAR_MANAGE";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark - 勤务管理
+ (BOOL)isPermissionForAttendance{
    NSString *match = @"POLICE_MANAGE";
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


#pragma mark - 获取行动管理权限
+ (BOOL)isPermissionForAcitonManage{
    NSString *match = @"ACTION_MANAGE";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
    
}
#pragma mark - 获取行动管理发布
+ (BOOL)isPermissionForAcitonPublish{
    NSString *match = @"ACTIONMANAGE06";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].userPrivileges filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
    
}
#pragma mark - 获取行动管理结束
+ (BOOL)isPermissionForAcitonEnd{
    NSString *match = @"ACTIONMANAGE08";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].userPrivileges filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
    
}

#pragma mark - 获取违章采集列表（石狮的）权限
+ (BOOL)isPermissionForIllegalAddList{
    
    NSString *match = @"ILLEGAL_PARK_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
    
}

#pragma mark - 获取闯进令管理列表（石狮的）权限
+ (BOOL)isPermissionForThroughCollectList{
    
    NSString *match = @"THROUGH_COLLECT_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}


+ (BOOL)isPermissionForStreetList{
    
    NSString *match = @"STREETPARK_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}



#pragma mark - 获取违章采集上报异常权限
+ (BOOL)isPermissionForIllegalReport{
    
    NSString *match = @"PARKING_REPORT";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;

}
+ (BOOL)isPermissionForThroughReport{
    
    NSString *match = @"THROUGH_REPORT";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
    
}
+ (BOOL)isPermissionForReverseParkingReport{
    
    NSString *match = @"REVERSE_REPORT";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
    
}
+ (BOOL)isPermissionForLockParkingReport{
    
    NSString *match = @"LOCK_REPORT";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
    
}
+ (BOOL)isPermissionForInhibitLineReport{
    
    NSString *match = @"INHIBIT_LINE_REPORT";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
    
}

+ (BOOL)isPermissionForMotorBikeAddReport{
    
    NSString *match = @"MOTOR_REPORT";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
    
}

+ (BOOL)isPermissionForThroughCollectReport{
    
    NSString *match = @"THROUGH_COLLECT_REPORT";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

+ (BOOL)isPermissionForStreetReport{
    
    NSString *match = @"STREETPARK_REPORT";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}



@end
