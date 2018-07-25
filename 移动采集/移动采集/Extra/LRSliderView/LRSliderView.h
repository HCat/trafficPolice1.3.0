//
//  LRSliderView.h
//  LRSliderViewDemo
//
//  Created by hcat on 2018/7/13.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRSliderViewConfig.h"

@class LRSliderView;

@protocol LRSliderViewDelegate <NSObject>

@required

- (NSInteger)numberOfItemsInSliderView:(LRSliderView *)sliderView;

- (UIView *)sliderView:(LRSliderView *)sliderView viewForItemAtIndex:(NSInteger)index;

- (NSString *)sliderView:(LRSliderView *)sliderView titleForItemAtIndex:(NSInteger)index;

@optional

//视图起始位置
- (NSInteger)startIndexForSliderView:(LRSliderView *)sliderView;

//当视图滚动到指定页面之后需要做的操作
- (void)sliderViewScrolledtoPageAtIndex:(NSInteger)index;

@end

@interface LRSliderView : UIView


@property (nonatomic, weak) id<LRSliderViewDelegate> delegate;

//当前页面索引
@property (nonatomic, assign, readonly) NSInteger currentIndex;


//刷新视图
- (void)reloadData;

//滚动到指定视图
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;


@end
