//
//  LRBaseRequest.m
//  trafficPolice
//
//  Created by hcat on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "LRBaseRequest.h"

@interface LRBaseRequest()

@property(nonatomic,strong) LRShowHUD *hud;

@end


@implementation LRBaseRequest


-(id)init{

    if(self = [super init]){
        _isLog = YES;
        _isNeedShowHud = NO;
        _isNeedLoadHud = NO;
    
    };

    return self;
}

//可选，当使用缓存的时候，根据argument来过滤想要的缓存数据
- (id)cacheFileNameFilterForRequestArgument:(id)argument
{
    return argument;
}

//请求方式，默认为GET请求
- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}


//请求寄存器，默认为http
- (YTKRequestSerializerType)requestSerializerType
{
    if (_isNeedLoadHud) {
        self.hud = [LRShowHUD showWhiteLoadingWithText:_loadingMessage inView:_v_showHud config:nil];
    }
    return YTKRequestSerializerTypeHTTP;
}


//响应寄存器，默认JSON响应数据 详见 `responseObject`.
- (YTKResponseSerializerType)responseSerializerType
{
    return YTKResponseSerializerTypeJSON;
}


//缓存时间<使用默认的start，在缓存周期内并没有真正发起请求>
- (NSInteger)cacheTimeInSeconds
{
    return 0;
}

//请求超时时间
- (NSTimeInterval)requestTimeoutInterval
{
    return 60;
}

- (void)requestCompleteFilter{
    
    [super requestCompleteFilter];
    
    if (self.hud) {
        [self.hud hide];
    }
    
    self.responseModel = [LRBaseResponse modelWithDictionary:self.responseJSONObject];
    
    if (_isLog) {
        LxDBAnyVar(self.description);
        //LxDBObjectAsJson(self.responseJSONObject);
        LxDBObjectAsJson(self.responseModel);
    }
    
    if (self.responseModel.code == CODE_FAILED){
        
        if (_failMessage) {
            
            if (_failMessage.length != 0) {
                [LRShowHUD showError:_failMessage duration:1.2f inView:self.v_showHud];
            }
            
        }else{
            
            [LRShowHUD showError:self.responseModel.msg duration:1.2f inView:self.v_showHud];
        }
        
    }else if (self.responseModel.code == CODE_SUCCESS){
        //处理网络请求成功情况
        if (_isNeedShowHud) {
            
            if (_successMessage) {
                
                if (_successMessage.length != 0) {
                    [LRShowHUD showSuccess:_successMessage duration:1.2f inView:self.v_showHud];

                }
                
            }else{
                [LRShowHUD showSuccess:@"请求成功!" duration:1.2f inView:self.v_showHud];
            }
        }
        
    }else if (self.responseModel.code == CODE_NOLOGIN){
        
        [ShareFun LoginOut];
        [LRShowHUD showError:@"登录超时" duration:1.2f];
    
    }
    
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
    if (self.hud) {
        [self.hud hide];
    }
    
    if (_isLog) {
        
        LxDBAnyVar(self.description);
        LxDBAnyVar(self.responseStatusCode);
        LxDBAnyVar(self.error.localizedDescription);
        
    }
    
    if (self.responseStatusCode == CODE_TOKENTIMEOUT){
        
        [ShareFun LoginOut];
        
        [LRShowHUD showError:@"登录超时" duration:1.2f];
        
    }else{
        
        [LRShowHUD showError:[NSString stringWithFormat:@"网络请求错误:code-%ld",self.responseStatusCode] duration:1.2f inView:self.v_showHud];
    }

}

+ (void)setupRequestFilters:(NSDictionary *)arguments{
    //@{@"token": [ShareValue sharedDefault].token}
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    YTKUrlArgumentsFilter *urlFilter = [YTKUrlArgumentsFilter filterWithArguments:arguments];
    [config addUrlFilter:urlFilter];
}

+ (void)clearRequestFilters{
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    [config clearUrlFilter];

}

- (void)configLoadingTitle:(NSString *)title{
    
    _isNeedLoadHud = YES;
    _isNeedShowHud = YES;
    self.loadingMessage =  [NSString stringWithFormat:@"%@中..",title];
    self.successMessage =  [NSString stringWithFormat:@"%@成功",title];
    self.failMessage    =  [NSString stringWithFormat:@"%@失败",title];
}

@end
