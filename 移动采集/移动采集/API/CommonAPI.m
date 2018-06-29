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
- (WeatherModel *)weather{
    
    if (self.responseModel.data) {
        _weather =  [WeatherModel modelWithDictionary:self.responseModel.data];
        return _weather;
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

- (NSTimeInterval)requestTimeoutInterval
{
    if (_type == 1) {
        return 5.f;
    }else{
        return 30.f;
    }
    
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
        _commonIdentifyResponse = [CommonIdentifyResponse modelWithDictionary:self.responseModel.data];
        return _commonIdentifyResponse;
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
- (NSArray <CommonGetRoadModel * > *)commonGetRoadResponse{
    
    if (self.responseModel) {
        _commonGetRoadResponse = [NSArray modelArrayWithClass:[CommonGetRoadModel class] json:self.responseJSONObject[@"data"]];
        return _commonGetRoadResponse;
    }
    
    return nil;
}

@end

#pragma mark - 获取警员群组API

@implementation CommonGetGroupListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"getGroupId" : @"id",
             @"getGroupName" : @"name",
             };
}

@end

@implementation CommonGetGroupListManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_COMMON_GETGROUPLIST;
}

//请求参数
- (nullable id)requestArgument
{
    return nil;
}

//返回参数
- (NSArray<CommonGetGroupListModel *> *)commonGetGroupListResponse{
    
    if (self.responseModel) {
        _commonGetGroupListResponse = [NSArray modelArrayWithClass:[CommonGetGroupListModel class] json:self.responseJSONObject[@"data"]];
        return _commonGetGroupListResponse;
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
- (NSArray<CommonGetImgPlayModel *> *)commonGetImgPlayModel{
    
    if (self.responseModel) {
        _commonGetImgPlayModel = [NSArray modelArrayWithClass:[CommonGetImgPlayModel class] json:self.responseJSONObject[@"data"]];
        return _commonGetImgPlayModel;
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
    return @{@"appType":_appType};
}

//返回参数
- (CommonVersionUpdateModel *)commonVersionUpdateModel{
    
    if (self.responseModel.data) {
        _commonVersionUpdateModel = [CommonVersionUpdateModel modelWithDictionary:self.responseModel.data];
        return _commonVersionUpdateModel;
    }
    
    return nil;
}

@end

#pragma mark - 投诉建议API

@implementation CommonAdviceParam

//黑名单，不被转换
+ (NSArray *)modelPropertyBlacklist {
    return @[@"files"];
}

@end


@implementation CommonAdviceManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_COMMON_ADVICE;
}

//请求方式
- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

//上传图片
- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        for (ImageFileInfo *filesImage in self.param.files){
            [formData appendPartWithFileData:filesImage.fileData name:filesImage.name fileName:filesImage.fileName mimeType:filesImage.mimeType];
        }
        
    };
}

//上传进度
- (AFURLSessionTaskProgressBlock)uploadProgressBlock{
    
    if (self.param.files.count > 0) {
        self.isNeedLoadHud = NO;
        return ^(NSProgress *progress){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIWindow * window = [[UIApplication sharedApplication] keyWindow];
                DMProgressHUD *hud = [DMProgressHUD progressHUDForView:window];
                if (hud == nil) {
                    hud = [DMProgressHUD showHUDAddedTo:window animation:DMProgressHUDAnimationGradient maskType:DMProgressHUDMaskTypeClear];
                    hud.mode = DMProgressHUDModeProgress;
                    hud.style = DMProgressHUDStyleDark;
                    hud.text = @"正在上传...";
                }
                hud.progress = 1.0 * progress.completedUnitCount / progress.totalUnitCount;
                
            });
            
        };
        
    }else{

        return nil;
    }
    
    
}


//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
//无返回参数

@end

#pragma mark - 查询是否需要游客登录API

@implementation CommonValidVisitorManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_COMMON_VALIDVISITOR;
}

@end

#pragma mark - 警务详情公告
@implementation CommonPoliceAnounceManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_COMMON_POLICEANOUNCE;
}

- (BOOL)swicth{
    if (self.responseModel) {
        _swicth = self.responseJSONObject[@"data"][@"swicth"];
    }
    
    return _swicth;
}

- (NSString *)content{
    
    if (self.responseModel) {
        _content = self.responseJSONObject[@"data"][@"content"];
    }
    
    return _content;
}


@end



