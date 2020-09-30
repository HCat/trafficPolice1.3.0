//
//  AppDelegate.m
//  移动采集
//
//  Created by hcat on 2017/7/17.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <YTKNetwork.h>
#import "LSStatusBarHUD.h"

#import "LRBaseRequest.h"
#import "LAJIBaseRequest.h"
#import "NetWorkHelper.h"

#import "LoginHomeVC.h"

#import "UserModel.h"

#import "IdentifyAPI.h"
#import "MessageDetailVC.h"
#import "IllegalOperatCarVC.h"
#import "ParkingForensicsListVC.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self commonConfig];
    [self addThirthPart:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    if ([ShareValue sharedDefault].token) {
        
        [ShareFun LoginInbeforeDone];
        [JPUSHService setAlias:[UserModel getUserModel].userId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        } seq:0];
        [LRBaseRequest setupRequestFilters:@{@"token": [ShareValue sharedDefault].token}];
        //[LAJIBaseRequest setupRequestFilters:@{@"token": [ShareValue sharedDefault].token}];
        
        self.mainvc = [[MainVC alloc] init];
        self.nav_main = [[UINavigationController alloc] initWithRootViewController:self.mainvc];
        self.window.rootViewController = self.nav_main;
        [self.window makeKeyAndVisible];
        
    }else{
        
        LoginHomeVC *vc_login = [LoginHomeVC new];
        UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:vc_login];
        self.window.rootViewController = t_nav;
        
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - 通用配置

-(void)commonConfig{
    
    //开启网络监听通知
    [[NetWorkHelper sharedDefault] startNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReconnection) name:NOTIFICATION_HAVENETWORK_SUCCESS object:nil];

    
    //添加点击消息通知时候弹出具体详情
    @weakify(self);
    [RACObserve([ShareValue sharedDefault], makeNumber) subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        
        if ([x integerValue] > 0) {
            self.mainvc.lb_message.text = [NSString stringWithFormat:@"%ld",[x integerValue]];
            self.mainvc.lb_message.hidden = NO;
        }else{
            
            self.mainvc.lb_message.text = @"";
            self.mainvc.lb_message.hidden = YES;
        }
        
        
    }];
    
    //同步通知消息数目
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationSuccess:) name:NOTIFICATION_RECEIVENOTIFICATION_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makesureNotification:) name:NOTIFICATION_MAKESURENOTIFICATION_SUCCESS object:nil];
    
    //配置统一的网络基地址
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = Base_URL;
    //请求是否强更
    [ShareFun checkForceForVersionUpdates];
    
}

#pragma mark - 第三方SDK接入

-(void)addThirthPart:(NSDictionary *)launchOptions{
    
    [AMapServices sharedServices].apiKey = AMAP_APP_KEY;
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:(id<JPUSHRegisterDelegate>)self];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_APP_KEY
                          channel:JPUSH_APP_CHANNEL
                 apsForProduction:JPUSH_PRODUCTION
            advertisingIdentifier:nil];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidLoginMessage:) name:kJPFNetworkDidLoginNotification object:nil];
    
    
    JANALYTICSLaunchConfig * config = [[JANALYTICSLaunchConfig alloc] init];
    config.appKey = JPUSH_APP_KEY;
    config.channel = JPUSH_APP_CHANNEL;
    [JANALYTICSService setupWithConfig:config];
    
}


#pragma mark - 网络改变监听

- (void)networkReconnection{

    [[LocationHelper sharedDefault] startLocation];

}

#pragma mark - 屏幕旋转

//此方法会在设备横竖屏变化的时候调用
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
   return UIInterfaceOrientationMaskPortrait;
    
}


// 返回是否支持设备自动旋转
- (BOOL)shouldAutorotate{
    return NO;
}

