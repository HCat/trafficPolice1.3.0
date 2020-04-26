//
//  ElectronicPoliceAPI.m
//  移动采集
//
//  Created by hcat-89 on 2020/4/24.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ElectronicPoliceAPI.h"

@implementation ElectronicPoliceTypeManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ELECTRONIC_TYPE;
}

- (NSArray *)list{

    if (self.responseModel) {
    
        return _list = [NSArray modelArrayWithClass:[ElectronicTypeModel class] json:self.responseJSONObject[@"data"]];
    }
    
    return nil;
}

@end


@implementation ElectronicPoliceListManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ELECTRONIC_LIST;
}

- (nullable id)requestArgument
{
    return @{@"cameraType":_cameraType
            };
}

- (NSArray *)list{

    if (self.responseModel) {
    
        return _list = [NSArray modelArrayWithClass:[ElectronicDetailModel class] json:self.responseJSONObject[@"data"]];
    }
    
    return nil;
}


@end
