//
//  IllegalAPI.m
//  移动采集
//
//  Created by hcat-89 on 2020/2/13.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "IllegalAPI.h"
#import <AFNetworking.h>
#import "ImageFileInfo.h"


@implementation IllegalSaveParam

//黑名单，不被转换
+ (NSArray *)modelPropertyBlacklist {
    return @[@"files"];
}

@end

@implementation IllegalSaveManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl{
    return URL_ILLEGAL_SAVE;
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
        for (ImageFileInfo *filesImage in self.param.files){
            [formData appendPartWithFileData:filesImage.fileData name:filesImage.name fileName:filesImage.fileName mimeType:filesImage.mimeType];
        }

    };
}

//上传进度
- (AFURLSessionTaskProgressBlock)uploadProgressBlock{

    if (self.param.files.count > 0) {
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


@end

#pragma mark - 违反禁令查询是否需要二次采集API

@implementation IllegalCarNoSecReponse

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"illegalId" : @"id",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"illegalList" : [IllegalListModel class]
             };
}

@end


@implementation IllegalCarNoSecManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGAL_QUERYSEC;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"carNo": _carNo,
             @"roadId":_roadId
             };
}

//返回参数
- (IllegalCarNoSecReponse *)illegalReponse{
    
    if (self.responseModel.data) {
        return [IllegalCarNoSecReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}


@end

#pragma mark - 违反禁令二次采集加载数据API

@implementation IllegalSecDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pictures" : [AccidentPicListModel class]
             };
}

@end

@implementation IllegalSecLoadManger


- (NSString *)requestUrl{
    return URL_ILLEGAL_SECLOAD;
}

//请求参数
- (nullable id)requestArgument{
    return @{@"id": _illegalId};
}

//返回参数
- (IllegalSecDetailModel *)illegalSecDetailModel{
    
    if (self.responseModel.data) {
        return [IllegalSecDetailModel modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 违反禁令二次采集保存数据API

@implementation IllegalSecAddParam

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"illegalId" : @"id",
             };
}

//黑名单，不被转换
+ (NSArray *)modelPropertyBlacklist {
    return @[@"files"];
}

@end

@implementation IllegalSecAddManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGAL_SECADD;
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



@end


#pragma mark - 违章采集列表API

@implementation IllegalListPagingParam

@end

@implementation IllegalListPagingReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [IllegalParkListModel class]
             };
}

@end

@implementation IllegalListPagingManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGAL_LISTPAGING;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (IllegalListPagingReponse *)illegalReponse{
    
    if (self.responseModel.data) {
        return [IllegalListPagingReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end


#pragma mark - 违章采集详情API


@implementation IllegalAddDetailManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGAL_DETAIL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_illegalParkId};
}

//返回参数
- (IllegalParkDetailModel *)illegalDetailModel{
    
    if (self.responseModel.data) {
        return [IllegalParkDetailModel modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 确认异常API


@implementation IllegalMakeSureAbnormalManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGAL_CONFIRMABNORMAL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_illegalParkId};
}

@end

