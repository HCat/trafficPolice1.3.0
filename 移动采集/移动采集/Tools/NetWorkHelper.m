//
//  NetWorkHelper.m
//  移动采集
//
//  Created by hcat on 2017/7/18.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "NetWorkHelper.h"
#import "LSStatusBarHUD.h"


@interface NetWorkHelper()

@property(nonatomic,assign) NSInteger previousStatus;

@end


@implementation NetWorkHelper

LRSingletonM(Default)


- (void)startNotification{

    self.previousStatus = -1; //没有状态
    
    self.reachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [_reachability startNotifier];


}


#pragma mark - 网络改变监听

- (void)networkChanged:(NSNotification *)notification
{
    
    Reachability *reachability = (Reachability *)notification.object;
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (_previousStatus == -1) {
        _previousStatus = status;
    }else{
        if (status == _previousStatus) {
            return;
        }
    }
    
    LxPrintf(@"networkChanged, currentStatus:%@, previousStatus:%@", @(status), @(_previousStatus));
    
    if (status == NotReachable){
        
        [LSStatusBarHUD showMessageAndImage:@"当前无网络,请检查网络是否正常"];
    
        if (self.networkUnconnectionBlock) {
            self.networkUnconnectionBlock();
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NONETWORK_SUCCESS object:nil];
    
    }else{
        
        if (_previousStatus == NotReachable ) {
            
            if (self.networkReconnectionBlock) {
                self.networkReconnectionBlock();
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HAVENETWORK_SUCCESS object:nil];
            
        }
    }
    
    _previousStatus = status;
    
}




- (void)dealloc{

    LxPrintf(@"NetWorkHelper dealloc");

}

@end
