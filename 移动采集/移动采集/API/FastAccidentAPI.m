//
//  FastAccident.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/19.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "FastAccidentAPI.h"
#import "ImageFileInfo.h"
#import <AFNetworking.h>


#pragma mark - 获取交通事故通用值API


@implementation FastAccidentGetCodesManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_FASTACCIDENT_GETCODES;
}

//请求参数
- (nullable id)requestArgument
{
    return nil;
}

//返回参数
- (AccidentGetCodesResponse *)fastAccidentGetCodesResponse{
    
    if (self.responseModel.data) {
        return [AccidentGetCodesResponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 快处事故增加API

@implementation FastAccidentSaveManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_FASTACCIDENT_SAVE;
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
        for (ImageFileInfo *certFilesImage in self.param.certFiles){
            [formData appendPartWithFileData:certFilesImage.fileData name:certFilesImage.name fileName:certFilesImage.fileName mimeType:certFilesImage.mimeType];
        }
        
    };
}

//上传进度
- (AFURLSessionTaskProgressBlock)uploadProgressBlock{
    
    if (self.param.files.count > 0 || self.param.certFiles.count > 0) {
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
        
        return  nil ;
        
    }
}


//返回参数


@end


#pragma mark - 快处增加接口

@implementation FastAccidentUpManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_FASTACCIDENT_UP;
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
        for (ImageFileInfo *certFilesImage in self.param.certFiles){
            [formData appendPartWithFileData:certFilesImage.fileData name:certFilesImage.name fileName:certFilesImage.fileName mimeType:certFilesImage.mimeType];
        }
        
    };
}

//上传进度
- (AFURLSessionTaskProgressBlock)uploadProgressBlock{
    
    if (self.param.files.count > 0 || self.param.certFiles.count > 0) {
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



#pragma mark - 快处事件列表API

@implementation FastAccidentListPagingParam

@end

@implementation FastAccidentListPagingReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [AccidentListModel class]
             };
}

@end

@implementation FastAccidentListPagingManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_FASTACCIDENT_LISTPAGING;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (FastAccidentListPagingReponse *)fastAccidentListPagingReponse{
    
    if (self.responseModel.data) {
        return [FastAccidentListPagingReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end


#pragma mark - 快处事件详情API


@implementation FastAccidentDetailsManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_FASTACCIDENT_DETAILS;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_fastaccidentId};
}

//返回参数
- (AccidentDetailsModel *)fastAccidentDetailModel{
    
    if (self.responseModel.data) {
        _fastAccidentDetailModel = [AccidentDetailsModel modelWithDictionary:self.responseModel.data];
        return _fastAccidentDetailModel;
    }
    
    return nil;
}


@end


#pragma mark - 用户提交的快处信息

@implementation AccidentDisposePeopelModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"peopleId" : @"id",
             };
}

@end


@implementation FastAccidentDetailManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_FASTACCIDENT_PEOPLE;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_accidentId};
}


//返回参数
- (NSArray <AccidentDisposePeopelModel *> *)accidentFastPeopleModel{
    
    if (self.responseModel) {
        
        return [NSArray modelArrayWithClass:[AccidentDisposePeopelModel class] json:self.responseJSONObject[@"data"]];
    }
    
    return nil;
}


@end


#pragma mark - 处理用户提交的快处信息

@implementation FastAccidentDealAccidentParam

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"accidentId" : @"id",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"accidentInfoList" : [AccidentDisposePeopelModel class]
             };
}

@end



@implementation FastAccidentDealAccidentManger

////请求方式
//- (YTKRequestMethod)requestMethod
//{
//    return YTKRequestMethodPOST;
//}

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_FASTACCIDENT_DEALACCIDENT;
}

//请求参数
- (nullable id)requestArgument
{

    return @{@"accidentJson":_accidentJson};;
}


@end

#pragma mark - 是否有权限处理用户提交的快处信息


@implementation FastAccidentCheckPermissManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_FASTACCIDENT_CHECKPERMISS;
}


//返回参数
- (NSNumber *)hasPermiss{
    
    return self.responseModel.data[@"hasPermiss"];
    
}

@end

