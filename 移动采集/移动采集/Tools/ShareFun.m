//
//  ShareFun.m
//  移动采集
//
//  Created by hcat-89 on 2017/7/17.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "ShareFun.h"

#import "SAMKeychain.h"
#import "SAMKeychainQuery.h"
#import "HSUpdateApp.h"
#import "SRAlertView.h"
#import "SuperLogger.h"

#import "UserModel.h"
#import "LoginHomeVC.h"
#import "LRBaseRequest.h"

#import "UserModel.h"
#import "WebSocketHelper.h"
#import "SocketModel.h"
#import "CommonAPI.h"
#import <CoreGraphics/CoreGraphics.h>


@implementation ShareFun

#pragma mark - 手机号验证

+ (BOOL)validatePhoneNumber:(NSString *)phoneNumber{
    
    NSString  *phoneNum=@"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNum];
    return [numberPre evaluateWithObject:phoneNumber substitutionVariables:nil];
    
}

#pragma mark - 身份证验证

+ (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value uppercaseString];
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return NO;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                int S = [value substringWithRange:NSMakeRange(0,1)].intValue*7 + [value substringWithRange:NSMakeRange(10,1)].intValue *7 + [value substringWithRange:NSMakeRange(1,1)].intValue*9 + [value substringWithRange:NSMakeRange(11,1)].intValue *9 + [value substringWithRange:NSMakeRange(2,1)].intValue*10 + [value substringWithRange:NSMakeRange(12,1)].intValue *10 + [value substringWithRange:NSMakeRange(3,1)].intValue*5 + [value substringWithRange:NSMakeRange(13,1)].intValue *5 + [value substringWithRange:NSMakeRange(4,1)].intValue*8 + [value substringWithRange:NSMakeRange(14,1)].intValue *8 + [value substringWithRange:NSMakeRange(5,1)].intValue*4 + [value substringWithRange:NSMakeRange(15,1)].intValue *4 + [value substringWithRange:NSMakeRange(6,1)].intValue*2 + [value substringWithRange:NSMakeRange(16,1)].intValue *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}

#pragma mark - 车牌号验证

+ (BOOL) validateCarNumber:(NSString *) carNumber{
    NSString *CarkNum = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarkNum];
    BOOL isMatch = [pred evaluateWithObject:carNumber];
    return isMatch;
}

#pragma mark - 获取机器唯一标识符

+ (NSString *)getUniqueDeviceIdentifierAsString
{
    NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    NSString *strApplicationUUID =  [SAMKeychain passwordForService:appName account:@"incoding"];
    
    if (strApplicationUUID == nil)
    {
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        NSError *error = nil;
        SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
        query.service = appName;
        query.account = @"incoding";
        query.password = strApplicationUUID;
        query.synchronizationMode = SAMKeychainQuerySynchronizationModeNo;
        [query save:&error];
        
    }
    
    return strApplicationUUID;
}

#pragma mark - 通过颜色获取生成图片

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;

}

#pragma mark - 高亮文字中部分文字

+ (NSMutableAttributedString *)highlightNummerInString:(NSString *)originString{
    
    //生成 NSAttributedString 子类 NSMutableAttributedString 的对象，这个NSMutableAttributedString才是可变的
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:originString];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [paragraphStyle setLineSpacing:5];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSParagraphStyleAttributeName] = paragraphStyle;
    [attribut addAttributes:dic range:NSMakeRange(0, attribut.length)];
    
    NSCharacterSet *numbers=[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray *setArr = [originString componentsSeparatedByCharactersInSet:numbers];
    NSString *temSting = originString;
    NSInteger location = 0;
    for (NSString *str_sub in setArr) {
        if (![str_sub isEqualToString:@""]) {
            NSRange numRange = [temSting rangeOfString:str_sub];
            location = location+numRange.location;
            
            /*
             * 这里要注意了，这里有两个方法，一个是改变单个属性用的，比如你只想改变字体，或者只是想改变显示的颜色用第一个方法就可以了，但是如果你同时想改变字体和颜色就应该用下面的方法
             - (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;
             - (void)addAttributes:(NSDictionary<NSString *, id> *)attrs range:(NSRange)range;
             */
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            //改变显示的颜色，还有很多属性，大家可以自行看文档
            dic[NSForegroundColorAttributeName] = UIColorFromRGB(0xf14827);
            //改变字体的大小
            dic[NSFontAttributeName] = [UIFont systemFontOfSize:16];
            //改变背景颜色
            //            dic[NSBackgroundColorAttributeName] = [UIColor grayColor];
            //            dic[NSParagraphStyleAttributeName] = paragraphStyle;
            //赋值
            NSRange numRange2 = NSMakeRange(location, numRange.length);
            [attribut addAttributes:dic range:numRange2];
            location = location+numRange.length;
            temSting = [temSting substringFromIndex:numRange.location+numRange.length];
            
        }
        
    }
    
    return attribut;
    
}

