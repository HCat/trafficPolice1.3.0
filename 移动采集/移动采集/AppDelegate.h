//
//  AppDelegate.h
//  移动采集
//
//  Created by hcat on 2017/7/17.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

//第三方平台
#import <WXApi.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "AKTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,BMKGeneralDelegate,JPUSHRegisterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AKTabBarController *vc_tabBar;

@property (nonatomic,assign)NSInteger allowRotate; //进行横竖屏的切换用的

-(void)initAKTabBarController;


@end

