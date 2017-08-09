//
//  AccidentDetailVC.h
//  trafficPolice
//
//  Created by hcat on 2017/6/8.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "HideTabSuperVC.h"

@interface AccidentDetailVC : HideTabSuperVC

@property (nonatomic,strong) NSNumber *accidentId;
@property (nonatomic,assign)AccidentType accidentType; //类型

@end
