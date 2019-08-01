//
//  ParkingForensicsHeadView.h
//  移动采集
//
//  Created by hcat on 2019/7/29.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParkingForensicsAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParkingForensicsHeadView : UICollectionReusableView

@property (nonatomic,strong) ParkingForensicsParam * param;
@property (nonatomic,assign) BOOL btnType; //1:代表开  0:代表关

#pragma mark - 通过所在路段的名字获取得到roadId

- (void)getRoadId;
- (void)strogeLocationBeforeCommit;

@end

NS_ASSUME_NONNULL_END
