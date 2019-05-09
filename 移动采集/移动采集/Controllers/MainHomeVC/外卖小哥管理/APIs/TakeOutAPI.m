//
//  TakeOutAPI.m
//  移动采集
//
//  Created by hcat on 2019/5/8.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutAPI.h"

#pragma mark - 根据条件查询快递员列表API

@implementation TakeOutGetCourierListParam

@end

@implementation TakeOutGetCourierListReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [DeliveryCourierModel class]
             };
}

@end

@implementation TakeOutGetCourierListManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_TAKEOUT_GETCOURIERLIST;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (TakeOutGetCourierListReponse *)takeOutReponse{
    
    if (self.responseModel.data) {
        _takeOutReponse = [TakeOutGetCourierListReponse modelWithDictionary:self.responseModel.data];
        
    }
    
    return _takeOutReponse;
}

@end


#pragma mark - 查询快递员信息

@implementation TakeOutGetCourierInfoManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_TAKEOUT_GETCOURIERINFO;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_deliveryId};
}

//返回参数
- (DeliveryInfoModel *)takeOutReponse{
    
    if (self.responseModel.data) {
        _takeOutReponse =  [DeliveryInfoModel modelWithDictionary:self.responseModel.data];
        return _takeOutReponse;
        
    }
    
    return nil;
}


@end

#pragma mark - 查询车辆信息

@implementation TakeOutGetVehicleInfoManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_TAKEOUT_GETVEHICLEINFO;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_vehicleId};
}

//返回参数
- (DeliveryVehicleModel *)takeOutReponse{
    
    if (self.responseModel.data) {
        _takeOutReponse =  [DeliveryVehicleModel modelWithDictionary:self.responseModel.data];
        return _takeOutReponse;
        
    }
    
    return nil;
}

@end


#pragma mark - 违章记录列表

@implementation TakeOutReportPageManger

- (NSString *)requestUrl
{
    return URL_TAKEOUT_REPORTPAGE;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"driver":_deliveryId};
}


- (NSArray < DeliveryIllegalModel *> *)list{
    
    if (self.responseModel) {
        _list = [NSArray modelArrayWithClass:[DeliveryIllegalModel class] json:self.responseJSONObject[@"data"]];
        
        return _list;
    }
    
    return nil;
    
}

@end



#pragma mark - 快递小哥违章记录详情


@implementation TakeOutReportDetailManger

- (NSString *)requestUrl
{
    return URL_TAKEOUT_REPORTDETAIL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_reportId};
}

//返回参数
- (DeliveryIllegalDetailModel *)takeOutReponse{
    
    if (self.responseModel.data) {
        _takeOutReponse =  [DeliveryIllegalDetailModel modelWithDictionary:self.responseModel.data];
        return _takeOutReponse;
        
    }
    
    return nil;
}

@end

