//
//  UICollectionView+Lr_Placeholder.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/16.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UICollectionView (Lr_Placeholder)

@property (nonatomic, assign) BOOL firstReload;
@property (nonatomic, assign) BOOL isNetAvailable; //用于外部网络是否正常使用
@property (nonatomic, strong) UIView *placeholderView; //用于外部设置异常加载占位图,如果没有设置，则使用默认的异常加载占位图
@property (nonatomic, copy)   void (^reloadBlock)(void);

//判断是否需要占位图, 默认是不需要的
@property (nonatomic, assign) BOOL isNeedPlaceholderView;

@end
