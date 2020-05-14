//
//  StepNumberHelper.m
//  移动采集
//
//  Created by hcat on 2018/10/18.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "StepNumberHelper.h"

#import <CoreMotion/CoreMotion.h>

@interface StepNumberHelper ()

@property (nonatomic, strong) CMPedometer * pedonmeter;

@end


@implementation StepNumberHelper

LRSingletonM(Default)

- (instancetype)init{
    
    if (self = [super init]) {
        self.pedonmeter = [[CMPedometer alloc] init];
        self.stepNumber = @0;
        self.isRuning = NO;
    }
    
    return self;
}


- (void)startCountStep:(NSDate *)data{
    
    if ([CMPedometer isStepCountingAvailable]) {

        self.isRuning = YES;
        WS(weakSelf);
        
        //当你的步数有更新的时候，会触发这个方法，返回从某一时刻开始到现在所有的信息统计CMPedometerData。
        //其中CMPedometerData包含步数等信息，在下面使用的时候介绍。
        //值得一提的是这个方法不会实时返回结果，每次刷新数据大概一分钟左右。
        [self.pedonmeter startPedometerUpdatesFromDate:data withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            
            SW(strongSelf, weakSelf);
            strongSelf.stepNumber = pedometerData.numberOfSteps;
            
        }];
        
    } else {
        NSLog(@"设备不可用");
    }
 
}

- (void)stopCountStep{
    //停止收集计步信息

    if (self.isRuning == YES) {
        [self.pedonmeter stopPedometerUpdates];
        self.isRuning = NO;
    }
    
}

@end
