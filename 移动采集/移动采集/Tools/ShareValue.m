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

- (AccidentGetCodesResponse *)accidentCodes{

    if (!_accidentCodes) {
        
        WS(weakSelf);
        AccidentGetCodesManger *manger = [AccidentGetCodesManger new];
        manger.isNeedShowHud = NO;
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
        manger.isNeedShowHud = NO;
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


@end
