//
//  AKTabBar.m
//
//  Created by hcat on 2017/9/22.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AKTabBar.h"

static int kInterTabMargin = 1; //tabs之间的距离间隔
static int kTopEdgeHeight  = 1; //topEdge的高度

@implementation AKTabBar

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeRedraw;
        self.opaque = YES;
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                 UIViewAutoresizingFlexibleHeight |
                                 UIViewAutoresizingFlexibleTopMargin);
    }
    return self;
}

#pragma mark - Setters and Getters

- (void)setArr_tabs:(NSArray *)arr_tabs{
    if (_arr_tabs != arr_tabs) {
        for (AKTab *tab in _arr_tabs) {
            [tab removeFromSuperview];
        }
        
        _arr_tabs = arr_tabs;
        
        for (AKTab *tab in _arr_tabs) {
            tab.userInteractionEnabled = YES;
            [tab addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [self setNeedsLayout];
}

- (void)setTab_selected:(AKTab *)tab_selected{
    
    if (tab_selected != _tab_selected) {
        [_tab_selected setSelected:NO];
        _tab_selected = tab_selected;
        [_tab_selected setSelected:YES];
    }
}

#pragma mark - Delegate notification

- (void)tabSelected:(AKTab *)sender{
    [_delegate tabBar:self didSelectTabAtIndex:[_arr_tabs indexOfObject:sender]];
}


#pragma mark - Drawing & Layout

- (void)drawRect:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 绘制tabBar的背景,根据
    CGContextSaveGState(ctx);{
        if (_tabBar_bgImageName) {
            [[UIColor colorWithPatternImage:[UIImage imageNamed:_tabBar_bgImageName ? _tabBar_bgImageName : @"LRTabBarController.bundle/noise-pattern"]] set];
            CGContextFillRect(ctx, rect);
        }
        
        if (_tabBar_bgColor) {
            [_tabBar_bgColor set];
            CGContextFillRect(ctx, rect);
        }
        
    }
    CGContextRestoreGState(ctx);
    
    // 绘制tabBar顶部横线
    CGContextSaveGState(ctx);
    {
        UIColor *topEdgeColor = _tabBar_topEdgeColor ? _tabBar_topEdgeColor : [UIColor colorWithRed:.1f green:.1f blue:.1f alpha:.0f];;
        
        CGContextSetFillColorWithColor(ctx, topEdgeColor.CGColor);
        CGContextFillRect(ctx, CGRectMake(0, 0, rect.size.width, kTopEdgeHeight));
    }
    CGContextRestoreGState(ctx);
    
    
    // 画出竖直分割线
    CGContextSetFillColorWithColor(ctx,  _tabBar_strokeColor? [_tabBar_strokeColor CGColor] : [[UIColor colorWithRed:.1f green:.1f blue:.1f alpha:.0f] CGColor]);
    
    for (AKTab *tab in _arr_tabs){
        CGContextFillRect(ctx, CGRectMake(tab.frame.origin.x - kInterTabMargin, kTopEdgeHeight, kInterTabMargin, rect.size.height));
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat screenWidth = self.bounds.size.width;
    
    CGFloat tabNumber = _arr_tabs.count;
    
    // Calculating the tabs width.
    CGFloat tabWidth = floorf(((screenWidth + 1) / tabNumber) - 1);
    
    // Because of the screen size, it is impossible to have tabs with the same
    // width. Therefore we have to increase each tab width by one until we spend
    // of the spaceLeft counter.
    CGFloat spaceLeft = screenWidth - (tabWidth * tabNumber) - (tabNumber - 1);
    
    CGRect rect = self.bounds;
    rect.size.width = tabWidth;
    
    CGFloat dTabWith;
    
    for (AKTab *tab in _arr_tabs) {
        
        // Here is the code that increment the width until we use all the space left
        
        dTabWith = tabWidth;
        
        if (spaceLeft != 0) {
            dTabWith = tabWidth + 1;
            spaceLeft--;
        }
        
        if ([_arr_tabs indexOfObject:tab] == 0) {
            tab.frame = CGRectMake(rect.origin.x, rect.origin.y, dTabWith, rect.size.height);
        } else {
            
            tab.frame = CGRectMake(rect.origin.x + kInterTabMargin, rect.origin.y, dTabWith, rect.size.height);
            if(tab.keepFlag){
                tab.frame = CGRectMake(rect.origin.x + kInterTabMargin, rect.origin.y- 15, dTabWith, 60);
                
            }
        }
        
        [self addSubview:tab];
        rect.origin.x = tab.frame.origin.x + tab.frame.size.width;
    }

}

@end
