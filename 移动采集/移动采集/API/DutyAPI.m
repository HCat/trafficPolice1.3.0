//
//  DutyAPI.m
//  移动采集
//
//  Created by hcat on 2017/10/25.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "DutyAPI.h"

@implementation DutyMonthModel

@end

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
- (NSArray <DutyMonthModel *> *)monthReponse{
    
    if (self.responseModel) {
        
        _monthReponse = [NSArray modelArrayWithClass:[DutyMonthModel class] json:self.responseJSONObject[@"data"]];
        return _monthReponse;
    }
    
    return nil;

}

@end


#pragma mark -

@implementation DutyPeopleModel

@end

@implementation DutyGroupModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"helpList" : [DutyPeopleModel class],
             @"policeList" : [DutyPeopleModel class]
             };
}

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

#pragma mark - 按天获取排班详情(分组)

@implementation DutyGetWorkByDayReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"leaderList" : [DutyPeopleModel class],
             @"helpTeam" : [DutyGroupModel class],
             @"policeTeam" : [DutyGroupModel class]
             };
}

@end

@implementation DutyGetWorkByDayManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_DUTY_GETWORKBYDAY;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"dateStr":_dateStr};;
}

//返回参数

- (DutyGetWorkByDayReponse *)workReponse{
    
    if (self.responseModel.data) {
        _workReponse =  [DutyGetWorkByDayReponse modelWithDictionary:self.responseModel.data];
        return _workReponse;
    }
    
    return nil;
    
}

@end



