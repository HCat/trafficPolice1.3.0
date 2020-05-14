//
//  ActionAPI.m
//  移动采集
//
//  Created by hcat on 2018/8/1.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "ActionAPI.h"

#pragma mark - 获取行动分页列表API

@implementation ActionListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"actionId" : @"id",
             };
}

@end

@implementation ActionPageListParam

@end

@implementation ActionPageListReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [ActionListModel class]
             };
}

@end

@implementation ActionPageListManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ACTION_PAGELIST;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (ActionPageListReponse *)acctionReponse{
    
    if (self.responseModel.data) {
        _acctionReponse = [ActionPageListReponse modelWithDictionary:self.responseModel.data];
        return _acctionReponse;
    }
    
    return nil;
}

@end

#pragma mark - 行动详情

@implementation ActionPeopleModel

@end

@implementation ActionShowListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"peopleArr" : [ActionPeopleModel class],
             };
}

@end

@implementation ActionTaskListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"taskShowList" : [ActionShowListModel class],
             };
}

@end

@implementation ActionInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"actionId" : @"id",
             };
}

@end

@implementation ActionDetailReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"actionTaskList" : [ActionTaskListModel class],
             };
}

@end


@implementation ActionDetailManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ACTION_DETAIL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_actionId};
}

//返回参数
- (ActionDetailReponse *)acctionReponse{
    
    if (self.responseModel.data) {
        _acctionReponse =  [ActionDetailReponse modelWithDictionary:self.responseModel.data];
        return _acctionReponse;
        
    }
    
    return nil;
}


@end

#pragma mark - 更改行动状态


@implementation ActionChangeStatusManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ACTION_CHANGESTATUS;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_actionId,
             @"status":_status
             };
}

@end


#pragma mark - 根据类型选择行动

@implementation ActionGetTypeListParam

@end

@implementation ActionGetTypeListReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [ActionTaskListModel class]
             };
}

@end

@implementation ActionGetTypeListManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ACTION_TYPELIST;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (ActionGetTypeListReponse *)actionReponse{
    
    if (self.responseModel.data) {
        _actionReponse = [ActionGetTypeListReponse modelWithDictionary:self.responseModel.data];
        return _actionReponse;
    }
    
    return nil;
}

@end
