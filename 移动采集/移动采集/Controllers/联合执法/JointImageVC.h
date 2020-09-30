//
//  JointImageVC.h
//  移动采集
//
//  Created by hcat on 2018/1/15.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "JointLawAPI.h"

typedef void (^JointImageVCComitDoneBlock)(NSArray <JointLawImageModel *> *imageList);

@interface JointImageVC : HideTabSuperVC

@property (nonatomic,copy) JointImageVCComitDoneBlock block;
@property (nonatomic,strong) NSArray * oldIds;

@end
