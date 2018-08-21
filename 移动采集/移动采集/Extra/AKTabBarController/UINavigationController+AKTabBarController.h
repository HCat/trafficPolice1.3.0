//
//  UINavigationController+AKTabBarController.h
//
//  Created by hcat on 2017/10/10.
//  Copyright © 2017年 Hcat. All rights reserved.
//

@interface UINavigationController (AKTabBarController)

- (NSString *)tabImageName;

- (NSString *)tabSelectedImageName;

- (NSString *)tabTitle;

- (BOOL)showMask;

- (BOOL)showTip;

- (NSInteger)showMaskNumber;

- (BOOL)canChangeTab;

@end
