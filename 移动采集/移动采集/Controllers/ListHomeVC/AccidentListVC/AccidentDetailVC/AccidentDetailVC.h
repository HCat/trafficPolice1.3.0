//
//  AccidentDetailVC.h
//  trafficPolice
//
//  Created by hcat on 2017/6/8.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "RemarkModel.h"

@interface AccidentDetailVC : HideTabSuperVC

@property (nonatomic,strong) NSNumber * accidentId;
@property (nonatomic,strong) RemarkModel * remarkModel;   //备注
@property (nonatomic,assign) NSInteger remarkCount;    //备注数量
@property (nonatomic,assign) AccidentType accidentType;  //类型

@end
