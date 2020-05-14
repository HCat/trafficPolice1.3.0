//
//  ParkingManagementAPI.m
//  移动采集
//
//  Created by hcat on 2019/9/19.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingManagementAPI.h"

@implementation ParkingManageSearchListParam

@end

@implementation ParkingManageSearchListManger

- (NSString *)requestUrl{
    return URL_PARKINGMANAGE_SEARCHLIST;
}

//请求参数
- (nullable id)requestArgument{
    return self.param.modelToJSONObject;
}

//返回参数
- (NSArray <ParkingManageListModel * > *)resultList{
    
    if (self.responseModel) {
        _resultList = [NSArray modelArrayWithClass:[ParkingManageListModel class] json:self.responseJSONObject[@"data"][@"list"]];
        return _resultList;
    }
    
    return nil;
}


@end


