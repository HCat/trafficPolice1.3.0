//
//  ActionListCell.h
//  移动采集
//
//  Created by hcat on 2018/8/2.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionAPI.h"

@interface ActionListCell : UITableViewCell

@property (nonatomic,strong) ActionListModel * model;

- (void)getHeightforModel:(ActionListModel *)model;

@end
