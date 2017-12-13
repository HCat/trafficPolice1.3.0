//
//  IllOperationAPI.m
//  移动采集
//
//  Created by hcat on 2017/12/12.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "IllOperationAPI.h"

#pragma mark - 待监管车辆

@implementation IllOperationBeSupervisedManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_IllOPERATION_BESUPERVISED;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"carno":_carno};
}


@end


#pragma mark - 豁免车辆

@implementation IllOperationExemptCarnoManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_IllOPERATION_EXEMPTCARNO;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"carno":_carno};
}


@end

#pragma mark - 非法车辆详情

@implementation IllOperationCarDetail



@end

@implementation IllOperationDetailManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_IllOPERATION_DETAIL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_messageId};
}

//返回参数
- (IllOperationCarDetail *)illCarDetail{
    
    if (self.responseModel.data) {
        _illCarDetail = [IllOperationCarDetail modelWithDictionary:self.responseModel.data];
        return _illCarDetail;
    }
    
    return nil;
}


@end



