//
//  IllegalParkAPI.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/21.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalParkAPI.h"
#import "ImageFileInfo.h"

#import <AFNetworking.h>

#pragma mark - 违停采集增加API

@implementation IllegalParkSaveParam

//黑名单，不被转换
+ (NSArray *)modelPropertyBlacklist {
    return @[@"files"];
}

@end

@implementation IllegalParkSaveManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    if ([self.param.type isEqualToNumber:@2002]) {
        return URL_CARINFOADD;
    }
    return URL_ILLEGALPARK_SAVE;
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

@end

#pragma mark - 违停采集列表API

@implementation IllegalParkListPagingParam

@end

@implementation IllegalParkListPagingReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [IllegalParkListModel class]
             };
}

@end

@implementation IllegalParkListPagingManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALPARK_LISTPAGING;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (IllegalParkListPagingReponse *)illegalParkListPagingReponse{
    
    if (self.responseModel.data) {
        return [IllegalParkListPagingReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 违停采集详情API


@implementation IllegalParkDetailManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALPARK_DETAIL;
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

#pragma mark - 违停、违法禁令上报异常API

@implementation IllegalParkReportAbnormalManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALPARK_REPORTABNORMAL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_illegalParkId};
}

//返回参数
//无返回数据

@end


#pragma mark - 查询是否有违停记录API(旧)

@implementation IllegalParkQueryRecordManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALPARK_QUERYRECORD;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"carNo": _carNo,
             @"roadId":_roadId,
             @"type":_type
             };
}

//返回参数


@end



#pragma mark - 查询是否有违停记录API(新)

@implementation IllegalListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"illegalId" : @"id",
             };
}


@end


@implementation IllegalParkCarNoRecordReponse

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"illegalId" : @"id",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"illegalList" : [IllegalListModel class]
             };
}

@end

@implementation IllegalParkCarNoRecordManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALPARK_CARNORECORD;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"carNo": _carNo,
             @"roadId":_roadId,
             @"type":_type
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
- (IllegalParkCarNoRecordReponse *)illegalReponse{
    
    if (self.responseModel.data) {
        return [IllegalParkCarNoRecordReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 查看违章详细信息

@implementation IllegalImageModel

@end

@implementation IllegalParkIllegalDetailResponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pictureList" : [IllegalImageModel class]
             };
}

@end

@implementation IllegalParkIllegalDetailManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALPARK_ILLEGALDETAIL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_illegalId};
}

- (IllegalParkIllegalDetailResponse *)illegalResponse{
    
    if (self.responseModel.data) {
       _illegalResponse = [IllegalParkIllegalDetailResponse modelWithDictionary:self.responseModel.data];
        return _illegalResponse;
    }
    
    return nil;
    
}


@end


#pragma mark - 违停、违法禁令上报异常

@implementation IllegalReportAbnormalParam

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"illegalId" : @"id",
             };
}

//黑名单，不被转换
+ (NSArray *)modelPropertyBlacklist {
    return @[@"files"];
}

@end


@implementation IllegalReportAbnormalManger

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

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGAL_REPORTABNORMAL;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}


@end

#pragma mark - 采集根据道路ID是否可以采集（设备重复采集问题）

@implementation IllegalCheckRoadCollectResponse



@end

@implementation IllegalCheckRoadCollectManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ILLEGALPARK_CHECKROADCOLLECT;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"roadId":_roadId};
}

- (IllegalCheckRoadCollectResponse *)illegalResponse{
    
    if (self.responseModel.data) {
        _illegalResponse = [IllegalCheckRoadCollectResponse modelWithDictionary:self.responseModel.data];
        
        return _illegalResponse;
    }
    
    return nil;
    
}



@end
