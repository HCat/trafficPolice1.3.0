//
//  VehicleAPI.m
//  移动采集
//
//  Created by hcat on 2017/9/5.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "VehicleAPI.h"


@implementation VehicleImageModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"mediaId" : @"id",
             };
}

@end


@implementation VehicleDetailReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {

    return @{@"memberImgList" : [VehicleImageModel class],
             @"vehicleImgList" : [VehicleImageModel class],
             @"vehicleRemarkList" : [VehicleRemarkModel class],
             @"driverList" : [VehicleDriverModel class]
             };
}

@end


@implementation VehicleDetailByQrCodeManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VEHICLE_GETDETAILINFOBYQRCODE;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"qrCode":_qrCode};
}

//返回参数
- (VehicleDetailReponse *)vehicleDetailReponse{
    
    if (self.responseModel.data) {
        _vehicleDetailReponse =  [VehicleDetailReponse modelWithDictionary:self.responseModel.data];
        return _vehicleDetailReponse;
    }
    
    return nil;
}

@end



@implementation VehicleDetailByPlateNoManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VEHICLE_GETDETAILINFOBYPLATENO;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"plateNo":_plateNo};
}

//返回参数
- (VehicleDetailReponse *)vehicleDetailReponse{
    
    if (self.responseModel.data) {
        return [VehicleDetailReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end




@implementation VehicleRangeLocationManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VEHICLE_GETVEHICLERANGELOCATION;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"lng":_lng,
             @"lat":_lat,
             @"range":_range,
             @"carType":_carType};
}

//返回参数
- (NSArray *)vehicleGpsList{
    
    if (self.responseModel) {
        
        _vehicleGpsList = [NSArray modelArrayWithClass:[VehicleGPSModel class] json:self.responseJSONObject[@"data"][@"vehicleGpsList"]];
        return _vehicleGpsList;
    }
    
    return nil;
}


@end

@implementation VehicleLocationManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VEHICLE_GETVEHICLELOCATION;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"carType":_carType};
}

//返回参数
- (NSArray *)vehicleGpsList{
    
    if (self.responseModel) {
        
        _vehicleGpsList = [NSArray modelArrayWithClass:[VehicleGPSModel class] json:self.responseJSONObject[@"data"][@"vehicleGpsList"]];
        return _vehicleGpsList;
    }
    
    return nil;
}


@end

@implementation VehicleLocationByPlateNoManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VEHICLE_VEHICLELOCATIONBYPLATENO;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"plateNo":_plateNo};
}

//返回参数
- (VehicleGPSModel *)vehicleGPSModel{
    
    if (self.responseModel) {
        
        _vehicleGPSModel = [VehicleGPSModel modelWithDictionary:self.responseModel.data];
        return _vehicleGPSModel;
    }
    
    return nil;
}


@end

#pragma mark - 根据车牌id获取车辆报备信息

@implementation VehicleReportInfoReponse

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"mediaId" : @"id",
             };
}

@end

@implementation VehicleReportInfoManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VEHICLE_VEHICLEREPORTINFO;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"vehicleId":_vehicleId};
}

//返回参数
- (VehicleReportInfoReponse *)vehicleReportInfo{
    
    if (self.responseModel) {
        
        _vehicleReportInfo = [VehicleReportInfoReponse modelWithDictionary:self.responseModel.data];
        return _vehicleReportInfo;
    }
    
    return nil;
}

@end

#pragma mark - 更新车辆报备信息

@implementation VehicleUpReportInfoParam : NSObject

//黑名单，不被转换
+ (NSArray *)modelPropertyBlacklist {
    return @[@"imgFile"];
}

@end

@implementation VehicleUpReportInfoManger :LRBaseRequest

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VEHICLE_UPREPORTINFO;
}

//请求方式
- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

//上传图片
- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        
        if (self.param.imgFile) {
             [formData appendPartWithFileData:self.param.imgFile.fileData name:self.param.imgFile.name fileName:self.param.imgFile.fileName mimeType:self.param.imgFile.mimeType];
        }
        
    };
}

//上传进度
- (AFURLSessionTaskProgressBlock)uploadProgressBlock{
    
    if (self.param.imgFile) {
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
- (VehicleImageModel *)imageModel{
    
    if (self.responseModel) {
        
        _imageModel = [VehicleImageModel modelWithDictionary:self.responseModel.data];
        return _imageModel;
    }
    
    return nil;
}

@end

#pragma mark - 获取车辆列表

@implementation VehicleListModel

@end

@implementation VehicleGetVehicleListManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VEHICLE_VEHICLEGETVEHICLELIST;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"content" : _content,
             @"searchType" : _searchType
             };
}

//返回参数
- (NSArray <VehicleListModel *> *) vehicleList{
    
    if (self.responseModel) {
        
        _vehicleList = [NSArray modelArrayWithClass:[VehicleListModel class] json:self.responseJSONObject[@"data"][@"vehicleList"]];
        return _vehicleList;
    }
    
    return nil;
}

