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
@property (nonatomic,copy) NSArray < TaskModel *> * list;    //包含IllegalParkListModel对象

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

@interface TaskDetailManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * taskId;   //子任务id

/****** 返回数据 ******/
@property (nonatomic,strong) TaskModel * task;

@end


