//
//  DataStatisticsAPI.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/11/11.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "DataStatisticsAPI.h"

@implementation DataStatisticsReponse

@end



@implementation DataStatisticsManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_DATA_STATISTICS;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"accidentState":_accidentState};
}

//返回参数
- (DataStatisticsReponse *)dataStatisticsReponse{
    
    if (self.responseModel.data) {
        return [DataStatisticsReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}



@end


#pragma mark - 事件列表API

@implementation DataStatisticsListPagingParam

@end

@implementation DataStatisticsListPagingReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [AccidentListModel class]
            };
}

@end

@implementation DataStatisticsListPagingManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_DATA_LISTPAGING;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (DataStatisticsListPagingReponse *)accidentListPagingReponse{
    
    if (self.responseModel.data) {
        return [DataStatisticsListPagingReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end
