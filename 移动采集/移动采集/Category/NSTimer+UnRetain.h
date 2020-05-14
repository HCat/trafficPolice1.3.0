//
//  NSTimer+block.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/16.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer(LRUnRetain)

+ (NSTimer *)lr_scheduledTimerWithTimeInterval:(NSTimeInterval)inerval
                                       repeats:(BOOL)repeats
                                         block:(void(^)(NSTimer *timer))block;

@end