#pragma mark - jpush相关

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    
    LxPrintf(@"***************** 前台接收到消息 *****************");
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        
        NSDictionary *aps = [userInfo objectForKey:@"aps"];
        NSString *sound = [aps objectForKey:@"sound"];
        NSNumber *badge =   [aps objectForKey:@"badge"];
        
        NSString *type = [userInfo objectForKey:@"type"];
        if ([type isEqualToString:@"100"] || [type isEqualToString:@"101"]) {
            
            NSDictionary *apsd = aps;
            
            if ([type isEqualToString:@"100"]) {
                [ShareValue sharedDefault].dutyTip = YES;
            }
            
            if ([type isEqualToString:@"101"]) {
                [ShareValue sharedDefault].actionTip = YES;
            }
            
            if ([type isEqualToString:@"100"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RECEIVENOTIFICATION_DUTY object:apsd];
            }
            
            if ([type isEqualToString:@"101"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RECEIVENOTIFICATION_ACTION object:apsd];
            }
            
        }else{
            
            [ShareValue sharedDefault].makeNumber = [badge integerValue];
            
        }
        

        if ([sound containsString:@"police"]) {
            
            if (self.player) {
                [self.player stop];
                self.player = nil;
            }
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"police" ofType:@"m4a"];
            NSError *err=nil;
            self.player = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:path] error:&err];
            self.player.numberOfLoops = 1000;
            self.player.volume = 1.0;
            [self.player prepareToPlay];
            if (err!=nil) {
                NSLog(@"move player init error:%@",err);
            }else {
                [self.player play];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WILLPRESENTNOTIFICATION object:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    
    LxPrintf(@"***************** 点击接收到消息框 *****************");
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RECEIVENOTIFICATION_SUCCESS object:userInfo];
        
        NSDictionary *aps = [userInfo objectForKey:@"aps"];
        NSString *sound = [aps objectForKey:@"sound"];
        
        if ([sound containsString:@"police"]) {
            
            if (self.player) {
                [self.player stop];
                self.player = nil;
            }
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"police" ofType:@"m4a"];
            NSError *err=nil;
            self.player = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:path] error:nil];
            self.player.numberOfLoops = 1000;
            self.player.volume = 1.0;
            [self.player prepareToPlay];
            if (err!=nil) {
                NSLog(@"move player init error:%@",err);
            }else {
                [self.player play];
            }
           
        }
    
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

#pragma mark - notification

- (void)receiveNotificationSuccess:(NSNotification *)notication{
    NSDictionary * userInfo = notication.object;
    if (userInfo) {
        NSNumber *msgId = [userInfo objectForKey:@"id"];
        NSString *type = [userInfo objectForKey:@"type"];
        
        if ([type isEqualToString:@"100"] || [type isEqualToString:@"101"]) {

            if ([type isEqualToString:@"100"]) {
                [ShareValue sharedDefault].dutyTip = NO;
                
            }
            
            if ([type isEqualToString:@"101"]) {
                [ShareValue sharedDefault].actionTip = NO;
                
            }
            
    
        }else if([type isEqualToString:@"103"]){
            
            if (msgId) {
                
                IdentifySetMsgReadManger *manger = [[IdentifySetMsgReadManger alloc] init];
                manger.msgId = msgId;
                           
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                               
                    if (manger.responseModel.code == CODE_SUCCESS) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MAKESURENOTIFICATION_SUCCESS object:nil];
                    }
                               
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                               
                           
                }];
                
            }
            
            @weakify(self);
            ParkingForensicsListViewModel * viewModel = [[ParkingForensicsListViewModel alloc] init];
                
            [viewModel.command_isRegister.executionSignals.switchToLatest subscribeNext:^(id _Nullable x) {
                @strongify(self);
                    
                if ([x isKindOfClass:[NSNumber class]]) {
                        
                    if ([x intValue] == 0 || [x intValue] == 2) {
                        [ShareFun showTipLable:@"您暂无权限使用本功能"];
                    }else {
                        ParkingForensicsListVC *t_vc = [[ParkingForensicsListVC alloc] initWithViewModel:viewModel];
                        UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:t_vc];
                        [self.mainvc presentViewController:t_nav animated:YES completion:^{
                        }];
                    }
                        
                }else{
                    [ShareFun showTipLable:@"未知错误,技术人员正在修复,请稍后再试."];
                }
                    
            }];
                
            [viewModel.command_isRegister execute:nil];
                
        }else{
            
            if (msgId) {
                IdentifyMsgDetailManger *manger = [[IdentifyMsgDetailManger alloc] init];
                manger.msgId =msgId;
                [manger configLoadingTitle:@"请求"];
                
                WS(weakSelf);
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        if ([manger.identifyModel.type isEqualToNumber:@4]) {
                            
                            IllegalOperatCarVC *t_vc = [[IllegalOperatCarVC alloc] init];
                            manger.identifyModel.source = @1;
                            t_vc.model = manger.identifyModel;
                            UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:t_vc];
                            [weakSelf.mainvc presentViewController:t_nav animated:YES completion:^{
                            }];
                            
                        }else{
                            
                            MessageDetailVC *t_vc = [[MessageDetailVC alloc] init];
                            manger.identifyModel.source = @1;
                            t_vc.model = manger.identifyModel;
                            UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:t_vc];
                            [weakSelf.mainvc presentViewController:t_nav animated:YES completion:^{
                            }];
                            
                        }
                        
                    }
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                }];
                
                
            }
            
        }
  
    }
}

- (void)makesureNotification:(NSNotification *)notication{
    
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }


}

//通知方法
- (void)networkDidLoginMessage:(NSNotification *)notification {
    
    //调用接口
    NSLog(@"\n\n极光推送注册成功\n\n");
    
    //注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJPFNetworkDidLoginNotification object:nil];
    
}


#pragma mark -

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [ShareValue sharedDefault].makeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {

    [[LocationHelper sharedDefault] stopLocation];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
