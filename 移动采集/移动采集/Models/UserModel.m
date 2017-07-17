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


#pragma mark - 获取事故权限

+ (BOOL)isPermissionForAccidentList{
    
    NSString *match = @"ACCIDENT_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 获取快处权限

+ (BOOL)isPermissionForFastAccidentList{
    
    NSString *match = @"FASTACC_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 获取违停权限

+ (BOOL)isPermissionForIllegalList{
    
    NSString *match = @"ILLEGAL_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark - 获取闯禁令权限

+ (BOOL)isPermissionForThroughList{
    
    NSString *match = @"THROUGH_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}

#pragma mark - 获取警情权限

+ (BOOL)isPermissionForVideoCollectList{
    
    NSString *match = @"VIDEO_COLLECT_LIST";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@", match];
    NSArray *results = [[UserModel getUserModel].menus filteredArrayUsingPredicate:predicate];
    
    if (results && results.count > 0) {
        return YES;
    }
    
    return NO;
    
}




@end
