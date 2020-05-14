//
//  AccidentCompleteVC.h
//  移动采集
//
//  Created by hcat on 2017/8/29.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "AccidentListModel.h"

@interface AccidentCompleteVC : HideTabSuperVC

@property (nonatomic,assign) AccidentType accidentType;
@property (nonatomic,strong) NSNumber *accidentId;        //事故ID
@property (nonatomic,strong) AccidentListModel * state; // 快处 ("未认定",0),("已认定",9),("未审核",11),("有疑义",12),

@end
