//
//  JointImageCell.h
//  移动采集
//
//  Created by hcat on 2017/11/30.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JointLawAPI.h"

@interface JointImageCell : UITableViewCell

@property (nonatomic,strong) NSMutableArray <JointLawImageModel *> *imageList;

@end
