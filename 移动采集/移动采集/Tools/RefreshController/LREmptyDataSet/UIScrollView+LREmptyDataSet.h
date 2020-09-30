//
//  UIScrollView+LREmptyDataSet.h
//  框架
//
//  Created by hcat on 2019/11/21.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LREmptyDataSetHandler;

@interface UIScrollView (LREmptyDataSet)

/** 空白状态配置项 */
@property (nonatomic, strong, nullable) __kindof LREmptyDataSetHandler  * lr_handler;

@end

NS_ASSUME_NONNULL_END
