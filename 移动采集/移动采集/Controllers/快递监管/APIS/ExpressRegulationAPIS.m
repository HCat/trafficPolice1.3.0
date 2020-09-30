//
//  ExpressRegulationAPIS.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/29.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ExpressRegulationAPIS.h"

#pragma mark - 根据条件查询快递员列表API

@implementation ExpressRegulationListItem

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"expressRegulationId" : @"id",
             };
}


@end



@implementation ExpressRegulationListParam

@end

@implementation ExpressRegulationListReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [ExpressRegulationListItem class]
             };
}

@end

@implementation ExpressRegulationListManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_EXPRESS_GETCOURIERLIST;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (ExpressRegulationListReponse *)takeOutReponse{
    
    if (self.responseModel.data) {
        _takeOutReponse = [ExpressRegulationListReponse modelWithDictionary:self.responseModel.data];
        
    }
    
    return _takeOutReponse;
}

@end


#pragma mark - 详情

@implementation ExpressRegulationDetailReponse



@end


@implementation ExpressRegulationDetailManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_EXPRESS_DETAIL;
}

//请求参数
- (nullable id)requestArgument
{
    
    if (_vehicleId) {
        return @{@"vehicleId":_vehicleId};
    }
    
    return nil;
    
}

//返回参数
- (ExpressRegulationDetailReponse *)takeOutReponse{
    
    if (self.responseModel.data) {
        return [ExpressRegulationDetailReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}



@end
