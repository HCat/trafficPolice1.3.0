//
//  ShareFun.h
//  移动采集
//
//  Created by hcat-89 on 2017/7/17.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKTabBarController.h"

@interface ShareFun : NSObject

//手机号验证
+ (BOOL)validatePhoneNumber:(NSString *)phoneNumber;

//身份证验证
+ (BOOL)validateIDCardNumber:(NSString *)value;

//车牌号验证
+ (BOOL)validateCarNumber:(NSString *) carNumber;

//获取唯一标识符
+ (NSString *)getUniqueDeviceIdentifierAsString;

//高亮一段NSSting中的数字部分
+ (NSMutableAttributedString *)highlightNummerInString:(NSString *)originString;
+ (NSMutableAttributedString *)highlightInString:(NSString *)originString withSubString:(NSString *)subString;

//通过UIView获取UIViewController
+ (UIViewController *)findViewController:(UIView *)sourceView withClass:(Class)classVC;

//获取当前时间，格式是 yyyy-MM-dd HH:mm:ss
+ (NSString *)getCurrentTime;

//获取时间挫转换成时间：格式为yyyy-MM-dd HH:mm:ss
+ (NSString *)timeWithTimeInterval:(NSNumber *)timeString;

//获取时间戳转换成时间：格式为dateFormat
+ (NSString *)timeWithTimeInterval:(NSNumber *)timeString dateFormat:(NSString *)dateFormat;


//获取缓存目录
+ (NSString *)getCacheSubPath:(NSString *)dirName;

//单个文件的大小
+ (long long)fileSizeAtPath:(NSString *)filePath;

//遍历文件夹获得文件夹大小，返回多少M
+ (float)folderSizeAtPath:(NSString *)folderPath;

//注销需要执行的操作
+ (void)LoginOut;

//监测版本是否可以更新
+ (void)checkForVersionUpdates;

@end