@end

#pragma mark - 获取车辆相关报警信息

@implementation VehicleAlarmRecordReponse

- (NSMutableArray <NSString *> *)arr_type{
    
    if (_arr_type == nil) {
        _arr_type = [NSMutableArray array];
        if (_areaSpeedAlarm) {
            [_arr_type addObject:NSStringFromClass([VehicleAreaAlarmModel class])];
        }
        
        if (_roadSpeedAlarm) {
            [_arr_type addObject:NSStringFromClass([VehicleRoadAlarmModel class])];
        }
        
        if (_fatigueAlarm) {
            [_arr_type addObject:NSStringFromClass([VehicleTiredAlarmModel class])];
        }
        
        if (_vehicleExpireAlarm) {
            [_arr_type addObject:NSStringFromClass([VehicleExpireAlarmModel class])];
        }
    }
    
    return _arr_type;
}

//黑名单，不被转换
+ (NSArray *)modelPropertyBlacklist {
    return @[@"arr_type"];
}

@end

@implementation VehicleAlarmRecordManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VEHICLE_VEHICLEALARMRECORD;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"vehicleId":_vehicleId};
}

//返回参数
- (VehicleAlarmRecordReponse *)vehicleAlarmRecord{
    
    if (self.responseModel) {
        
        _vehicleAlarmRecord = [VehicleAlarmRecordReponse modelWithDictionary:self.responseModel.data];
        return _vehicleAlarmRecord;
    }
    
    return nil;
}

@end

#pragma mark - 获取超速报警列表

@implementation VehicleSpeedAlarmModel

@end


@implementation VehicleSpeedAlarmListParam

@end

@implementation VehicleSpeedAlarmListReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [VehicleSpeedAlarmModel class]
             };
}

@end

@implementation VehicleSpeedAlarmListManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VEHICLE_VEHICLESPEEDALARMLIST;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (VehicleSpeedAlarmListReponse *)speedAlarmListReponse{
    
    if (self.responseModel.data) {
        return [VehicleSpeedAlarmListReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end


#pragma mark - 获取疲劳驾驶报警图片列表

@implementation VehicleTiredImageListParam

@end


@implementation VehicleTiredImageListManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VEHICLE_VEHICLETIREDIMAGELIST;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (NSArray <VehicleTiredImageModel *> *) imageList{
    
    if (self.responseModel) {
        
        _imageList = [NSArray modelArrayWithClass:[VehicleTiredImageModel class] json:self.responseJSONObject[@"data"][@"imageList"]];
        return _imageList;
    }
    
    return nil;
}

@end

#pragma mark - 车辆上报功能

@implementation VehicleCarlUpParam


//黑名单，不被转换
+ (NSArray *)modelPropertyBlacklist {
    return @[@"files"];
}

@end

@implementation VehicleCarlUpManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VEHICLE_CARUP;
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
        return  nil ;
        
    }
    
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数

@end

#pragma mark - 获取疲劳驾驶报警图片列表

@implementation VehicleCodeInfo

@end


@implementation VehicleGetCodeTypeManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VEHICLE_VEHICLEGETCODETYPE;
}

//请求参数
- (nullable id)requestArgument
{
    return nil;
}

//返回参数
- (NSArray <VehicleCodeInfo *> *) list{
    
    if (self.responseModel) {
        
        _list = [NSArray modelArrayWithClass:[VehicleCodeInfo class] json:self.responseJSONObject[@"data"]];
        return _list;
    }
    
    return nil;
}

@end


#pragma mark - 获取违法录入列表


@implementation VehicleUpCarListParam

@end

@implementation VehicleUpCarListReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [VehicleUpDetailModel class]
             };
}

@end

@implementation VehicleUpCarListManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VEHICLE_VEHICLEUPCARLIST;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (VehicleUpCarListReponse *)upCarListReponse{
    
    if (self.responseModel.data) {
        return [VehicleUpCarListReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end


#pragma mark - 违法录入详细信息

@implementation VehicleUpCarDetailManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VEHICLE_VEHICLEUPCARDETAILE;
}


//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_vehicleUpId
             };;
}

//返回参数
- (VehicleUpDetailModel *)detailReponse{
    
    if (self.responseModel.data) {
        return [VehicleUpDetailModel modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

#pragma mark - 获取有效路线接口

@implementation VehicleRouteAddressModel

@end

@implementation VehicleRouteDetailModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"routeDetentionList" : [VehicleRouteAddressModel class]
             };
}

@end

@implementation VehicleGetRouteApprovalManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_VEHICLE_VEHICLEGETROUTEAPPROVAL;
}


//请求参数
- (nullable id)requestArgument
{
    return @{@"vehicelId":_vehicleId
             };;
}

//返回参数
- (VehicleRouteDetailModel *)detailReponse{
    
    if (self.responseModel.data) {
        return [VehicleRouteDetailModel modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end






