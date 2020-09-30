//
//  JointVideoCell.h
//  移动采集
//
//  Created by hcat on 2017/11/30.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JointLawAPI.h"

typedef void (^JointVideoCellBlock)(JointLawVideoModel *video);

@interface JointVideoCell : UITableViewCell

@property (nonatomic,strong) JointLawVideoModel * videoModel;
@property (nonatomic,copy) JointVideoCellBlock block;

@end
