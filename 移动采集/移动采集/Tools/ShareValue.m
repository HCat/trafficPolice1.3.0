//
//  ShareValue.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/16.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "ShareValue.h"

@implementation ShareValue

LRSingletonM(Default)

- (void)setServer_url:(NSString *)server_url{
    
    [[NSUserDefaults standardUserDefaults] setObject:server_url forKey:USERDEFAULT_KEY_SERVER_URL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString *)server_url{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_KEY_SERVER_URL];
    
}


- (void)setWebSocket_url:(NSString *)webSocket_url{
    
    [[NSUserDefaults standardUserDefaults] setObject:webSocket_url forKey:USERDEFAULT_KEY_WEBSOCKET_URL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString *)webSocket_url{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_KEY_WEBSOCKET_URL];
    
}




- (void)setToken:(NSString *)token{

    [[NSUserDefaults standardUserDefaults] setObject:token forKey:USERDEFAULT_KEY_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString *)token{

    return [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_KEY_TOKEN];

}

- (void)setPhone:(NSString *)phone{
    
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:USERDEFAULT_KEY_PHONE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString *)phone{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_KEY_PHONE];
    
}

- (void)setDutyTip:(BOOL)dutyTip{
    [[NSUserDefaults standardUserDefaults] setBool:dutyTip forKey:USERDEFAULT_KEY_DUTY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)dutyTip{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_DUTY];
}

- (void)setActionTip:(BOOL)actionTip{
    [[NSUserDefaults standardUserDefaults] setBool:actionTip forKey:USERDEFAULT_KEY_ACTION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)actionTip{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_KEY_ACTION];
}

- (void)setUptime:(NSDate *)uptime{
    [[NSUserDefaults standardUserDefaults] setObject:uptime forKey:USERDEFAULT_KEY_UPTIME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate *)uptime{
    return [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_KEY_UPTIME];
}

- (void)setUpStepTime:(NSDate *)upStepTime{
    [[NSUserDefaults standardUserDefaults] setObject:upStepTime forKey:USERDEFAULT_KEY_UPSTEPTIME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate *)upStepTime{
    return [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_KEY_UPSTEPTIME];
}





- (AccidentGetCodesResponse *)accidentCodes{

    if (!_accidentCodes) {
        
        WS(weakSelf);
        AccidentGetCodesManger *manger = [AccidentGetCodesManger new];
        manger.isLog = NO;
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf, weakSelf);
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                strongSelf.accidentCodes = manger.accidentGetCodesResponse;
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
        
    }
    
    return _accidentCodes;

}

- (NSArray <CommonGetRoadModel *>*)roadModels{

    
    if (!_roadModels) {
        
        WS(weakSelf);
        CommonGetRoadManger *manger = [[CommonGetRoadManger alloc] init];
        manger.isLog = NO;
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf, weakSelf);
            if (manger.responseModel.code == CODE_SUCCESS) {
                strongSelf.roadModels = manger.commonGetRoadResponse;
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }
    
    return _roadModels;

}

- (NSArray <DeliveryCompanyModel *> *)deliveryCompanyList{
    
    if (!_deliveryCompanyList) {
        
        WS(weakSelf);
        TakeOutCompanyListManger *manger = [[TakeOutCompanyListManger alloc] init];
        //manger.isLog = NO;
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf, weakSelf);
            if (manger.responseModel.code == CODE_SUCCESS) {
                strongSelf.deliveryCompanyList = manger.list;
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }
    
    return _deliveryCompanyList;
    
}

- (NSInteger)makeNumber{
    //LxPrintf(@"推送消息数目：%ld",(long)[UIApplication sharedApplication].applicationIconBadgeNumber);
    return [UIApplication sharedApplication].applicationIconBadgeNumber;
}

- (void)setMakeNumber:(NSInteger)makeNumber{
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = makeNumber;
    if (makeNumber == 0) {
        [JPUSHService resetBadge];
    }else{
        [JPUSHService setBadge:makeNumber];
    }
    
}


@end
