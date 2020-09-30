//
//  MainAllListView.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/14.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView/JXCategoryView.h>
#import "MainAllListViewModel.h"
#import "LRBaseCollectionView.h"


@interface MainAllListView : UIView<JXCategoryListContentViewDelegate>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) LRBaseCollectionView * collectionView;
@property (nonatomic, strong) MainAllListViewModel * viewModel;

- (instancetype)initWithViewModel:(MainAllListViewModel *)viewModel;

@end


