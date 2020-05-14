//
//  PoliceLocationVC.h
//  移动采集
//
//  Created by hcat on 2017/9/13.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"

typedef void(^PoliceLocationVCBlock)(NSNumber *lat,NSNumber *lon,NSNumber *range);


@interface PoliceLocationVC : HideTabSuperVC

@property (nonatomic,copy) PoliceLocationVCBlock block;

@end
