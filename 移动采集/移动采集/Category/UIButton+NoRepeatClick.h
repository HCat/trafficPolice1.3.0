//
//  UIButton+NoRepeatClick.h
//  trafficPolice
//
//  Created by HCat on 2017/5/11.
//  Copyright © 2017年 Degal. All rights reserved.



#import <Foundation/Foundation.h>

#define buttonRepeatInterval 1
@interface UIButton (NoRepeatClick)

//点击间隔
@property (nonatomic, assign) NSTimeInterval timeInterval;
//用于设置单个按钮不需要被hook
@property (nonatomic, assign) BOOL isIgnore;

@end
