//
//  FeedbackFootView.h
//  移动采集
//
//  Created by hcat on 2017/7/25.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackFootView : UICollectionReusableView

@property (nonatomic,assign) BOOL isCanCommit;
@property (nonatomic,copy) void (^handleCommitBlock)();

@end
