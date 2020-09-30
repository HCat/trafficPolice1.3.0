//
//  IllegalParkVC.h
//  trafficPolice
//
//  Created by hcat on 2017/5/31.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "HideTabSuperVC.h"

@interface IllegalParkVC : HideTabSuperVC

@property (nonatomic,assign) IllegalType illegalType; //违法类型

//如果是违停的状况，则又分为3种状态，选填，默认1:违停，1001:朝向错误，1002:锁车，1003:违反禁止 2001:信息录入
@property (nonatomic,assign) ParkType subType;

@end
