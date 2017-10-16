//
//  AKTabBarController.h
//
//  Created by hcat on 2017/9/25.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AKTabBarView.h"
#import "AKTabBar.h"
#import "AKTab.h"

@protocol AKTabBarControllerDelegate <NSObject>

@optional

- (void)tabBarControllerdidSelectTabAtIndex:(NSInteger)index;

@end

@interface AKTabBarController : UIViewController <AKTabBarDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id<AKTabBarControllerDelegate> delegate;

// TabBarController包含的视图控制器
@property (nonatomic, strong) NSMutableArray *viewControllers;

// 当前TabBarController选中的视图
@property (nonatomic, strong) UIViewController *selectedViewController;

// 当前TabBarController选中的索引
@property (nonatomic, assign) NSInteger selectedIndex;

//***********************  tabBar配置  *************************

// tabBar的顶部横线
@property (nonatomic, strong) UIColor  * tabBar_topEdgeColor;

// tabBar竖直分割线的颜色
@property (nonatomic, strong) UIColor  * tabBar_strokeColor;

// tabBar的背景图片
@property (nonatomic, copy)   NSString * tabBar_bgImageName;

// tabBar的背景颜色
@property (nonatomic, strong) UIColor  * tabBar_bgColor;

//***********************  对单个tab配置  *************************

// Tab是否显示或者隐藏title
@property (nonatomic, assign) BOOL isTitleHidden;
// Tab选中状态下的背景图片名称
@property (nonatomic, copy)   NSString * tab_selectedBgImageName;
// Tab选中状态下的背景颜色
@property (nonatomic, strong) UIColor  * tab_selectedBgColor;
// Tab未选中状态下的title字体颜色
@property (nonatomic, strong) UIColor  * tab_titleColor;
// Tab选中状态下的title字体颜色
@property (nonatomic, strong) UIColor  * tab_selectedTitleColor;
// Tab未选中状态下的显示的title的font
@property (nonatomic, strong) UIFont   * tab_titleFont;
// Tab在无选中图片时候，是否显示发光效果
@property (nonatomic, assign) BOOL isGlossySelected;

// Initialization with a specific height.
- (id)initWithTabBarHeight:(NSUInteger)height;

// Hide / Show Methods
- (void)showTabBarAnimated:(BOOL)animated;
- (void)hideTabBarAnimated:(BOOL)animated;

-(AKTabBar *)getTabBar;

-(AKTabBarView *)getTabBarView;

// Refresh the Tab Bar
- (void)loadTabs;

@end
