//
//  AccidentListVC.h
//  trafficPolice
//
//  Created by hcat on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "HideTabSuperVC.h"

@interface AccidentListVC : HideTabSuperVC

@property(nonatomic,assign) AccidentType accidentType;

@property(nonatomic,assign) int type; // 1表示正常列表页面  2表示搜索列表页面

@end
