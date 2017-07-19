//
//  VideoColectAPI.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/21.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "VideoColectAPI.h"
#import <AFNetworking.h>

#pragma mark - 警情反馈采集增加API

@implementation VideoColectSaveParam

//黑名单，不被转换
+ (NSArray *)modelPropertyBlacklist {
    return @[@"file",@"preview"];
}


@end

@implementation VideoColectSaveManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VIDEOCOLECT_SAVE;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//请求方式
- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

//上传图片
- (AFConstructingBlock)constructingBodyBlock {
    
    return ^(id<AFMultipartFormData> formData) {
        
       [formData appendPartWithFileData:self.param.file.fileData name:self.param.file.name fileName:self.param.file.fileName mimeType:self.param.file.mimeType];
        
       [formData appendPartWithFileData:self.param.preview.fileData name:self.param.preview.name fileName:self.param.preview.fileName mimeType:self.param.preview.mimeType];
    };
}


@end

#pragma mark - 警情反馈采集列表API

@implementation VideoColectListPagingParam

@end

@implementation VideoColectListPagingReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [VideoColectListModel class]
             };
}

@end

@implementation VideoColectListPagingManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VIDEOCOLECT_LISTPAGING;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (VideoColectListPagingReponse *)videoColectListPagingReponse{
    
    if (self.responseModel.data) {
        return [VideoColectListPagingReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 警情反馈采集详情API

@implementation VideoColectDetailManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VIDEOCOLECT_DETAIL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"start":_start};
}

//返回参数
//无返回数据

@end

