//
//  NSTimer+block.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/16.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "NSTimer+UnRetain.h"

@implementation NSTimer(LRUnRetain)
+ (NSTimer *)lr_scheduledTimerWithTimeInterval:(NSTimeInterval)inerval
                                       repeats:(BOOL)repeats
                                         block:(void(^)(NSTimer *timer))block{


    return [NSTimer scheduledTimerWithTimeInterval:inerval target:self selector:@selector(lr_blcokInvoke:) userInfo:[block copy] repeats:repeats];

}

+ (void)lr_blcokInvoke:(NSTimer *)timer{

    void (^block)(NSTimer *timer) = timer.userInfo;
    if (block) {
        block(timer);
    }

}



@end
