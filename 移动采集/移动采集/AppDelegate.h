//
//  AppDelegate.h
//  移动采集
//
//  Created by hcat on 2017/7/17.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
//第三方平台
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <JANALYTICSService.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>

#endif

#import "MainVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainVC * mainvc;
@property (strong, nonatomic) UINavigationController * nav_main;

@end

