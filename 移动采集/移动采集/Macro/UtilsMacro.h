//
//  UtilsMacro.h
//  项目框架
//
//  Created by Hcat on 14-3-17.
//  Copyright (c) 2014年 Hcat. All rights reserved.
//


#pragma mark -Redefine

#define ITUNESAPPID @"1252501276"

#define WS(__KEY)  __weak typeof(self)__KEY = self
#define SW(__SW,__WS)  __strong typeof(__WS)__SW = __WS

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)


#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

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

#define TICK   NSDate *startTime = [NSDate date];
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow]);


