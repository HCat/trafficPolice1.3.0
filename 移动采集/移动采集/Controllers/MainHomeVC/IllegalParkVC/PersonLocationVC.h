//
//  PersonLocationVC.h
//  移动采集
//
//  Created by hcat on 2017/10/31.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"

typedef void(^PersonLocationVCBlock)(LocationStorageModel *model);

@interface PersonLocationVC : HideTabSuperVC

@property (nonatomic,copy) PersonLocationVCBlock block;


@end
