//
//  AutomaicUpCacheModel.h
//  移动采集
//
//  Created by hcat on 2018/10/16.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AutomaicUpCacheModel : NSObject

LRSingletonH(Default)

@property(nonatomic,assign) BOOL isAutoPark;
@property(nonatomic,assign) BOOL isAutoReversePark;
@property(nonatomic,assign) BOOL isAutoLockPark;
@property(nonatomic,assign) BOOL isAutoCarInfoAdd;
@property(nonatomic,assign) BOOL isAutoThrough;
@property(nonatomic,assign) BOOL isAutoAccident;
@property(nonatomic,assign) BOOL isAutoFastAccident;

@end

NS_ASSUME_NONNULL_END
