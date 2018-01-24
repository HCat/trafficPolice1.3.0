//
//  JointPenaltiesVC.h
//  移动采集
//
//  Created by hcat on 2018/1/22.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"

typedef void(^JointPenaltiesVCBlock)(NSArray *arr_penalties);

@interface JointPenaltiesVC : HideTabSuperVC

@property(nonatomic,strong) NSArray *arr_penalts;
@property(nonatomic,copy) JointPenaltiesVCBlock block;


@end
