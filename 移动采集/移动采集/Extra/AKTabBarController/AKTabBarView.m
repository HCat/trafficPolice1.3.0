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
    [_tabBar setFrame:tabBarRect];
    
    CGRect contentViewRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - ((!_isTabBarHidding) ? CGRectGetHeight(_tabBar.bounds) : 0));
    _contentView.frame = contentViewRect;
    [_contentView setNeedsLayout];
}




@end
