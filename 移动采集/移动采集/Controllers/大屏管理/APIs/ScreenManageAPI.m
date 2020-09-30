//
//  ScreenManageAPI.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/6/19.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ScreenManageAPI.h"

@implementation ScreenItemModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id" : @"id"};
}

@end

@implementation ScreenListParam

@end


@implementation ScreenListResponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [ScreenItemModel class]
            };
}


@end


@implementation ScreenListManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_SCREEN_LIST;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (ScreenListResponse *)screenresponse{
    
    if (self.responseModel.data) {
        return [ScreenListResponse modelWithDictionary:self.responseModel.data];
    }
    
    return nil;
}


@end


#pragma mark - 领取证件添加

@implementation ScreenAddManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl{
    
    return URL_SCREEN_ADD;
}

//请求参数
- (nullable id)requestArgument{
    
    if (_nameArr) {
        return @{@"nameArr":_nameArr
        };
    }else{
        return nil;
    }
    
}

@end


#pragma mark - 领取证件删除

@implementation ScreenDelManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_SCREEN_DEL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_Id
            };
}

@end

