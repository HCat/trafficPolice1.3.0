//
//  AddressBookAPI.m
//  移动采集
//
//  Created by hcat on 2017/10/18.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AddressBookAPI.h"

@implementation AddressBookGetListManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_ADDRESSBOOK_GETLIST;
}

//请求参数
- (nullable id)requestArgument
{
    return nil;
}


//返回参数
- (NSArray <AddressBookModel *> *)addressBookList{
    
    if (self.responseModel) {
        
        _addressBookList = [NSArray modelArrayWithClass:[AddressBookModel class] json:self.responseJSONObject[@"data"][@"list"]];
        return _addressBookList;
    }
    
    return nil;
}


@end

