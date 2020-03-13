//
//  TaskFlowsDetailVC.h
//  移动采集
//
//  Created by hcat-89 on 2020/3/5.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "TaskFlowsDetailViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskFlowsDetailVC : HideTabSuperVC

- (instancetype)initWithViewModel:(TaskFlowsDetailViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
