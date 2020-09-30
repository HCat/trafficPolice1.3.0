//
//  JointTextCell.h
//  移动采集
//
//  Created by hcat on 2017/11/30.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JointLawAPI.h"

typedef void(^JointTextCellBlock)(BOOL isCommit);
typedef void(^JointTextPenaltDoneBlock)(NSMutableArray * arr_penalties);

@interface JointTextCell : UITableViewCell

@property(nonatomic,strong) JointLawSaveParam *param;   //上传的参数
@property(nonatomic,copy) JointTextCellBlock block;
@property(nonatomic,copy) JointTextPenaltDoneBlock penaltDoneBlock;
@property (nonatomic,strong) NSMutableArray * arr_penalties;

@end
