//
//  SignAPI.m
//  移动采集
//
//  Created by hcat on 2017/9/4.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "SignAPI.h"


#pragma mark - 签到

@implementation SignManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_SIGN;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"address":_address,
             @"longitude":_longitude,
             @"latitude":_latitude
             };
}

@end



#pragma mark - 签退

@implementation SignOutManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_SIGNOUT;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"address":_address,
             @"longitude":_longitude,
             @"latitude":_latitude
             };
}

@end


#pragma mark - 签到列表

@implementation SignListReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [SignModel class]
             };
}

@end

@implementation SignListManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_SIGN_LIST;
}

//请求参数
- (nullable id)requestArgument
{
    return nil;
}

//返回参数
- (SignListReponse *)signListReponse{
    
    if (self.responseModel.data) {
        return [SignListReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end


