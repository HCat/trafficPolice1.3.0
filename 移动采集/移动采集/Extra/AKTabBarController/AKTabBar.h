//
//  AKTabBar.h
//
//  Created by hcat on 2017/9/22.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AKTab.h"

@class AKTabBar;

@protocol AKTabBarDelegate <NSObject>

@required

// Used by the TabBarController to be notified when a tab is pressed
- (void)tabBar:(AKTabBar *)AKTabBarDelegate didSelectTabAtIndex:(NSInteger)index;

@end

@interface AKTabBar : UIView

@property (nonatomic, strong) NSArray *arr_tabs;
@property (nonatomic, strong) AKTab *tab_selected;
@property (nonatomic, assign) id <AKTabBarDelegate> delegate;

// tabBar的顶部横线
@property (nonatomic, strong) UIColor * tabBar_topEdgeColor;

// Tab竖直分割线的颜色
@property (nonatomic, strong) UIColor * tabBar_strokeColor;

// tabBar的背景图片
@property (nonatomic, copy)   NSString * tabBar_bgImageName;

// tabBar的背景颜色
@property (nonatomic, strong) UIColor * tabBar_bgColor;

- (void)tabSelected:(AKTab *)sender;

@end
