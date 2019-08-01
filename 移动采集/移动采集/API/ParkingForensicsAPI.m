//
//  ParkingForensicsAPI.m
//  移动采集
//
//  Created by hcat on 2019/7/25.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingForensicsAPI.h"

@implementation ParkingForensicsListParam

@end

@implementation ParkingForensicsListReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [ParkingForensicsModel class]
             };
}


@end

@implementation ParkingForensicsListManger:LRBaseRequest

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_PARKINGFORENSICS_LIST;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (ParkingForensicsListReponse *)parkingReponse{
    
    if (self.responseModel.data) {
        _parkingReponse = [ParkingForensicsListReponse modelWithDictionary:self.responseModel.data];
        return _parkingReponse;
    }
    
    return nil;
}

@end

@implementation ParkingOccPercentListParam


@end

@implementation ParkingOccPercentListReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [ParkingOccPercentModel class]
             };
}

@end

@implementation ParkingOccPercentListManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_PARKINGOCCPERCENT_LIST;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (ParkingOccPercentListReponse *)parkingReponse{
    
    if (self.responseModel.data) {
        
        _parkingReponse = [ParkingOccPercentListReponse modelWithDictionary:self.responseModel.data];
        
        return _parkingReponse;
    }
    
    return nil;
}

@end


#pragma mark - 全部片区列表

@implementation ParkingAreaManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_PARKING_AREA;
}

- (NSArray *)list{

    if (self.responseModel) {
    
        return [NSArray modelArrayWithClass:[ParkingAreaModel class] json:self.responseJSONObject[@"data"]];
    }
    
    return nil;
}



@end



#pragma mark - 车位详情

@implementation ParkingAreaDetailManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_PARKINGAREA_DETAIL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"parkplaceId":_parkplaceId};
}


//返回参数
- (ParkingAreaDetailModel *)parkingReponse{
    
    if (self.responseModel.data) {
        
        _parkingReponse = [ParkingAreaDetailModel modelWithDictionary:self.responseModel.data];
        
        return _parkingReponse;
    }
    
    return nil;
}

@end


#pragma mark - 标记无车

@implementation ParkingRemarkCarStatusManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_PARKING_REMARKCARSTATUS;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"parkplaceId":_parkplaceId};
}

@end


#pragma mark - 停车取证

@implementation ParkingForensicsParam

//黑名单，不被转换
+ (NSArray *)modelPropertyBlacklist {
    return @[@"files"];
}

@end

@implementation ParkingForensicsManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl{
    
    return URL_PARKING_FORENSICS;
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
