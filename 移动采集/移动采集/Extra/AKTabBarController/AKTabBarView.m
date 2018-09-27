//
//  AKTabBarView.m
//
//  Created by hcat on 2017/9/25.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AKTabBarView.h"

@implementation AKTabBarView

#pragma mark - Setters

- (void)setTabBar:(AKTabBar *)tabBar{
    
    if (_tabBar != tabBar){
        
        [_tabBar removeFromSuperview];
        _tabBar = tabBar;
        [self addSubview:tabBar];
    }
}


- (void)setContentView:(UIView *)contentView{
    
    if (_contentView != contentView)
    {
        [_contentView removeFromSuperview];
        _contentView = contentView;
        [self addSubview:_contentView];
        [self sendSubviewToBack:_contentView];
    }

     _contentView.frame = CGRectMake(0, 0, self.bounds.size.width, self.tabBar.frame.origin.y);
    [_contentView setNeedsDisplay];
    [self setNeedsLayout];
}

#pragma mark - Layout & Drawing

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect tabBarRect = _tabBar.frame;
    tabBarRect.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(_tabBar.bounds);
    if (IS_IPHONE_X_MORE) {
        tabBarRect.origin.y = CGRectGetHeight(self.bounds) - (CGRectGetHeight(_tabBar.bounds) + 20);
    }
    [_tabBar setFrame:tabBarRect];
    
    CGRect contentViewRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - ((!_isTabBarHidding) ? CGRectGetHeight(_tabBar.bounds) : 0));
    if (IS_IPHONE_X_MORE) {
        contentViewRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - ((!_isTabBarHidding) ? (CGRectGetHeight(_tabBar.bounds) + 20): 20));
    }
    _contentView.frame = contentViewRect;
    [_contentView setNeedsLayout];
    [_contentView layoutIfNeeded];
    [_contentView layoutSubviews];
}




@end