+ (NSMutableAttributedString *)highlightInString:(NSString *)originString withSubString:(NSString *)subString{
    
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:originString];
    
    NSRange range1=[[attribut string]rangeOfString:subString];
    [attribut addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xf05563) range:range1];
    
    return attribut;
    
}

#pragma mark - 通过UIView获取UIViewController

+ (UIViewController *)findViewController:(UIView *)sourceView withClass:(Class)classVC{
    id target = sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:classVC]) {
            break;
        }
    }
    return target;
    
}

#pragma mark - 获取当前时间：格式为yyyy-MM-dd HH:mm:ss

+ (NSString *)getCurrentTime{
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *current = [formatter stringFromDate:now];
    return current;
}

#pragma mark - 获取时间挫转换成时间：格式为yyyy-MM-dd HH:mm:ss

+ (NSString *)timeWithTimeInterval:(NSNumber *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)timeWithTimeInterval:(NSNumber *)timeString dateFormat:(NSString *)dateFormat{

    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateFormat];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;

}

#pragma mark - 画虚线

+ (UIImageView *)imageViewWithDottedLine{
    
    UIImageView *dashedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];

    UIGraphicsBeginImageContext(CGSizeMake(SCREEN_WIDTH-50, 1));   // 开始画线
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(line, kCGLineCapRound);  // 设置线条终点形状
    CGFloat lengths[] = {5, 5};// 设置每画10个point空出1个point
    CGContextSetStrokeColorWithColor(line, DefaultBtnNuableColor.CGColor); // 设置线条颜色
    CGContextSetLineWidth(line, 1.0);// 设置线条宽度
    CGContextSetLineDash(line, 0, lengths, 2); // 画虚线
    CGContextMoveToPoint(line, 0.0, 0.0); // 开始画线，移动到起点
    CGContextAddLineToPoint(line, SCREEN_WIDTH-50, 0.0);// 画到终点
    CGContextStrokePath(line);
    CGContextClosePath(line);// 结束画线
    dashedImageView.image = UIGraphicsGetImageFromCurrentImageContext();// 画完后返回UIImage对象
    
    return dashedImageView;
}


#pragma mark - 获取缓存目录

+ (NSString *)getCacheSubPath:(NSString *)dirName {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return [documentPath stringByAppendingPathComponent:dirName];
}

#pragma mark - 单个文件的大小

+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - 遍历文件夹获得文件夹大小，返回多少M

+ (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}


#pragma mark - 注销需要执行的操作

+ (void)loginOut{
    
    [ShareFun closeWebSocket];
    [LRBaseRequest clearRequestFilters];
    [ShareValue sharedDefault].token = nil;
    [ShareValue sharedDefault].phone = nil;
    [ShareValue sharedDefault].makeNumber = 0;
    [UserModel setUserModel:nil];
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:0];
    ApplicationDelegate.vc_tabBar = nil;
    LoginHomeVC *t_vc = [LoginHomeVC new];
    UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:t_vc];
    ApplicationDelegate.window.rootViewController = t_nav;
    
}

#pragma mark - 监测版本是否可以更新

+ (void)checkForVersionUpdates{

    [HSUpdateApp hs_updateWithAPPID:ITUNESAPPID block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate) {
        
        if (isUpdate == YES) {
            
            [SRAlertView sr_showAlertViewWithTitle:@"版本更新" message:[NSString stringWithFormat:@"发现新的版本(V%@),是否更新？",storeVersion] leftActionTitle:@"取消" rightActionTitle:@"更新" animationStyle:AlertViewAnimationZoom selectAction:^(AlertViewActionType actionType) {
                if (actionType == AlertViewActionTypeRight) {
                    NSURL *url = [NSURL URLWithString:openUrl];
                    [[UIApplication sharedApplication] openURL:url];
                }
                
            }];
            
        }else{
            
            [SRAlertView sr_showAlertViewWithTitle:@"版本更新" message:@"当前版本是最新版本" leftActionTitle:nil rightActionTitle:@"确定" animationStyle:AlertViewAnimationZoom selectAction:^(AlertViewActionType actionType) {
                
            }];
            
        }
        
    }];

}


