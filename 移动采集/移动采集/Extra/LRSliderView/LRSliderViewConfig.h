//
//  LRSliderViewConfig.h
//  LRSliderViewDemo
//
//  Created by hcat on 2018/7/13.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LRSliderViewConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


+ (LRSliderViewConfig *)sharedConfig;

//title默认颜色
@property (nonatomic, strong) UIColor *titleColor;

//title选中颜色
@property (nonatomic, strong) UIColor *selectedColor;

//title字体大小
@property (nonatomic, strong) UIFont *font;

//当前屏幕显示最多选项
@property (nonatomic, assign) NSInteger maxCountInScreen;

//title字体选中之后的放大倍数
@property (nonatomic, assign) CGFloat scaleSize;

//title视图的宽度
@property (nonatomic, assign) CGFloat topViewHeight; 

@end
