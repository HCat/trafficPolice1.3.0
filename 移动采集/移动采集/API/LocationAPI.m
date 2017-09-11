//
//  LocationAPI.m
//  移动采集
//
//  Created by hcat on 2017/9/11.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "LocationAPI.h"

@implementation LocationGetListManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_LOCATION_GETLIST;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"lng":_lng,
             @"lat":_lat,
             @"range":_range,
             };
}

//返回参数
- (NSArray <UserGpsListModel *> *)userGpsList{
    
    if (self.responseModel) {
        
        _userGpsList = [NSArray modelArrayWithClass:[UserGpsListModel class] json:self.responseJSONObject[@"data"][@"userGpsList"]];
        return _userGpsList;
    }
    
    return nil;
}

@end
