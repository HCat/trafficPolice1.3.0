//
//  FeedbackHeadView.h
//  移动采集
//
//  Created by hcat on 2017/7/25.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTextView.h"

@interface FeedbackHeadView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet FSTextView *textView;
@property (nonatomic,assign,readonly) BOOL isCanCommit;

@end
