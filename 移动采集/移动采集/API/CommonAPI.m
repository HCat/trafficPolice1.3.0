//
//  CommonAPI.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "CommonAPI.h"
#import <AFNetworking.h>


#pragma mark - 获取当前天气API

@implementation CommonGetWeatherManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_COMMON_GETWEATHER;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"location":_location};
}

//返回参数
- (NSString *)weather{
    
    if (self.responseModel.data) {
        return self.responseModel.data[@"weather"];
    }
    
    return nil;
}

@end

#pragma mark - 证件识别API

@implementation CommonIdentifyResponse

@end

@implementation CommonIdentifyManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_COMMON_IDENTIFY;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"type":@(_type)};
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:self.imageInfo.fileData name:self.imageInfo.name fileName:self.imageInfo.fileName mimeType:self.imageInfo.mimeType];
    };
}

//返回参数
- (CommonIdentifyResponse *)commonIdentifyResponse{
    
    if (self.responseModel.data) {
        return [CommonIdentifyResponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 获取路名API

@implementation CommonGetRoadModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"getRoadId" : @"id",
             @"getRoadName" : @"name",
             };
}

@end

@implementation CommonGetRoadManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_COMMON_GETROAD;
}

//请求参数
- (nullable id)requestArgument
{
    return nil;
}

//返回参数
- (NSArray *)commonGetRoadResponse{
    
    if (self.responseModel) {
        return [NSArray modelArrayWithClass:[CommonGetRoadModel class] json:self.responseJSONObject[@"data"]];
    }
    
    return nil;
}

@end

#pragma mark - 获取图片轮播API

@implementation CommonGetImgPlayModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"getImgPlayTitle" : @"title",
             @"getImgPlayImgUrl" : @"imgUrl",
             @"getImgPlayUrl" : @"url",
             };
}

@end

@implementation CommonGetImgPlayManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_COMMON_GETIMGPLAY;
}

//请求参数
- (nullable id)requestArgument
{
    return nil;
}

//返回参数
- (NSArray *)commonGetImgPlayModel{
    
    if (self.responseModel) {
        
        return [NSArray modelArrayWithClass:[CommonGetImgPlayModel class] json:self.responseJSONObject[@"data"]];
    }
    
    return nil;
}

@end

#pragma mark - 版本更新API

@implementation CommonVersionUpdateModel

@end

@implementation CommonVersionUpdateManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_COMMON_VERSIONUPDATE;
}

//请求参数
- (nullable id)requestArgument
{
    return nil;
}

//返回参数
- (CommonVersionUpdateModel *)commonVersionUpdateModel{
    
    if (self.responseModel.data) {
         return [CommonVersionUpdateModel modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 投诉建议API

@implementation CommonAdviceManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_COMMON_ADVICE;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"msg":_msg};
}

//返回参数
//无返回参数

@end

@implementation CommonValidVisitorManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_COMMON_VALIDVISITOR;
}

@end