#pragma mark - 检查版本是否强制更新
+ (void)checkForceForVersionUpdates{
    
    CommonVersionUpdateManger *manger = [[CommonVersionUpdateManger alloc] init];
    manger.appType = @"IOS";
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (manger.responseModel.code == CODE_SUCCESS) {
            if ( manger.commonVersionUpdateModel.isForce == YES) {
                
                [HSUpdateApp hs_updateWithAPPID:ITUNESAPPID block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate) {
                    
                    if (isUpdate == YES) {
                        
                        [SRAlertView sr_showAlertViewWithTitle:@"版本更新" message:[NSString stringWithFormat:@"发现新的版本(V%@),是否更新？",storeVersion] leftActionTitle:@"取消" rightActionTitle:@"更新" animationStyle:AlertViewAnimationZoom selectAction:^(AlertViewActionType actionType) {
                            if (actionType == AlertViewActionTypeRight) {
                                NSURL *url = [NSURL URLWithString:openUrl];
                                [[UIApplication sharedApplication] openURL:url];
                            }else if (actionType == AlertViewActionTypeLeft){
                                [ShareFun exitApplication];
                                
                            }
                            
                        }];
                        
                    }
                    
                }];
                
            }
           
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}

#pragma mark - 提示无权限操作

+ (void)showNoPermissionsTip{

    SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"您无权限做此操作"
                                                leftActionTitle:nil
                                               rightActionTitle:@"确定"
                                                 animationStyle:AlertViewAnimationNone
                                                   selectAction:^(AlertViewActionType actionType) {
                                                       
                                                   }];
    alertView.blurCurrentBackgroundView = NO;
    [alertView show];

}

#pragma mark - 开启webSocket
+ (void)openWebSocket{

    if ([UserModel getUserModel].workstate == YES) {
        
        [[WebSocketHelper sharedDefault] startServer];
        
    }

}

#pragma mark - 关闭webSocket
+ (void)closeWebSocket{
    
    SocketModel *t_socketModel  = [[SocketModel alloc] init];
    t_socketModel.fromUserId = @([[UserModel getUserModel].userId integerValue]);
    t_socketModel.msgType = @(WEBSOCKTETYPE_POLICELOGINOUT);
    NSString *json_string = t_socketModel.modelToJSONString;
    [[WebSocketHelper sharedDefault].webSocket send:json_string];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[WebSocketHelper sharedDefault] closeServer];
    });
    
    
}

#pragma mark - 定位地址存储在plist上面
+ (void)locationlog:(NSString*)logKey andValue:(NSString*)logValue{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectroy = [paths objectAtIndex:0];
    NSString *filename =@"location.plist";
    NSString *filePath = [documentsDirectroy stringByAppendingPathComponent:filename];
    //NSLog(@"filePath:%@",filePath);
    NSFileManager *file =  [NSFileManager defaultManager];
    NSMutableDictionary *dic;
    if ([file fileExistsAtPath:filePath]) {
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }else{
        dic = [[NSMutableDictionary alloc] init];
    }
    [dic setValue:logValue  forKey:logKey];
    [dic writeToFile:filePath atomically:YES];
}

#pragma mark - 让NSString不为空

+ (NSString *)takeStringNoNull:(NSString *)t_string{
    
    if (t_string && t_string.length > 0) {
        return t_string;
    }else{
        return @" ";
    }
    
}

#pragma mark - 讲图片变成马赛克


#define kBitsPerComponent (8)
#define kBitsPerPixel (32)
#define kPixelChannelCount (4)

/*
 *转换成马赛克,level代表一个点转为多少level*level的正方形
 */
+ (UIImage *)transToMosaicImage:(UIImage*)orginImage blockLevel:(NSUInteger)level
{
    //获取BitmapData
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef imgRef = orginImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  kBitsPerComponent,        //每个颜色值8bit
                                                  width*kPixelChannelCount, //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit
                                                  colorSpace,
                                                  kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    unsigned char *bitmapData = CGBitmapContextGetData (context);
    
    //这里把BitmapData进行马赛克转换,就是用一个点的颜色填充一个level*level的正方形
    unsigned char pixel[kPixelChannelCount] = {0};
    NSUInteger index,preIndex;
    for (NSUInteger i = 0; i < height - 1 ; i++) {
        for (NSUInteger j = 0; j < width - 1; j++) {
            index = i * width + j;
            if (i % level == 0) {
                if (j % level == 0) {
                    memcpy(pixel, bitmapData + kPixelChannelCount*index, kPixelChannelCount);
                }else{
                    memcpy(bitmapData + kPixelChannelCount*index, pixel, kPixelChannelCount);
                }
            } else {
                preIndex = (i-1)*width +j;
                memcpy(bitmapData + kPixelChannelCount*index, bitmapData + kPixelChannelCount*preIndex, kPixelChannelCount);
            }
        }
    }
    
    NSInteger dataLength = width*height* kPixelChannelCount;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData, dataLength, NULL);
    //创建要输出的图像
    CGImageRef mosaicImageRef = CGImageCreate(width, height,
                                              kBitsPerComponent,
                                              kBitsPerPixel,
                                              width*kPixelChannelCount ,
                                              colorSpace,
                                              kCGImageAlphaPremultipliedLast,
                                              provider,
                                              NULL, NO,
                                              kCGRenderingIntentDefault);
    CGContextRef outputContext = CGBitmapContextCreate(nil,
                                                       width,
                                                       height,
                                                       kBitsPerComponent,
                                                       width*kPixelChannelCount,
                                                       colorSpace,
                                                       kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(outputContext, CGRectMake(0.0f, 0.0f, width, height), mosaicImageRef);
    CGImageRef resultImageRef = CGBitmapContextCreateImage(outputContext);
    UIImage *resultImage = nil;
    if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
        float scale = [[UIScreen mainScreen] scale];
        resultImage = [UIImage imageWithCGImage:resultImageRef scale:scale orientation:UIImageOrientationUp];
    } else {
        resultImage = [UIImage imageWithCGImage:resultImageRef];
    }
    //释放
    if(resultImageRef){
        CFRelease(resultImageRef);
    }
    if(mosaicImageRef){
        CFRelease(mosaicImageRef);
    }
    if(colorSpace){
        CGColorSpaceRelease(colorSpace);
    }
    if(provider){
        CGDataProviderRelease(provider);
    }
    if(context){
        CGContextRelease(context);
    }
    if(outputContext){
        CGContextRelease(outputContext);
    }
    return resultImage;
    
}



