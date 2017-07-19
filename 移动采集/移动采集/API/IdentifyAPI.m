//
//  MessageAPI.m
//  trafficPolice
//
//  Created by hcat on 2017/7/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IdentifyAPI.h"

#pragma mark - 消息列表

@implementation IdentifyMsgListParam

@end


@implementation IdentifyMsgListReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [IdentifyModel class]
             };
}

@end


@implementation IdentifyMsgListManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_IDENTIFY_LIST;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (IdentifyMsgListReponse *)identifyMsgListReponse{
    
    if (self.responseModel.data) {
        return [IdentifyMsgListReponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}

@end


#pragma mark - 确认接收消息

@implementation IdentifySetMsgReadManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_IDENTIFY_MSGREAD;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_msgId};
}

@end


