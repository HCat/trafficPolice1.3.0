//
//  JointLawAPI.m
//  移动采集
//
//  Created by hcat on 2017/12/28.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "JointLawAPI.h"

#pragma mark - 事故增加API

@implementation JointLawSaveParam

@end

@implementation JointLawSaveManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_JOINTLAW_SAVE;
}

//请求方式
- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数

@end

#pragma mark - 违法条例列表

@implementation JointLawIllegalCodeModel

@end

@implementation JointLawGetIllegalCodeListManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_JOINTLAW_GETILLEGALCODELIST;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"launchOrgType":_launchOrgType};
}


//返回参数
- (NSArray *)list{
    
    if (self.responseModel) {
        
        return [NSArray modelArrayWithClass:[JointLawIllegalCodeModel class] json:self.responseJSONObject[@"data"]];
    }
    
    return nil;
}

@end

@implementation JointLawImageModel

@end

@implementation JointLawImgUploadManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_JOINTLAW_IMGUPLOAD;
}

//请求方式
- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

//上传图片
- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        
        for (ImageFileInfo *filesImage in self.files){
            [formData appendPartWithFileData:filesImage.fileData name:filesImage.name fileName:filesImage.fileName mimeType:filesImage.mimeType];
        }
    
        
    };
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"oldImgIds":[_oldImgIds modelToJSONObject]};
}

//返回参数

- (NSArray *)list{
    
    if (self.responseModel) {
        
        return [NSArray modelArrayWithClass:[JointLawImageModel class] json:self.responseJSONObject[@"data"]];
    }
    
    return nil;
}


@end


