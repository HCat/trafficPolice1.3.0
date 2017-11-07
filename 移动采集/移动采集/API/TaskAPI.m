//
//  TaskAPI.m
//  移动采集
//
//  Created by hcat on 2017/11/3.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "TaskAPI.h"

#pragma mark -

@implementation TaskGetCurrentListManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_TASK_CURRENTLIST;
}

//请求参数
- (nullable id)requestArgument
{
    return nil;
}

//返回参数

//返回参数
- (NSArray <TaskModel *> *)list{
    
    if (self.responseModel) {
        
        _list = [NSArray modelArrayWithClass:[TaskModel class] json:self.responseJSONObject[@"data"][@"list"]];
        return _list;
    }
    
    return nil;
}

@end

#pragma mark -

@implementation TaskGetHistoryListParam

@end

@implementation TaskGetHistoryListReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [TaskModel class]
             };
}

@end

@implementation TaskGetHistoryListManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_TASK_HISTORYLIST;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (TaskGetHistoryListReponse *)taskGetHistoryListReponse{
    
    if (self.responseModel.data) {
         _taskGetHistoryListReponse = [TaskGetHistoryListReponse modelWithDictionary:self.responseModel.data];
        return _taskGetHistoryListReponse;
    }
    
    return nil;
}

@end

#pragma mark -

@implementation TaskDetailManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_TASK_DETAIL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_taskId};
}

//返回参数
- (TaskModel *)task{
    
    if (self.responseModel.data) {
        _task = [TaskModel modelWithDictionary:self.responseModel.data];
        return _task;
    }
    
    return nil;
}

@end

