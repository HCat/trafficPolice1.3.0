//
//  TaskFlowsDetailViewModel.h
//  移动采集
//
//  Created by hcat-89 on 2020/3/5.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskFlowsAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskFlowsDetailViewModel : NSObject

@property (nonatomic, strong) NSNumber * taskFlowsId;               //任务流编号

@property(nonatomic,strong) NSNumber * taskFlowsType;  // 1表示指派给我的  2表示我创建的
@property (nonatomic, strong)   NSNumber * taskFlowsStatus;      //任务状态    String

@property (nonatomic, strong) NSMutableArray * arr_replys;          //别人转发或者回复


@property (nonatomic, strong, nullable) TaskFlowsReplyModel * my_taskReply;   //我的处理结果


@property(nonatomic,strong) RACCommand * command_loadDetail;    //请求任务流详情

@property(nonatomic,strong) TaskFlowsDetailReponse * result;


@end

NS_ASSUME_NONNULL_END
