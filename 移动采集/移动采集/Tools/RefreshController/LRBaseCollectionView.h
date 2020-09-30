//
//  LRBaseCollectionView.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/12.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LREmptyDataSet.h"

NS_ASSUME_NONNULL_BEGIN

/** 下拉刷新回调 */
typedef void(^headerRefresh)(void);
/** 上拉加载回调 */
typedef void(^footerLoadMore)(void);

/** 点击触发事件 */
typedef void(^clickPlaceholderBlock)(void);


@interface LRBaseCollectionView : UICollectionView

/**
 *  配置占位图类型 handlerType
 *  type 为1 表示通用类型
 *  2为
 *
 */
//@property (nonatomic, strong) NSNumber * handlerType;


@property (nonatomic, strong) UIImage * image_noData;
@property (nonatomic, copy) NSString * string_noData;
/**
*  用于配置是否需要当数据为空的时候重新加载数据，默认为YES 表示需要加载按钮 这个要优先于isHavePlaceholder设置属性
*/
@property (nonatomic, assign) BOOL isNeedNoDataReload;
/**
 *  用于配置是否需要占位图，默认NO,表示不需要占位图
 */
@property (nonatomic, assign) BOOL isHavePlaceholder;


/** 是否允许 下拉刷新（默认 NO） */
@property (nonatomic, assign) BOOL enableRefresh;
/** 是否允许 上拉加载更多 （默认 NO） */
@property (nonatomic, assign) BOOL enableLoadMore;
/** 是否加入断网自动提示 （默认 NO） */
@property (nonatomic, assign) BOOL autoNetworkNotice;

/** 刷新回调 */
@property (nonatomic, copy) headerRefresh collectionViewHeaderRefresh;
/** 加载回调 */
@property (nonatomic, copy) footerLoadMore collectionViewFooterLoadMore;

/** 点击重新加载数据回调 */
@property (nonatomic, copy) clickPlaceholderBlock collectionViewPlaceholderBlock;

// MARK: - 公开方法

/** 开始刷新动画 */
- (void)beginRefresh;

/** 停止刷新动画 */
- (void)endingRefresh;

/** 开始加载更多动画 */
- (void)beginLoadMore;

/** 停止加载更多动画 */
- (void)endingLoadMore;

/** 停止加载更多动画，并提示没有更多内容 */
- (void)endingNoMoreData;

/** 重新设置没有更多内容 */
- (void)resetNoMoreData;


@end

NS_ASSUME_NONNULL_END
