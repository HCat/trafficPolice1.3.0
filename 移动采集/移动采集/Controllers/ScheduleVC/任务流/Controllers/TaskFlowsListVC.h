//
//  TaskFlowsListVC.h
//  移动采集
//
//  Created by hcat-89 on 2020/3/3.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "TaskFlowsListViewModels.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskFlowsListVC : UIViewController

- (instancetype)initWithViewModel:(TaskFlowsListViewModels *)viewModel;

@end

NS_ASSUME_NONNULL_END
