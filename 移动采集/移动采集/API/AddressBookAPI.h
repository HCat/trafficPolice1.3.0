//
//  AddressBookAPI.h
//  移动采集
//
//  Created by hcat on 2017/10/18.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "AddressBookModel.h"

@interface AddressBookGetListManger:LRBaseRequest

/****** 请求数据 ******/

/****** 返回数据 ******/
@property (nonatomic, strong) NSArray <AddressBookModel *> * addressBookList;


@end
