//
//  LRSliderViewConfig.m
//  LRSliderViewDemo
//
//  Created by hcat on 2018/7/13.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "LRSliderViewConfig.h"

@implementation LRSliderViewConfig

+ (LRSliderViewConfig *)sharedConfig {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance defaultConfig];
    });
    return sharedInstance;
}

- (void)defaultConfig{
    self.font = [UIFont systemFontOfSize:14];
    self.titleColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.f];
    self.selectedColor = [UIColor colorWithRed:51/255.f green:150/255.f blue:252/255.f alpha:1.f];
    self.maxCountInScreen = 5;
    self.scaleSize = 1.2f;
    self.topViewHeight = 44.f;
}


@end
