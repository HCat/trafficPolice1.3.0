//
//  TaskFlowsAPI.m
//  移动采集
//
//  Created by hcat-89 on 2020/3/3.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "TaskFlowsAPI.h"

#pragma mark - 指派给我的任务API

@implementation TaskFlowsAdviceTaskListParam

@end

@implementation TaskFlowsAdviceTaskListReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [TaskFlowsListModel class]
             };
}

@end

@implementation TaskFlowsAdviceTaskListManger

- (NSString *)requestUrl{
    return URL_TASKFLOWS_TASKLIST;
}

- (nullable id)requestArgument{
    return self.param.modelToJSONObject;
}

- (TaskFlowsAdviceTaskListReponse *)result{
    
    if (self.responseModel.data) {
        return [TaskFlowsAdviceTaskListReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end


#pragma mark - 我创建的任务API

@implementation TaskFlowsSelfTaskListParam

@end

@implementation TaskFlowsSelfTaskListReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [TaskFlowsListModel class]
             };
}

@end

@implementation TaskFlowsSelfTaskListManger

- (NSString *)requestUrl{
    return URL_TASKFLOWS_SELFTASKLIST;
}


- (nullable id)requestArgument{
    return self.param.modelToJSONObject;
}


- (TaskFlowsAdviceTaskListReponse *)result{
    
    if (self.responseModel.data) {
        return [TaskFlowsAdviceTaskListReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end


#pragma mark - 任务流详情

@implementation TaskFlowsDetailReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"taskReplyList" : [TaskFlowsReplyModel class],
             @"pictureList" : [NSString class]
             };
}

@end

@implementation TaskFlowsDetailManger:LRBaseRequest


- (NSString *)requestUrl{

    return URL_TASKFLOWS_DETAIL;
}


//请求参数
- (nullable id)requestArgument{
    return @{@"id":_taskFlowsId};
}


- (TaskFlowsDetailReponse *)result{
    
    if (self.responseModel.data) {
        return [TaskFlowsDetailReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end


#pragma mark - 创建任务

@implementation TaskFlowSaveTaskParam

@end

@implementation TaskFlowSaveTaskManger

- (NSString *)requestUrl{
    return URL_TASKFLOWS_SAVETASK;
}


- (nullable id)requestArgument{
    return self.param.modelToJSONObject;
}

@end


#pragma mark - 转发任务

@implementation TaskFlowReplyTaskParam

@end

@implementation TaskFlowReplyTaskManger

- (NSString *)requestUrl{
    return URL_TASKFLOWS_REPLYTASK;
}


- (nullable id)requestArgument{
    return self.param.modelToJSONObject;
}

@end

