//
//  TaskAPI.h
//  移动采集
//
//  Created by hcat on 2017/11/3.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "TaskModel.h"

#pragma mark - 获取当前任务

@interface TaskGetCurrentListManger:LRBaseRequest

/****** 请求数据 ******/


/****** 返回数据 ******/
@property (nonatomic,strong) TaskModel * task;

@end

#pragma mark - 获取历史任务

@interface TaskGetHistoryListParam : NSObject

@property (nonatomic,assign) NSInteger  start;   //开始的索引号 从0开始
@property (nonatomic,assign) NSInteger  length;  //显示的记录数 默认为10

@end


@interface TaskGetHistoryListReponse : NSObject

@property (nonatomic,copy) NSArray < TaskModel *> * list;    //包含IllegalParkListModel对象
@property (nonatomic,assign) NSInteger total;                           //总数

@end


@interface TaskGetHistoryListManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) TaskGetHistoryListParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) TaskGetHistoryListReponse * taskGetHistoryListReponse;

@end

#pragma mark - 任务详情

@interface TaskDetailModel : NSObject

@property (nonatomic, strong) NSNumber * taskId;        //任务id
@property (nonatomic,copy)    NSString * taskName;      //任务名称
@property (nonatomic,copy)    NSString * arrivalTime;   //到岗时间
@property (nonatomic,copy)    NSString * taskStatus;    //任务状态
@property (nonatomic,copy)    NSString * createTime;    //创建时间

@end

@interface ChildTaskDetailModel : NSObject

@property (nonatomic, strong) NSNumber * childTaskId;   //子任务id
@property (nonatomic,copy)    NSString * address;       //任务地址
@property (nonatomic,copy)    NSString * content;       //内容
@property (nonatomic,strong)  NSNumber * longitude;     //经度
@property (nonatomic,strong)  NSNumber * latitude;      //纬度

@end

@interface TaskGetDetailReponse :NSObject

@property (nonatomic,strong) TaskDetailModel * task;
@property (nonatomic,strong) ChildTaskDetailModel * childTask;

@end

@interface TaskDetailManger:LRBaseRequest

/****** 请求数据 ******/

/****** 返回数据 ******/
@property (nonatomic, strong) TaskGetDetailReponse * taskGetDetailReponse;

@end


