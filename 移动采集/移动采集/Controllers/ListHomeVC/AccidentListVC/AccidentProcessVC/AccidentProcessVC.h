//
//  AccidentProcessVC.h
//  移动采集
//
//  Created by hcat on 2017/8/15.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "AccidentAPI.h"

@interface AccidentProcessVC : HideTabSuperVC

@property (nonatomic,assign) AccidentType accidentType;
@property (nonatomic,strong) AccidentSaveParam *param;

@end
