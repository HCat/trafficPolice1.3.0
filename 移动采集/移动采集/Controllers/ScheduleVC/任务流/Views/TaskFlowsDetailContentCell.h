//
//  TaskFlowsDetailContentCell.h
//  移动采集
//
//  Created by hcat-89 on 2020/3/5.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskFlowsAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskFlowsDetailContentCell : UITableViewCell

@property(nonatomic,strong) TaskFlowsDetailReponse * result;

@end

NS_ASSUME_NONNULL_END
