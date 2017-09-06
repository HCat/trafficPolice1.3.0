//
//  WebSocketHelper.m
//  移动采集
//
//  Created by hcat on 2017/9/5.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "WebSocketHelper.h"
#import "SRWebSocket.h"
#import "BackgroundLocationHelper.h"



#define CLOSEBYUSER 120


@interface WebSocketHelper ()<SRWebSocketDelegate>


@end


@implementation WebSocketHelper

LRSingletonM(Default)


#pragma mark - public

- (void)startServer{
    [self startConnect];
    
}

- (void)closeServer{
    [self closeConnect];
}

#pragma mark - private 

- (void)startConnect{
    
    [self closeConnect];
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:WEBSOCKETURL]]];
    _webSocket.delegate = self;
    [_webSocket open];

}

- (void)closeConnect{
    
    if (_webSocket) {
        [_webSocket closeWithCode:CLOSEBYUSER reason:@"closeBySignOut"];
    }
}

#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    
    
}


- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    LxPrintf(@"************ Websocket opend!***************");
    
    //****************  webSocket开启的时候就开启后台定位，获取位置信息来上传 *****************//
    
    [[BackgroundLocationHelper sharedDefault] startLocation];
    
}


- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    
    LxPrintf(@"************ Websocket fail!***************");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startServer];
    });
    
    
}


- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{

    if ([reason isEqualToString:@"closeBySignOut"]) {
        //****************  webSocket关闭的时候就关闭后台定位 *****************//
        [[BackgroundLocationHelper sharedDefault] stopLocation];
        _webSocket.delegate = nil;
        _webSocket = nil;
        return;
    }

}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    LxPrintf(@"************ Websocket receivedpong!***************");
    
    
}


@end
