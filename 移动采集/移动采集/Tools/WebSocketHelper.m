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
#import "SocketModel.h"
#import "UserModel.h"
#import "NSTimer+UnRetain.h"


#define CLOSEBYUSER 120


@interface WebSocketHelper ()<SRWebSocketDelegate>

@property (nonatomic,strong) NSTimer *time_upLocation;

@end


@implementation WebSocketHelper

LRSingletonM(Default)


- (instancetype)init{
    
    self = [super init];
    if (self) {
        _isOpen = NO;
    }
    
    return self;
    
}

#pragma mark - public

- (void)startServer{
    [self startConnect];
    
}

- (void)closeServer{
    [self closeConnect];
}

- (void)judgeNeedSeedLocation{
    
    NSTimeInterval intervalNow = 0;
    
    if([ShareValue sharedDefault].uptime){
        intervalNow = [[ShareValue sharedDefault].uptime timeIntervalSinceNow];
    }
    
    if ([UserModel getUserModel].workstate == YES || intervalNow > 0) {
        if ([BackgroundLocationHelper sharedDefault].isLocation == NO) {
            [[BackgroundLocationHelper sharedDefault] startLocation];
        }

        if (intervalNow > 0) {
            WS(weakSelf);
            if (self.time_upLocation) {
                LxPrintf(@"*********************服务器定时发送注销！*********************");
                [self.time_upLocation invalidate];
                self.time_upLocation = nil;
            }
            
            self.time_upLocation = [NSTimer lr_scheduledTimerWithTimeInterval:30.f repeats:YES block:^(NSTimer *timer) {
                
                SW(strongSelf, weakSelf);
                
                NSTimeInterval t_intervalNow = 0;
                
                if([ShareValue sharedDefault].uptime){
                    t_intervalNow = [[ShareValue sharedDefault].uptime timeIntervalSinceNow];
                }
                NSLog(@"%f",t_intervalNow);
                if (t_intervalNow < 0) {
                    if ([UserModel getUserModel].workstate == NO && [BackgroundLocationHelper sharedDefault].isLocation) {
                        [[BackgroundLocationHelper sharedDefault] stopLocation];
                    }
                    
                    if (strongSelf.time_upLocation) {
                        LxPrintf(@"*********************服务器定时发送注销！*********************");
                        [strongSelf.time_upLocation invalidate];
                        strongSelf.time_upLocation = nil;
                    }
                    
                }
                
            }];
            [[NSRunLoop currentRunLoop] addTimer:self.time_upLocation forMode:NSRunLoopCommonModes];
            [self.time_upLocation fire];
        }
        
    }else{
        
        if ([BackgroundLocationHelper sharedDefault].isLocation) {
            [[BackgroundLocationHelper sharedDefault] stopLocation];
        }
    
    }
    
    
    
}


#pragma mark - private 

- (void)startConnect{
    
    [self closeConnect];
    NSLog(@"%@",WEBSOCKETURL);
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
    LxPrintf(@"************ Websocket receivedMessage!***************");
    LxDBObjectAsJson(message);
    SocketModel *t_scoket = [SocketModel modelWithJSON:message];
    
    if ([t_scoket.msgType isEqualToNumber:@(WEBSOCKTETYPE_UPFREQUENCY)]) {
        NSString *str_frequency = (NSString *)t_scoket.message;
        [ShareValue sharedDefault].frequency = @(str_frequency.doubleValue);
        
        [self judgeNeedSeedLocation];
        
    }else if([t_scoket.msgType isEqualToNumber:@(WEBSOCKTETYPE_UPTIME)]){
        
        NSString *str_time = (NSString *)t_scoket.message;
        [ShareValue sharedDefault].uptime = [[NSDate date] dateByAddingTimeInterval:[str_time doubleValue]];
        [self judgeNeedSeedLocation];
    }
    

}


- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    LxPrintf(@"************ Websocket opend!***************");
    
    _isOpen = YES;
    //****************  webSocket开启的时候就开启后台定位，获取位置信息来上传 *****************//
    
    SocketModel *t_socketModel  = [[SocketModel alloc] init];
    t_socketModel.fromUserId = @([[UserModel getUserModel].userId integerValue]);
    t_socketModel.msgType = @(WEBSOCKTETYPE_POLICELOGININ);
    NSString *json_string = t_socketModel.modelToJSONString;
    [[WebSocketHelper sharedDefault].webSocket send:json_string];
    

}


- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    
    LxPrintf(@"************ Websocket fail!***************");
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self startServer];
//    });
    
}


- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{

    _isOpen = NO;
    if ([reason isEqualToString:@"closeBySignOut"]) {
        //****************  webSocket关闭的时候就关闭后台定位 *****************//
        [[BackgroundLocationHelper sharedDefault] stopLocation];
        if (self.time_upLocation) {
            LxPrintf(@"*********************服务器定时发送注销！*********************");
            [self.time_upLocation invalidate];
            self.time_upLocation = nil;
        }
        _webSocket.delegate = nil;
        _webSocket = nil;
        return;
    }

}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    LxPrintf(@"************ Websocket receivedpong!***************");
    
    
}


@end
