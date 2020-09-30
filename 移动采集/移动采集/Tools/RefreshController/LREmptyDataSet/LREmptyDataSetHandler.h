//
//  LREmptyDataSetHandler.h
//  框架
//
//  Created by hcat on 2019/11/19.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>)
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#else
#import "UIScrollView+EmptyDataSet.h"
#endif

/** 数据加载的状态 */
typedef NS_OPTIONS(NSUInteger, LRDataLoadState) {
    LRDataLoadStateIdle     = 1 << 0, //闲置
    LRDataLoadStateLoading  = 1 << 1, //加载中
    LRDataLoadStateEmpty    = 1 << 2, //数据空
    LRDataLoadStateFailed   = 1 << 3, //加载失败
};

FOUNDATION_EXTERN NSInteger const LRDataLoadStateAll;

NS_ASSUME_NONNULL_BEGIN

@interface LREmptyDataSetHandler : NSObject<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, weak)     UIScrollView        *scrollView;
@property (nonatomic, assign)   LRDataLoadState   state;

/** 初始配置 */
- (void)configure NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
