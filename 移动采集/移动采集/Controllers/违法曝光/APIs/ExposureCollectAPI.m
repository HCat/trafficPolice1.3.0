//
//  ExposureCollectAPI.m
//  移动采集
//
//  Created by hcat on 2019/12/5.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ExposureCollectAPI.h"

#pragma mark - 临时工违章采集

@implementation ExposureCollectReportParam

//黑名单，不被转换
+ (NSArray *)modelPropertyBlacklist {
    return @[@"files"];
}

@end



@implementation ExposureCollectReportManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl{
    
    return URL_EXPOSURECOLLECT_REPORT;
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


#pragma mark - 违法类型列表

@implementation ExposureCollectTypeListManger

- (NSString *)requestUrl
{
    return URL_EXPOSURECOLLECT_TYPELIST;
}

- (NSArray < IllegalExposureIllegalTypeModel *> *)list{
    
    if (self.responseModel) {
        _list = [NSArray modelArrayWithClass:[IllegalExposureIllegalTypeModel class] json:self.responseJSONObject[@"data"]];
        
        return _list;
    }
    
    return nil;
    
}

@end


#pragma mark - 违停采集列表API

@implementation ExposureCollectListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"exposureCollectId" : @"id",
             };
}


@end

@implementation ExposureCollectListPagingParam

@end

@implementation ExposureCollectListPagingReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [ExposureCollectListModel class]
             };
}

@end

@implementation ExposureCollectListPagingManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_EXPOSURECOLLECT_LISTPAGING;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (ExposureCollectListPagingReponse *)exposureCollectListPagingReponse{
    
    if (self.responseModel.data) {
        return [ExposureCollectListPagingReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end


#pragma mark - 违法曝光详情API

@implementation ExposureCollectModel


@end


@implementation ExposureCollectDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pictureList" : [AccidentPicListModel class]
             };
}


@end


@implementation ExposureCollectDetailManger

- (NSString *)requestUrl
{
    return URL_EXPOSURECOLLECT_DETAIL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_exposureCollectId};
}

//返回参数
- (ExposureCollectDetailModel *)exposureCollectDetailModel{
    
    if (self.responseModel.data) {
        return [ExposureCollectDetailModel modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}


@end

