//
//  SearchTagHelper.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/6/11.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "SearchTagHelper.h"

@implementation SearchTagHelper

//缓存搜索数组
+(void)SaveSearchText :(NSString *)seaTxt
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    NSArray *myArray = [userDefaultes arrayForKey:USERDEFAULT_KEY_SEARCHTAG];
    if (myArray.count > 0) {//先取出数组，判断是否有值，有值继续添加，无值创建数组
        
    }else{
        myArray = [NSArray array];
    }
    // NSArray --> NSMutableArray
    NSMutableArray *searTXT = [myArray mutableCopy];
    [searTXT addObject:seaTxt];
    if(searTXT.count > 20)
    {
        [searTXT removeObjectAtIndex:0];
    }
    //将上述数据全部存储到NSUserDefaults中
    //        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:searTXT forKey:USERDEFAULT_KEY_SEARCHTAG];
    [userDefaultes synchronize];
}

//删除所有Tag数据
+(void)removeAllArray{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:USERDEFAULT_KEY_SEARCHTAG];
    [userDefaults synchronize];
}

//读取所有Tag数据
+(NSArray *)readTagArray{//取出缓存的数据
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    NSArray * myArray = [userDefaultes arrayForKey:USERDEFAULT_KEY_SEARCHTAG];
    NSArray* reversedArray = [[myArray reverseObjectEnumerator] allObjects];
    LxPrintf(@"reversedArray======%@",reversedArray);
    return reversedArray;
}

@end