+ (UIImage *)addWatemarkTextAfteriOS7_WithLogoImage:(UIImage *)logoImage watemarkText:(NSString *)watemarkText needHigh:(BOOL)isHigh{

    int w = logoImage.size.width;
    int h = logoImage.size.height;
    if (isHigh) {
        UIGraphicsBeginImageContextWithOptions(logoImage.size, NO, 0.0);
        [logoImage drawInRect:CGRectMake(0, 0, w, h)];
        UIFont * font = [UIFont systemFontOfSize:w/22.0f];
        
        [watemarkText drawInRect:CGRectMake(w/12, h/2 - h/30 , w*5/6, h/15) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor],NSBackgroundColorAttributeName:[UIColor colorWithWhite:0.f alpha:0.2]}];
        UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
        
    }else{
        
        UIGraphicsBeginImageContext(logoImage.size);
        [logoImage drawInRect:CGRectMake(0, 0, w, h)];
        UIFont * font = [UIFont systemFontOfSize:w/22.0f];
        
        [watemarkText drawInRect:CGRectMake(w/12, h/2 - h/30 , w*5/6, h/15) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor],NSBackgroundColorAttributeName:[UIColor colorWithWhite:0.f alpha:0.2]}];
        UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }

    
    
}

#pragma mark - 隐藏身份证号码中间字符


+ (NSString*)idCardToAsterisk:(NSString *)idCardNum{
    
    if (idCardNum && idCardNum.length > 16) {
        //NSInteger length = idCardNum.length;
        return [idCardNum stringByReplacingCharactersInRange:NSMakeRange(10, 6) withString:@"******"];
    }else{
        return @" ";
    }
    
}

#pragma mark - 打印崩溃日志重定向
+ (void)printCrashLog{
    
    //日子重定向用于记录崩溃日志
    SuperLogger *logger = [SuperLogger sharedInstance];
    // Start NSLogToDocument
    [logger redirectNSLogToDocumentFolder];
    // Set Email info
    logger.mailTitle = @"移动采集日志信息";
    logger.mailContect = @"移动采集日志信息";
    logger.mailRecipients = @[@"qgwzhuanglr@163.com"];
    //每次进来清除一周前的日志
    NSDate *five = [[NSDate date]dateByAddingTimeInterval:-60*60*24*7];
    [[SuperLogger sharedInstance] cleanLogsBefore:five deleteStarts:YES];
    
}

#pragma mark - 退出程序

+ (void)exitApplication{
    
    AppDelegate *app = (id<UIApplicationDelegate>)[UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(window.bounds.size.width/2, window.bounds.size.height/2, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    
}

#pragma mark - 弹出tip信息框

+ (void)showTipLable:(NSString *)tip{
    
    AppDelegate *app = (id<UIApplicationDelegate>)[UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    __block UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(40, ScreenHeight - 100, window.frame.size.width-80, 30)];
    lb_title.font =[UIFont systemFontOfSize:14];
    lb_title.textColor = [UIColor whiteColor];
    lb_title.layer.cornerRadius = 5.0f;
    lb_title.layer.masksToBounds = YES;
    
    lb_title.textAlignment = NSTextAlignmentCenter;
    lb_title.backgroundColor = [UIColor blackColor];
    lb_title.text = tip;
    
    [window addSubview:lb_title];
    
    [[GCDQueue mainQueue] execute:^{
        [lb_title removeFromSuperview];
        lb_title = nil;
    } afterDelay:3.0f*NSEC_PER_SEC];
    
    
}


@end
