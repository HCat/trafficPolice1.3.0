//
//  AddressBookModel.h
//  移动采集
//
//  Created by hcat on 2017/10/18.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBookModel : NSObject

@property (nonatomic,copy) NSString * userId;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * realName;
@property (nonatomic,copy) NSString * telNum;
@property (nonatomic,copy) NSString * deptName;
@property (nonatomic,copy) NSString * firstChar;
@property (nonatomic,assign) BOOL canDial;

@end
