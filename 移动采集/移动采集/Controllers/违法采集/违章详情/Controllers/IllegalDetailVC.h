//
//  IllegalDetailVC.h
//  trafficPolice
//
//  Created by hcat on 2017/6/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "HideTabSuperVC.h"


@interface IllegalDetailVC : HideTabSuperVC

//如果是违停的状况，则又分为3种状态，选填，默认1:违停，1001:朝向错误，1002:锁车，2001:信息录入
@property (nonatomic,assign) ParkType subType;
@property (nonatomic,strong) NSNumber *illegalId;
@property (nonatomic,assign) IllegalType illegalType;


@end
