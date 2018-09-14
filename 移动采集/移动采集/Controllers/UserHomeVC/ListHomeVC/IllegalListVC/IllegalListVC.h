//
//  IllegalListVC.h
//  trafficPolice
//
//  Created by hcat on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "HideTabSuperVC.h"

@interface IllegalListVC : HideTabSuperVC

@property (nonatomic,assign) IllegalType illegalType; //违法类型
//如果是违停的状况，则又分为3种状态，选填，默认1:违停，1001:朝向错误，1002:锁车，2001:信息录入
@property (nonatomic,assign) ParkType subType;

@property(nonatomic,assign) int type; // 1表示正常列表页面  2表示搜索列表页面

@end
