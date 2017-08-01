//
//  LRPlayVC.h
//  trafficPolice
//
//  Created by hcat on 2017/6/6.
//  Copyright © 2017年 Degal. All rights reserved.
//


#import "HideTabSuperVC.h"



@interface LRPlayVC : HideTabSuperVC

@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic,copy) void(^deleteBlock)();

@end
