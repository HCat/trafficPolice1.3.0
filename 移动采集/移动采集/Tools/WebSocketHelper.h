//
//  WebSocketHelper.h
//  移动采集
//
//  Created by hcat on 2017/9/5.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"
#import "WebSocketMacro.h"

@interface WebSocketHelper : NSObject

@property(nonatomic,strong) SRWebSocket *webSocket;

LRSingletonH(Default)

- (void)startServer;

- (void)closeServer;

@end
