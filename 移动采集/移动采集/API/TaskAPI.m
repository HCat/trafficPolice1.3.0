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

- (TaskModel *)task{
    
    if (self.responseModel.data) {
        _task =  [TaskModel modelWithDictionary:self.responseModel.data[@"task"]];
        return _task;
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

@implementation TaskDetailModel

@end

@implementation ChildTaskDetailModel


@end

@implementation TaskGetDetailReponse


@end


@implementation TaskDetailManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_TASK_DETAIL;
}

//请求参数
- (nullable id)requestArgument
{
    return nil;
}

//返回参数
- (TaskGetDetailReponse *)taskGetDetailReponse{
    
    if (self.responseModel.data) {
        _taskGetDetailReponse = [TaskGetDetailReponse modelWithDictionary:self.responseModel.data];
        return _taskGetDetailReponse;
    }
    
    return nil;
}

@end

