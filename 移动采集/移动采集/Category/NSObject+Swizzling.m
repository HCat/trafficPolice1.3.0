//
//  NSObject+Swizzling.m
//  trafficPolice
//
//  Created by HCat on 2017/5/11.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "NSObject+Swizzling.h"

@implementation NSObject (Swizzling)

+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector bySwizzledSelector:(SEL)swizzledSelector{
    Class class = [self class];
    //原有方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    
    //替换原有方法的新方法
    Method swizzlingMethod = class_getInstanceMethod(class, swizzledSelector);
    
    //先尝试给源SEL添加IMP,这里是为了避免源SEL没有实现IMP的情况
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod));
    
    if (didAddMethod) {
        //添加成功：说明源SEL没有实现IMP,将源SEL的IMP替换到交换的SEL的IMP上
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        
    }else{
        //添加失败：说明源SEL已经有IMP,直接将两个SEL的IMP交换即可
        method_exchangeImplementations(originalMethod, swizzlingMethod);
    
    }
    
}



@end
