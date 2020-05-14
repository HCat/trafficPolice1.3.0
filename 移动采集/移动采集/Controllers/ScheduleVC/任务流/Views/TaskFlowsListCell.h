//
//  TaskFlowsListCell.h
//  移动采集
//
//  Created by hcat-89 on 2020/3/4.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskFlowsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskFlowsListCell : UITableViewCell

@property(nonatomic,strong)TaskFlowsListModel * viewModel;

@end

NS_ASSUME_NONNULL_END
