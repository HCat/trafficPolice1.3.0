//
//  ThroughManageAPIS.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/10.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ThroughManageAPIS.h"
#import "ImageFileInfo.h"

#import <AFNetworking.h>

#pragma mark - 违停采集增加API

@implementation ThroughManageSaveParam

//黑名单，不被转换
+ (NSArray *)modelPropertyBlacklist {
    return @[@"files"];
}

@end

@implementation ThroughManageSaveManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_THROUGHMANAGE_SAVE;
    
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


#pragma mark - 违反禁令查询是否需要二次采集API

@implementation ThroughManageCarNoSecReponse

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"illegalId" : @"id",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"illegalList" : [IllegalListModel class]
             };
}

@end


@implementation ThroughManageCarNoSecManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_THROUGHMANAGE_QUERYSEC;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"carNo": _carNo,
             @"roadId":_roadId
             };
}

//返回参数
- (ThroughManageCarNoSecReponse *)illegalReponse{
    
    if (self.responseModel.data) {
        return [ThroughManageCarNoSecReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}


@end

#pragma mark - 闯禁令违章车辆查询列表API

@implementation ThroughManageListPagingParam


@end


@implementation ThroughManageListPagingReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [IllegalParkListModel class]
             };
}

@end

@implementation ThroughManageListPagingManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_THROUGHMANAGE_LISTPAGING;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (ThroughManageListPagingReponse *)throughManageReponse{
    
    if (self.responseModel.data) {
        return [ThroughManageListPagingReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}


@end


#pragma mark - 车牌查询违章次数

@implementation ThroughManageCountCollectManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_THROUGHMANAGE_COUNTCOLLECT;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"carNo": _carNo
             };
}

//返回参数
- (NSNumber *)carNoNumber{
    
    if (self.responseModel.data) {
        _carNoNumber = self.responseModel.data;
        return _carNoNumber;
    }
    
    return nil;
}


@end


#pragma mark - 身份证位置次数查询

@implementation ThroughManageCountIdentNoManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_THROUGHMANAGE_COUNTIDENTNO;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"identNo": _identNo
             };
}

//返回参数
- (NSNumber *)identNoNumber{
    
    if (self.responseModel.data) {
        _identNoNumber = self.responseModel.data;
        return _identNoNumber;
    }
    
    return nil;
}

@end


@implementation ThroughManageSecSaveManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_THROUGHMANAGE_SECSAVE;
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

#pragma mark - 违反禁令采集详情API


@implementation ThroughManageDetailManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_THROUGHMANAGE_DETAIL;
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

