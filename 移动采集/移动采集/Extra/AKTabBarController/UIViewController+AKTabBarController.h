//
//  UIViewController+AKTabBarController.h
//
//  Created by hcat on 2017/10/10.
//  Copyright © 2017年 Hcat. All rights reserved.
//

@class AKTabBarController;

@interface UIViewController (AKTabBarController)

// tab的未选中图片名称
- (NSString *)tabImageName;

// tab的选中图片名称
- (NSString *)tabSelectedImageName;

// tab的title
- (NSString *)tabTitle;

// 当选中相同按钮适合所做的操作
- (void)tabBarReSelected;

// 是否显示通知标签
- (BOOL)showMask;

//
- (BOOL)showTip;


// 显示标签数目
- (NSInteger)showMaskNumber;


-(BOOL)canChangeTab;

- (AKTabBarController*)akTabBarController;


@end
