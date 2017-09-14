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
#import "NetWorkHelper.h"


#import "LoginHomeVC.h"
#import "MainHomeVC.h"
#import "ListHomeVC.h"
#import "MessageHomeVC.h"
#import "UserHomeVC.h"

#import "UserModel.h"


@interface AppDelegate ()

@property (nonatomic, strong) AVAudioPlayer *player;

@end

BMKMapManager* _mapManager;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self commonConfig];
    [self addThirthPart:launchOptions];
    [[LocationHelper sharedDefault] setLocationType:LocationTypeGaode];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = DefaultBGColor;
    
    LxPrintf(@"%@",[ShareValue sharedDefault].token);
    if ([ShareValue sharedDefault].token) {
        
        [ShareFun openWebSocket];
        LxPrintf(@"%@",[UserModel getUserModel].userId);
        [JPUSHService setAlias:[UserModel getUserModel].userId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        } seq:0];
        [LRBaseRequest setupRequestFilters:@{@"token": [ShareValue sharedDefault].token}];
        
        [self initAKTabBarController];
        self.window.rootViewController = self.vc_tabBar;
        
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
    
    //设置导航栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:DefaultNavColor];
    [UINavigationBar appearance].titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8 && [UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [UINavigationBar appearance].translucent = NO;
    }
    
    [[NetWorkHelper sharedDefault] startNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReconnection) name:NOTIFICATION_HAVENETWORK_SUCCESS object:nil];
    
    //配置统一的网络基地址
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = Base_URL;
    
}

#pragma mark - 第三方SDK接入

-(void)addThirthPart:(NSDictionary *)launchOptions{
    
    
    [WXApi registerApp:WEIXIN_APP_ID];
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    
    /**
     *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        LxPrintf(@"经纬度类型设置成功");
    } else {
        LxPrintf(@"经纬度类型设置失败");
    }
    
    BOOL ret = [_mapManager start:BAIDUMAP_APP_KEY generalDelegate:self];
    if (!ret) {
        LxPrintf(@"manager start failed!");
    }
    
    //百度地图初始化
    
    [AMapServices sharedServices].apiKey = AMAP_APP_KEY;
    
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_APP_KEY
                          channel:JPUSH_APP_CHANNEL
                 apsForProduction:JPUSH_PRODUCTION
            advertisingIdentifier:nil];
    
}

#pragma mark - 初始化Tabbar

-(void)initAKTabBarController{
    
    if (_vc_tabBar == nil) {
        
        self.vc_tabBar = [[AKTabBarController alloc]initWithTabBarHeight:50];
        [_vc_tabBar setTabTitleIsHidden:NO];
        [_vc_tabBar setTabEdgeColor:[UIColor clearColor]];
        [_vc_tabBar setIconGlossyIsHidden:YES];
        [_vc_tabBar setIconShadowOffset:CGSizeZero];
        [_vc_tabBar setTabColors:@[[UIColor clearColor],[UIColor clearColor]]];
        [_vc_tabBar setSelectedTabColors:@[[UIColor clearColor],[UIColor clearColor]]];
        [_vc_tabBar setBackgroundImageName:@"tabbar_bg"];
        [_vc_tabBar setSelectedBackgroundImageName:@"tabbar_bg"];
        [_vc_tabBar setTextColor:UIColorFromRGB(0xb5bdd2)];
        [_vc_tabBar setSelectedTextColor:UIColorFromRGB(0x253254)];
        [_vc_tabBar setTabStrokeColor:[UIColor clearColor]];
        [_vc_tabBar setTabInnerStrokeColor:[UIColor clearColor]];
        [_vc_tabBar setMinimumHeightToDisplayTitle:50];
        [_vc_tabBar setTextFont:[UIFont systemFontOfSize:11.f]];
        [_vc_tabBar setTopEdgeColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
        
        MainHomeVC *t_vc_main = [MainHomeVC new];
        UINavigationController *t_nav_main = [[UINavigationController alloc] initWithRootViewController:t_vc_main];
        
        ListHomeVC *t_vc_list = [ListHomeVC new];
        UINavigationController *t_nav_list = [[UINavigationController alloc] initWithRootViewController:t_vc_list];
        
        MessageHomeVC *t_vc_message = [MessageHomeVC new];
        UINavigationController *t_nav_message = [[UINavigationController alloc] initWithRootViewController:t_vc_message];
        
        UserHomeVC *t_vc_user = [UserHomeVC new];
        UINavigationController *t_nav_user = [[UINavigationController alloc] initWithRootViewController:t_vc_user];
        
        [_vc_tabBar setViewControllers:[@[t_nav_main,t_nav_list,t_nav_message,t_nav_user]mutableCopy]];
        
    }
    
}

#pragma mark - 网络改变监听

- (void)networkReconnection{
    
    BOOL ret = [_mapManager start:BAIDUMAP_APP_KEY generalDelegate:self];
    if (!ret) {
        LxPrintf(@"manager start failed!");
    }
    [[LocationHelper sharedDefault] startLocation];

}

#pragma mark - 屏幕旋转

//此方法会在设备横竖屏变化的时候调用
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
   return UIInterfaceOrientationMaskPortrait;
    
}


// 返回是否支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return NO;
}


#pragma mark - 微信相关

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    /*! @brief 处理微信通过URL启动App时传递的数据
     *
     * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
     * @param url 微信启动第三方应用时传递过来的URL
     * @param delegate  WXApiDelegate对象，用来接收微信触发的消息。
     * @return 成功返回YES，失败返回NO。
     */
    
    return [WXApi handleOpenURL:url delegate:self];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];
}

/*! 微信回调，不管是登录还是分享成功与否，都是走这个方法 @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp{
    
    /*
     enum  WXErrCode {
     WXSuccess           = 0,    成功
     WXErrCodeCommon     = -1,  普通错误类型
     WXErrCodeUserCancel = -2,    用户点击取消并返回
     WXErrCodeSentFail   = -3,   发送失败
     WXErrCodeAuthDeny   = -4,    授权失败
     WXErrCodeUnsupport  = -5,   微信不支持
     };
     */
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        
        SendAuthResp* SendRsp = (SendAuthResp*)resp;
        int nErrCode = SendRsp.errCode;
        NSString* strState = SendRsp.state;
        LxDBAnyVar(nErrCode);
        
        if (0 == nErrCode) {  //成功。
            if ([@"wxlogin" isEqualToString:strState]) {
                NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:SendRsp.code, @"code", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WX_LOGIN_SUCCESS object:nil userInfo:dict];
                
            }
        }else{ //失败
            LxPrintf(@"error %@",resp.errStr);
            if (!resp.errStr) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"登录失败，授权被取消" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:[NSString stringWithFormat:@"reason : %@",resp.errStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                
            }
        }
    }
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
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        NSDictionary *aps = [userInfo objectForKey:@"aps"];
        NSString *sound = [aps objectForKey:@"sound"];
        
        if ([sound containsString:@"police"]) {
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"police" ofType:@"m4a"];
            self.player = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:path] error:nil];
            self.player.numberOfLoops = 1000;
            self.player.volume = 1.0;
            [self.player play];
        }
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WILLPRESENTNOTIFICATION object:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RECEIVENOTIFICATION_SUCCESS object:userInfo];
        
        NSDictionary *aps = [userInfo objectForKey:@"aps"];
        NSString *sound = [aps objectForKey:@"sound"];
        
        if ([sound containsString:@"police"]) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"police" ofType:@"m4a"];
            self.player = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:path] error:nil];
            self.player.numberOfLoops = 1000;
            self.player.volume = 1.0;
            [self.player play];
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
