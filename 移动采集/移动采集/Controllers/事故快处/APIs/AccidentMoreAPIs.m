//
//  AccidentMoreAPIs.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/11/9.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "AccidentMoreAPIs.h"

#pragma mark - 车牌查询违章次数


@implementation AccidentMoreCountParam


@end


@implementation AccidentMoreCountManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ACCIDENTMORE_COUNT;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (NSNumber *)carNoNumber{
    
    if (self.responseModel.data) {
        _carNoNumber = self.responseModel.data;
        return _carNoNumber;
    }
    
    return nil;
}


@end

#pragma mark - 车牌查询违章查询列表API



@implementation AccidentMoreListPagingParam

@end


@implementation AccidentMoreListPagingReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [AccidentListModel class]
             };
}
@end

@implementation AccidentMoreListPagingManger:LRBaseRequest

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ACCIDENTMORE_LISTPAGING;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (AccidentMoreListPagingReponse *)accidentMoreReponse{
    
    if (self.responseModel.data) {
        return [AccidentMoreListPagingReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end

