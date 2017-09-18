//
//  IllegalListVC.h
//  trafficPolice
//
//  Created by hcat on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "BaseViewController.h"

@interface IllegalListVC : BaseViewController

@property (nonatomic,assign) IllegalType illegalType; //违法类型
//如果是违停的状况，则又分为3种状态，选填，默认1:违停，1001:朝向错误，1002:锁车，2001:信息录入
@property (nonatomic,assign) ParkType subType;
@property(nonatomic,copy) NSString *str_search;
@property(nonatomic,assign) BOOL isHandle;       //用于判断是否是个人中心中的违停列表

@end
