//
//  DutyAPI.m
//  移动采集
//
//  Created by hcat on 2017/10/25.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "DutyAPI.h"



@implementation DutyGetDutyByMonthManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_DUTY_GETDUTYBYMONTH;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"dateStr":_dateStr};;
}


//返回参数
- (NSArray <NSString *> *)dutyDay{
    
    if (self.responseModel) {
        
        _dutyDay = (NSArray *)self.responseJSONObject[@"data"][@"dutyDay"];
        return _dutyDay;
    }
    
    return nil;
}


- (NSArray <NSString *> *)leaderList{
    
    if (self.responseModel) {
        
        _leaderList = self.responseJSONObject[@"data"][@"leaderArr"];
        return _leaderList;
    }
    
    return nil;
}

@end


#pragma mark -

@implementation DutyPeopleModel

@end

@implementation DutyGetDutyByDayReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"leaderList" : [DutyPeopleModel class],
             @"policeList" : [DutyPeopleModel class],
             @"othersList" : [DutyPeopleModel class]
             };
}

@end

@implementation DutyGetDutyByDayManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_DUTY_GETDUTYBYDAY;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"dateStr":_dateStr};;
}

//返回参数

- (DutyGetDutyByDayReponse *)dutyGetDutyByDayReponse{
    
    if (self.responseModel.data) {
        _dutyGetDutyByDayReponse =  [DutyGetDutyByDayReponse modelWithDictionary:self.responseModel.data];
        return _dutyGetDutyByDayReponse;
    }
    
    return nil;
    
}



@end





