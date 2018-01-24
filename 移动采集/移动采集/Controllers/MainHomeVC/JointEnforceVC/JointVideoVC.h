//
//  JointVideoVC.h
//  移动采集
//
//  Created by hcat on 2018/1/19.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "JointLawAPI.h"

typedef void (^JointVideoVCComitDoneBlock)(JointLawVideoModel *video);

@interface JointVideoVC : HideTabSuperVC

@property (nonatomic,strong) NSString * oldVideoId;
@property (nonatomic,copy) JointVideoVCComitDoneBlock block;
@end
