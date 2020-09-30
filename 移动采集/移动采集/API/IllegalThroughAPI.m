//
//  IllegalThroughAPI.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/21.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalThroughAPI.h"
#import "ImageFileInfo.h"
#import <AFNetworking.h>


#pragma mark - 违反禁令查询是否需要二次采集API


@implementation IllegalThroughCarNoSecReponse

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"illegalId" : @"id",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"illegalList" : [IllegalListModel class]
             };
}

@end


@implementation IllegalThroughCarNoSecManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALTHROUGH_CARNOSEC;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"carNo": _carNo,
             @"roadId":_roadId
             };
}

//返回参数

//返回参数
- (NSArray <IllegalListModel *>*)illegalList{
    
    if (self.responseModel) {
        
        _illegalList = [NSArray modelArrayWithClass:[IllegalListModel class] json:self.responseJSONObject[@"data"][@"illegalList"]];
        return _illegalList;
    }
    
    return nil;
}

- (NSString *)deckCarNo{
    
    if (self.responseModel) {
        _deckCarNo = self.responseModel.data[@"deckCarNo"];
        return _deckCarNo;
    }
    
    return nil;
}


//返回参数
- (IllegalThroughCarNoSecReponse *)illegalReponse{
    
    if (self.responseModel.data) {
        return [IllegalThroughCarNoSecReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 违反禁令采集增加API

@implementation IllegalThroughSaveManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALTHROUGH_SAVE;
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
        WS(weakSelf);
        return ^(NSProgress *progress){
            SW(strongSelf, weakSelf);
            if (!strongSelf.isUpCache) {
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
            }else{
                strongSelf.progress = 1.0 * progress.completedUnitCount / progress.totalUnitCount;
            }
            
        };
    }else{
        return nil;
    }
    
}

- (void)requestCompleteFilter{
    
    if (!self.isUpCache) {
        [super requestCompleteFilter];
    }else{
        self.responseModel = [LRBaseResponse modelWithDictionary:self.responseJSONObject];
        
        LxPrintf(@"======================= 请求成功 =======================");
        LxPrintf(@"\n");
        LxDBAnyVar(self.description);
        LxDBObjectAsJson(self.responseModel);
        LxPrintf(@"\n");
        LxPrintf(@"======================= end =======================");
        
        if (self.responseModel.code == CODE_NOLOGIN){
            
            [ShareFun loginOut];
            [LRShowHUD showError:@"登录超时" duration:1.2f];
            
        }
    }
    
}

- (void)requestFailedFilter {
    
    if (!self.isUpCache) {
        [super requestFailedFilter];
    }else{
        
        LxPrintf(@"======================= 请求失败 =======================");
        LxPrintf(@"\n");
        LxDBAnyVar(self.description);
        LxDBAnyVar(self.responseStatusCode);
        LxDBAnyVar(self.error.localizedDescription);
        LxPrintf(@"\n");
        LxPrintf(@"======================= end =======================");
        
        if (self.responseStatusCode == CODE_TOKENTIMEOUT){
            
            [ShareFun loginOut];
            
            [LRShowHUD showError:@"登录超时" duration:1.2f];
            
        }
    }
    
}


//返回参数

@end

#pragma mark - 违反禁令二次采集加载数据API

@implementation IllegalThroughSecAddManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALTHROUGH_SECADD;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id": _illegalThroughId};
}

//返回参数
- (IllegalThroughSecDetailModel *)illegalThroughSecDetailModel{
    
    if (self.responseModel.data) {
        return [IllegalThroughSecDetailModel modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 违反禁令二次采集保存数据API

@implementation IllegalThroughSecSaveParam

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"illegalThroughId" : @"id",
             };
}

//黑名单，不被转换
+ (NSArray *)modelPropertyBlacklist {
    return @[@"files"];
}

@end

@implementation IllegalThroughSecSaveManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALTHROUGH_SECSAVE;
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
        WS(weakSelf);
        return ^(NSProgress *progress){
            SW(strongSelf, weakSelf);
            if (!strongSelf.isUpCache) {
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
            }else{
                strongSelf.progress = 1.0 * progress.completedUnitCount / progress.totalUnitCount;
            }
            
        };
    }else{
        return nil;
    }
    
}

- (void)requestCompleteFilter{
    
    if (!self.isUpCache) {
        [super requestCompleteFilter];
    }else{
        self.responseModel = [LRBaseResponse modelWithDictionary:self.responseJSONObject];
        
        LxPrintf(@"======================= 请求成功 =======================");
        LxPrintf(@"\n");
        LxDBAnyVar(self.description);
        LxDBObjectAsJson(self.responseModel);
        LxPrintf(@"\n");
        LxPrintf(@"======================= end =======================");
        
        if (self.responseModel.code == CODE_NOLOGIN){
            
            [ShareFun loginOut];
            [LRShowHUD showError:@"登录超时" duration:1.2f];
            
        }
    }
    
}

- (void)requestFailedFilter {
    
    if (!self.isUpCache) {
        [super requestFailedFilter];
    }else{
        
        LxPrintf(@"======================= 请求失败 =======================");
        LxPrintf(@"\n");
        LxDBAnyVar(self.description);
        LxDBAnyVar(self.responseStatusCode);
        LxDBAnyVar(self.error.localizedDescription);
        LxPrintf(@"\n");
        LxPrintf(@"======================= end =======================");
        
        if (self.responseStatusCode == CODE_TOKENTIMEOUT){
            
            [ShareFun loginOut];
            
            [LRShowHUD showError:@"登录超时" duration:1.2f];
            
        }
    }
    
}


//返回参数

@end

#pragma mark - 违反禁令采集列表API

@implementation IllegalThroughListPagingParam

@end

@implementation IllegalThroughListPagingReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [IllegalParkListModel class]
             };
}

@end

@implementation IllegalThroughListPagingManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALTHROUGH_LISTPAGING;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (IllegalThroughListPagingReponse *)illegalThroughListPagingReponse{
    
    if (self.responseModel.data) {
        return [IllegalThroughListPagingReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 违反禁令采集详情API


@implementation IllegalThroughDetailManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALTHROUGH_DETAIL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_illegalThroughId};
}

//返回参数
- (IllegalParkDetailModel *)illegalDetailModel{
    
    if (self.responseModel.data) {
        return [IllegalParkDetailModel modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end


