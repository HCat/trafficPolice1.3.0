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
@property(nonatomic,copy) NSString *str_search;
@property(nonatomic,assign) BOOL isHandle;       //用于判断是否是个人中心中的违停列表

@end
