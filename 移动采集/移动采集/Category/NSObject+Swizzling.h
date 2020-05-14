//
//  NSObject+Swizzling.h
//  trafficPolice
//
//  Created by HCat on 2017/5/11.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (Swizzling)

+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector                         bySwizzledSelector:(SEL)swizzledSelector;


@end
