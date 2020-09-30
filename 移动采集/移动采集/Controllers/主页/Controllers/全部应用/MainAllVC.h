//
//  MainAllVC.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/11.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainAllVC : UIViewController <JXPagerViewListViewDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

NS_ASSUME_NONNULL_END
