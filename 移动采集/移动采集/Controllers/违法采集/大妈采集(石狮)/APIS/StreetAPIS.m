//
//  StreetAPIS.m
//  移动采集
//
//  Created by 黄芦荣 on 2021/4/2.
//  Copyright © 2021 Hcat. All rights reserved.
//

#import "StreetAPIS.h"
#import <AFNetworking.h>
#import "ImageFileInfo.h"


@implementation StreetSaveManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl{
    return URL_STREETILLEGAL_SAVE;
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

#pragma mark - 违章采集列表API

@implementation StreetListPagingParam

@end

@implementation StreetListPagingReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [IllegalParkListModel class]
             };
}

@end

@implementation StreetListPagingManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_STREETILLEGAL_LISTPAGING;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (StreetListPagingReponse *)illegalReponse{
    
    if (self.responseModel.data) {
        return [StreetListPagingReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end


@implementation StreetCarNoRecordReponse

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"illegalId" : @"id",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"illegalList" : [IllegalListModel class]
             };
}

@end

@implementation StreetCarNoRecordManger

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
- (StreetCarNoRecordReponse *)illegalReponse{
    
    if (self.responseModel.data) {
        return [StreetCarNoRecordReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end
