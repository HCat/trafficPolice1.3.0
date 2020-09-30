//
//  AccidentRemarkListVC.h
//  移动采集
//
//  Created by hcat on 2017/8/14.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"

@interface AccidentRemarkListVC : HideTabSuperVC

@property (nonatomic,strong) NSNumber * accidentId;
@property (nonatomic,assign) BOOL isHandle; //此参数无多大作用，只是用于去一个背景色而已
@end
