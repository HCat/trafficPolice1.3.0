//
//  DailyPatrolLocationHelper.h
//  移动采集
//
//  Created by hcat-89 on 2020/1/13.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailyPatrolLocationHelper : NSObject

LRSingletonH(Default)

- (void)startUpLocation;

- (void)stopLocation;

@end

NS_ASSUME_NONNULL_END
