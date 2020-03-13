//
//  TaskFlowsListViewModels.h
//  移动采集
//
//  Created by hcat-89 on 2020/3/3.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskFlowsAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskFlowsListViewModels : NSObject

@property(strong, nonatomic)  NSNumber * start;
@property (nonatomic, strong) NSMutableArray * arr_content;
@property(nonatomic,strong) NSNumber * type;  // 1表示指派给我的  2表示我创建的

@property(nonatomic,strong) RACCommand * command_loadList;

@end

NS_ASSUME_NONNULL_END
