//
//  TaskFlowsAddViewModel.h
//  移动采集
//
//  Created by hcat-89 on 2020/3/9.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskFlowsAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskFlowsAddViewModel : NSObject

@property(nonatomic,copy) NSString * userId;              //警员编号 任务内容
@property(nonatomic,copy) NSString * content;               //任务内容
@property(nonatomic,copy) NSNumber * sendNotice;          //是   0否 1是
@property(nonatomic,assign) BOOL isCanCommit;               //是否可以上传
@property(nonatomic,strong) RACCommand * command_commint;


@end

NS_ASSUME_NONNULL_END
