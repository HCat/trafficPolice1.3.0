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
- (NSArray <DutyPeopleModel *> *)leaderList{
    
    if (self.responseModel) {
        
        _leaderList = [NSArray modelArrayWithClass:[DutyPeopleModel class] json:self.responseJSONObject[@"data"][@"leaderList"]];
        return _leaderList;
    }
    
    return nil;
}

//返回参数
- (NSArray <DutyPeopleModel *> *)policeList{
    
    if (self.responseModel) {
        
        _policeList = [NSArray modelArrayWithClass:[DutyPeopleModel class] json:self.responseJSONObject[@"data"][@"policeList"]];
        return _policeList;
    }
    
    return nil;
}


- (NSArray <DutyPeopleModel *> *)othersList{
    
    if (self.responseModel) {
        
        _othersList = [NSArray modelArrayWithClass:[DutyPeopleModel class] json:self.responseJSONObject[@"data"][@"othersList"]];
        return _othersList;
    }
    
    return nil;
}

@end





