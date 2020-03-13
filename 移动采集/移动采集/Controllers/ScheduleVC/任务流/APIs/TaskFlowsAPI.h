//
//  TaskFlowsAPI.h
//  移动采集
//
//  Created by hcat-89 on 2020/3/3.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "TaskFlowsListModel.h"
#import "TaskFlowsReplyModel.h"

#pragma mark - 指派给我的任务API

@interface TaskFlowsAdviceTaskListParam : NSObject

@property (nonatomic,assign) NSInteger  start;   //开始的索引号 从0开始
@property (nonatomic,assign) NSInteger  length;  //显示的记录数 默认为10


@end


@interface TaskFlowsAdviceTaskListReponse : NSObject

@property (nonatomic,copy) NSArray < TaskFlowsListModel *> * list;    //包含IllegalParkListModel对象
@property (nonatomic,assign) NSInteger total;                           //总数

@end

@interface TaskFlowsAdviceTaskListManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) TaskFlowsAdviceTaskListParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) TaskFlowsAdviceTaskListReponse * result;

@end



#pragma mark - 我创建的任务API

@interface TaskFlowsSelfTaskListParam : NSObject

@property (nonatomic,assign) NSInteger  start;   //开始的索引号 从0开始
@property (nonatomic,assign) NSInteger  length;  //显示的记录数 默认为10

@end


@interface TaskFlowsSelfTaskListReponse : NSObject

@property (nonatomic,copy) NSArray < TaskFlowsListModel *> * list;    //包含IllegalParkListModel对象
@property (nonatomic,assign) NSInteger total;                           //总数

@end

@interface TaskFlowsSelfTaskListManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) TaskFlowsSelfTaskListParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) TaskFlowsSelfTaskListReponse * result;

@end


#pragma mark - 任务流详情

@interface TaskFlowsDetailReponse : NSObject

@property (nonatomic,strong) TaskFlowsListModel * taskDetail;    //任务详情
@property (nonatomic,copy) NSArray < TaskFlowsReplyModel *> * taskReplyList;    //回复记录
@property (nonatomic,copy) NSArray < NSString *> * pictureList;    //图片列表路径
@property (nonatomic,copy) NSString * voiceSource;    //声音资源路径


@end

@interface TaskFlowsDetailManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * taskFlowsId;

/****** 返回数据 ******/
@property (nonatomic, strong) TaskFlowsDetailReponse * result;

@end

#pragma mark - 创建任务

@interface TaskFlowSaveTaskParam : NSObject

@property(nonatomic,copy) NSString * userId;              //警员编号 任务内容
@property(nonatomic,copy) NSString * content;             //任务内容
@property(nonatomic,copy) NSNumber * sendNotice;          //是   0否 1是
@end

@interface TaskFlowSaveTaskManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) TaskFlowSaveTaskParam * param;


@end

#pragma mark - 转发任务

@interface TaskFlowReplyTaskParam : NSObject

@property(nonatomic,copy) NSString * replyContent;    //备注    是    String
@property(nonatomic,copy) NSString * receiveUserId; //警员编号    是    integer
@property(nonatomic,strong) NSNumber * sendNotice;    //是否语音通知    是    String  0否 1是
@property(nonatomic,strong) NSNumber * taskId;    //任务编号    是    String
@property(nonatomic,strong) NSNumber * replyType;    //转发类型    是    0转发回复  1 完成回复
@property(nonatomic,strong) NSNumber * replyStatus;    //审核状态        1待审核 2审核不通过  3审核通过

@end

@interface TaskFlowReplyTaskManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) TaskFlowReplyTaskParam * param;


@end



