//
//  AKTabBarView.h
//
//  Created by hcat on 2017/9/25.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AKTabBar.h"

@interface AKTabBarView : UIView

@property (nonatomic, strong) AKTabBar *tabBar;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL isTabBarHidding;
@end
