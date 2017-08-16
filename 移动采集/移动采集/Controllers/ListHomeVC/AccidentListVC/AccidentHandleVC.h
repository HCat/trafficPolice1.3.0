//
//  AccidentHandleVC.h
//  移动采集
//
//  Created by hcat on 2017/8/10.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"

@interface AccidentHandleVC : HideTabSuperVC

@property (nonatomic,strong) NSNumber *accidentId;      //事故ID
@property (nonatomic,assign) AccidentType accidentType; //事故类型或者快处类型
 

@end
