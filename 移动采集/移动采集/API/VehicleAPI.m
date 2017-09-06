//
//  VehicleAPI.m
//  移动采集
//
//  Created by hcat on 2017/9/5.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "VehicleAPI.h"


@implementation VehicleDetailReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"vehicleRemarkList" : [VehicleRemarkModel class],
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
        return [VehicleDetailReponse modelWithDictionary:self.responseModel.data];
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
- (NSArray *)list{
    
    if (self.responseModel) {
        
        return [NSArray modelArrayWithClass:[VehicleGPSModel class] json:self.responseJSONObject[@"data"]];
    }
    
    return nil;
}


@end
