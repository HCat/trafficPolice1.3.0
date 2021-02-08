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

#pragma mark - 

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

#pragma mark -

@implementation PoliceDistributeSearchParam

@end

@implementation PoliceDistributeSearchManger

- (NSString *)requestUrl{
    return URL_POLICE_SEARCH;
}

//请求参数
- (nullable id)requestArgument{
    return self.param.modelToJSONObject;
}

//返回参数
- (NSArray <PoliceLocationModel * > *)resultList{
    
    if (self.responseModel) {
        _resultList = [NSArray modelArrayWithClass:[PoliceLocationModel class] json:self.responseJSONObject[@"data"][@"resultList"]];
        return _resultList;
    }
    
    return nil;
}

//返回参数
- (NSArray <VehicleGPSModel * > *)carList{
    
    if (self.responseModel) {
        _carList = [NSArray modelArrayWithClass:[VehicleGPSModel class] json:self.responseJSONObject[@"data"][@"resultList"]];
        return _carList;
    }
    
    return nil;
}


@end


#pragma mark - 勤务管理列表

@implementation PoliceAnalyzeModel

@end


@implementation PoliceAnalyzeListParam

@end

@implementation PoliceAnalyzeListManger

- (NSString *)requestUrl{
    return URL_POLICE_ANALYZELIST;
}

//请求参数
- (nullable id)requestArgument{
    return self.param.modelToJSONObject;
}

//返回参数
- (NSArray <PoliceAnalyzeModel * > *)analyzeList{
    
    if (self.responseModel) {
        _analyzeList = [NSArray modelArrayWithClass:[PoliceAnalyzeModel class] json:self.responseJSONObject[@"data"][@"list"]];
        return _analyzeList;
    }
    
    return nil;
}


@end

#pragma mark - 获取签到列表


@implementation PoliceSignListParam

@end

@implementation PoliceSignListManger

- (NSString *)requestUrl{
    return URL_POLICE_USERSIGNLIST;
}

//请求参数
- (nullable id)requestArgument{
    return self.param.modelToJSONObject;
}

//返回参数
- (NSArray <SignModel * > *)signList{
    
    if (self.responseModel) {
        _signList = [NSArray modelArrayWithClass:[SignModel class] json:self.responseJSONObject[@"data"]];
        return _signList;
    }
    
    return nil;
}

@end


@implementation PoliceDistributeTotalListModel



@end



@implementation PoliceDistributeNewGetListManger


- (NSString *)requestUrl{
    return URL_POLICE_NEW_GETLIST;
}


//返回参数
- (NSArray <PoliceLocationModel * > *)userGpsList{
    
    if (self.responseModel) {
        _userGpsList = [NSArray modelArrayWithClass:[PoliceLocationModel class] json:self.responseJSONObject[@"data"][@"userGpsList"]];
        return _userGpsList;
    }
    
    return nil;
}


//返回参数
- (NSArray <PoliceDistributeTotalListModel * > *)totalList{
    
    if (self.responseModel) {
        _totalList = [NSArray modelArrayWithClass:[PoliceDistributeTotalListModel class] json:self.responseJSONObject[@"data"][@"totalList"]];
        return _totalList;
    }
    
    return nil;
}




@end
