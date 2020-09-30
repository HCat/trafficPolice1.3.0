//
//  UIScrollView+LREmptyDataSet.m
//  框架
//
//  Created by hcat on 2019/11/21.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "UIScrollView+LREmptyDataSet.h"
#import "LREmptyDataSetHandler.h"
#import <objc/runtime.h>

@implementation UIScrollView (LREmptyDataSet)

- (void)setLr_handler:(__kindof LREmptyDataSetHandler *)lr_handler {
    if (lr_handler != self.lr_handler) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(lr_handler))]; // KVO
        
        objc_setAssociatedObject(self, @selector(lr_handler), lr_handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        lr_handler.scrollView = self;
        
        [self didChangeValueForKey:NSStringFromSelector(@selector(lr_handler))]; // KVO
    }
}

- (LREmptyDataSetHandler *)lr_handler {
    return objc_getAssociatedObject(self, @selector(lr_handler));
}

@end
