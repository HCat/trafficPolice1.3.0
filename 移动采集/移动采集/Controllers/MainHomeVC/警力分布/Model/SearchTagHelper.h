//
//  SearchTagHelper.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/6/11.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchTagHelper : NSObject

//缓存搜索的数组
+(void)SaveSearchText :(NSString *)seaTxt;
//清除缓存搜索数组
+(void)removeAllArray;
//读取所有Tag数据
+(NSArray *)readTagArray;

@end
