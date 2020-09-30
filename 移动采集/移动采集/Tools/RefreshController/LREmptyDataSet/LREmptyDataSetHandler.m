//
//  LREmptyDataSetHandler.m
//  框架
//
//  Created by hcat on 2019/11/19.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "LREmptyDataSetHandler.h"

NSInteger const LRDataLoadStateAll = LRDataLoadStateIdle | LRDataLoadStateLoading | LRDataLoadStateEmpty | LRDataLoadStateFailed;

@implementation LREmptyDataSetHandler

#pragma mark - Lifecycle

- (instancetype)init {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    [self configure];
    
    return self;
    
}

#pragma mark - Setter
- (void)setScrollView:(UIScrollView *)scrollView{
    
    //不是UIScrollView, 则返回
    if (scrollView && ![scrollView isKindOfClass:[UIScrollView class]]) {
        return;
    }
    
    scrollView.emptyDataSetSource = self;
    scrollView.emptyDataSetDelegate = self;
    _scrollView = scrollView;
    
}

- (void)setState:(LRDataLoadState)state{
    
    BOOL valid = state == LRDataLoadStateIdle || state == LRDataLoadStateLoading || state == LRDataLoadStateEmpty || state == LRDataLoadStateFailed;
    NSAssert(valid, @"state is unavailable(do not use multiple options)");
    
    if (!valid) {
        return;
    }
    
    _state = state;
    
    [self.scrollView reloadEmptyDataSet];
    
}


#pragma mark - Other

- (void)configure{
    // 初始配置写在这里
    self.state = LRDataLoadStateIdle;
}


@end
