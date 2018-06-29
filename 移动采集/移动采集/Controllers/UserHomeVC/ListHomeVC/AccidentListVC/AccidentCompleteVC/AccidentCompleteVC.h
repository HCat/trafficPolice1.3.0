//
//  AccidentCompleteVC.h
//  移动采集
//
//  Created by hcat on 2017/8/29.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"

@interface AccidentCompleteVC : HideTabSuperVC

@property (nonatomic,assign) AccidentType accidentType;
@property (nonatomic,strong) NSNumber *accidentId;      //事故ID

@end
