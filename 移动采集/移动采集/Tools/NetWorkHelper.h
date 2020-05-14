//
//  NetWorkHelper.h
//  移动采集
//
//  Created by hcat on 2017/7/18.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reachability/Reachability.h>

typedef void(^NetworkReconnectionBlock)(void);
typedef void(^NetworkUnconnectionBlock)(void);

@interface NetWorkHelper : NSObject

LRSingletonH(Default)

@property(nonatomic,strong) Reachability* reachability;

@property (nonatomic,copy) NetworkReconnectionBlock networkReconnectionBlock;
@property (nonatomic,copy) NetworkUnconnectionBlock networkUnconnectionBlock;

- (void)startNotification; //开始监听网络变化


@end
