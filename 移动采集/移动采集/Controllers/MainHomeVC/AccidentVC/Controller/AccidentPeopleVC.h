//
//  AccidentPeopleVC.h
//  移动采集
//
//  Created by hcat on 2018/7/20.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "AccidentUpFactory.h"

@interface AccidentPeopleVC : HideTabSuperVC

@property (nonatomic,assign) AccidentType accidentType;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) AccidentPeopleMapModel * model;

@property (nonatomic,assign) NSInteger arrayCount;

@end
