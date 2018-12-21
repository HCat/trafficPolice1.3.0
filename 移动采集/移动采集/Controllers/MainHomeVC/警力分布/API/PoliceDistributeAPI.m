//
//  PoliceDistributeAPI.m
//  移动采集
//
//  Created by hcat on 2018/12/19.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "PoliceDistributeAPI.h"

@implementation PoliceDistributeGetListParam


@end

@implementation PoliceDistributeGetListManger

- (NSString *)requestUrl{
    return URL_POLICE_GETLIST;
}

//请求参数
- (nullable id)requestArgument{
    return self.param.modelToJSONObject;
}

//返回参数
- (NSArray <PoliceLocationModel * > *)userGpsList{
    
    if (self.responseModel) {
        _userGpsList = [NSArray modelArrayWithClass:[PoliceLocationModel class] json:self.responseJSONObject[@"data"][@"userGpsList"]];
        return _userGpsList;
    }
    
    return nil;
}

@end

@implementation PoliceDistributeSendNoticeParam


@end

@implementation PoliceDistributeSendNoticeManger

- (NSString *)requestUrl{
    return URL_POLICE_SENDNOTICE;
}

//请求参数
- (nullable id)requestArgument{
    return self.param.modelToJSONObject;
}


@end

