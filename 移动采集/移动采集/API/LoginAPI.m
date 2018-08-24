//
//  LoginAPI.m
//  trafficPolice
//
//  Created by hcat on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "LoginAPI.h"

#pragma mark - 登录API
@implementation LoginManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_LOGIN_LOGIN;
}

//请求参数
- (nullable id)requestArgument
{
    
    if (_orgId) {
        return @{@"openId":_openId,
                 @"orgId":_orgId
                 };
    }else{
        return @{@"openId":_openId
                 };
    }
    
}

//返回参数
- (NSString *)phone{
    
    if (self.responseModel.data) {
        _phone = self.responseModel.data[@"phone"];
        return _phone;
    }
    return nil;
}

- (NSString *)interfaceUrl{
    
    if (self.responseModel.data) {
        _interfaceUrl =  self.responseModel.data[@"interfaceUrl"];
        return _interfaceUrl;
    }
    return _interfaceUrl;
}

@end

#pragma mark - 登录发送验证码API

@implementation LoginTakeCodeManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_LOGIN_LOGINTAKECODE;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"openId":_openId};
}

//返回参数
- (NSString *)acId{
    
    if (self.responseModel.data) {
        return self.responseModel.data[@"acId"];
    }
    return nil;
}

@end

#pragma mark - 验证码登录API

@implementation LoginCheckParam

@end

@implementation LoginCheckManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_LOGIN_LOGINCHECK;
}

//请求参数
- (nullable id)requestArgument
{
    
    return self.param.modelToJSONObject;
}

//返回参数
- (UserModel *)userModel{
    
    if (self.responseModel.data) {
        _userModel = [UserModel modelWithDictionary:self.responseModel.data];
        return _userModel;
    }
    
    return nil;
}

@end

#pragma mark - 游客登录API


@implementation LoginVisitorManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_LOGIN_VISITOR;
}

//返回参数
- (UserModel *)userModel{
    
    if (self.responseModel.data) {
        _userModel = [UserModel modelWithDictionary:self.responseModel.data];
        return _userModel;
    }
    
    return nil;
}

@end


