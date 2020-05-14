//
//  StepNumberHelper.h
//  移动采集
//
//  Created by hcat on 2018/10/18.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StepNumberHelper : NSObject

LRSingletonH(Default)

@property (nonatomic,strong) NSNumber * stepNumber;
@property (nonatomic,assign) BOOL isRuning;

- (void)startCountStep:(NSDate *)data;

- (void)stopCountStep;


@end

NS_ASSUME_NONNULL_END
