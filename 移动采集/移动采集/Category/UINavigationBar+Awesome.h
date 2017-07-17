//
//  UINavigationBar+BackgroundColor.h
//  SuiXiang
//
//  Created by ltebean on 15-2-15.
//  Copyright (c) 2015年 ltebean. All rights reserved.
//

//用于滑动隐藏导航栏功能

#import <UIKit/UIKit.h>

@interface UINavigationBar (Awesome)
- (void)lt_setBackgroundColor:(UIColor *)backgroundColor;
- (void)lt_setContentAlpha:(CGFloat)alpha;
- (void)lt_setTranslationY:(CGFloat)translationY;
- (void)lt_reset;
@end
