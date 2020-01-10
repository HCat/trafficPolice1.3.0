//
//  DailyPatrolAPI.m
//  移动采集
//
//  Created by hcat-89 on 2020/1/8.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "DailyPatrolAPI.h"

#pragma mark - 违法类型列表

@implementation DailyPatrolListManger

- (NSString *)requestUrl
{
    return URL_DAILYPATROL_LIST;
}

- (NSArray < DailyPatrolListModel *> *)list{
    
    if (self.responseModel) {
        _list = [NSArray modelArrayWithClass:[DailyPatrolListModel class] json:self.responseJSONObject[@"data"]];
        
        return _list;
    }
    
    return nil;
    
}

@end


#pragma mark - 巡逻路线详情

@implementation DailyPatrolDetailReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"patrolLocationList" : [DailyPatrolLocationModel class]
             };
}


@end

@implementation DailyPatrolDetailManger

- (NSString *)requestUrl
{
    return URL_DAILYPATRO_DETAIL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"patrolId":_partrolId,
             @"shiftId":_shiftId
            };
}


//返回参数
- (DailyPatrolDetailReponse *)reponseModel{
    
    if (self.responseModel.data) {
        return [DailyPatrolDetailReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}


@end


#pragma mark - 巡逻打卡

@implementation DailyPatrolSendSignParam

@end

@implementation DailyPatrolSendSignManger

- (NSString *)requestUrl
{
    return URL_DAILYPATRO_SENDSIGN;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}



@end


#pragma mark - 实时上报位置

@implementation DailyPatrolLocationReportParam


@end

@implementation DailyPatrolLocationReportManger:LRBaseRequest

- (NSString *)requestUrl
{
    return URL_DAILYPATRO_LOCATIONREPORT;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}


@end


@implementation DailyPatrolPointListManger


- (NSString *)requestUrl
{
    return URL_DAILYPATRO_POINTLIST;
}

- (nullable id)requestArgument
{
    return @{@"partrolId":_partrolId};
}

- (NSArray < DailyPatrolPointModel *> *)list{
    
    if (self.responseModel) {
        _list = [NSArray modelArrayWithClass:[DailyPatrolPointModel class] json:self.responseJSONObject[@"data"]];
        
        return _list;
    }
    
    return nil;
    
}


@end
