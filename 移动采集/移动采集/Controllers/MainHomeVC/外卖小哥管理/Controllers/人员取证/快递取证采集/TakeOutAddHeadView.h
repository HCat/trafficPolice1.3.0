//
//  TakeOutAddHeadView.h
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakeOutAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface TakeOutAddHeadView : UICollectionReusableView

@property (nonatomic,strong) TakeOutSaveParam * param;
@property (nonatomic, copy) NSString * deliveryId;
@property (nonatomic,assign) BOOL btnType; //1:代表开  0:代表关

#pragma mark - 通过所在路段的名字获取得到roadId

- (void)getRoadId;
- (void)strogeLocationBeforeCommit;

@end

NS_ASSUME_NONNULL_END
