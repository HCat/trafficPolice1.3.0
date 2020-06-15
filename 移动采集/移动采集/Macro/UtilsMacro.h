//
//  UtilsMacro.h
//  项目框架
//
//  Created by Hcat on 14-3-17.
//  Copyright (c) 2014年 Hcat. All rights reserved.
//


#pragma mark -Redefine

#define ITUNESAPPID @"1252501276"
#define BUNDID @"com.Degal.trafficPolice"

#define DefaultColor UIColorFromRGB(0x3396fc)
#define DefaultTextColor UIColorFromRGB(0x333333)

#define DefaultBGColor UIColorFromRGB(0xf0f4f5)
#define DefaultNavColor UIColorFromRGB(0x3396fc)

#define DefaultMenuSelectedColor UIColorFromRGB(0x3396fc)       //滑动选项选中颜色
#define DefaultMenuUnSelectedColor UIColorFromRGB(0x444444)     //滑动选项未选中颜色

#define DefaultBtnColor UIColorFromRGB(0x3396fc)
#define DefaultBtnNuableColor UIColorFromRGB(0xe6e6e6)

#define WS(__KEY)  __weak typeof(self)__KEY = self
#define SW(__SW,__WS)  __strong typeof(__WS)__SW = __WS

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define IS_IPHONE_4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone5系列
#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6系列
#define IS_IPHONE_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iphone6+系列
#define IS_IPHONE_6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)


#define IS_IPHONE_X_MORE (IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES)

#define Height_StatusBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 44.0 : 20.0)
#define Height_NavBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 88.0 : 64.0)
#define Height_TabBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 83.0 : 49.0)


#define ApplicationDelegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define NotificationCenter                  [NSNotificationCenter defaultCenter]
#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define SharedApplication                   [UIApplication sharedApplication]
#define Bundle                              [NSBundle mainBundle]
#define KDocumentPath                       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject]

#define MainScreen                          [UIScreen mainScreen]
#define ScreenRect                          [[UIScreen mainScreen] bounds]
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height

#define IOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]

#define TabBarHeight                        49.0f
#define NaviBarHeight                       44.0f
#define HeightFor3p5InchScreen              480.0f
#define HeightFor4InchScreen                568.0f
#define HeightFor4p7InchScreen              667.0f
#define HeightFor5p5InchScreen              736.0f


#define YOURSYSTEM_OR_LATER(yoursystem) [[[UIDevice currentDevice] systemVersion] compare:(yoursystem)] != NSOrderedAscending


#define RGB(r,g,b)             [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define RGBA(r,g,b,a)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//判断字符串是否为nil
#define NSStringIsValid(string) ((string) && ![string isKindOfClass:[NSNull class]] && (string).length>0)

#define NSDictionaryIsValid(dictionary) ((dictionary) && [(dictionary) isKindOfClass:[NSDictionary class]] && ![(dictionary) isEqual:[NSNull null]] && (dictionary).count)


//用于绘制一像素的线
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)


#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

//代码执行时间
#define TICK   NSDate *startTime = [NSDate date];
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow]);


