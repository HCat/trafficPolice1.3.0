//
//  AddressBookModel.h
//  移动采集
//
//  Created by hcat on 2017/10/18.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBookModel : NSObject

@property (nonatomic,copy) NSString * userId;       //用户id
@property (nonatomic,copy) NSString * name;         //用户名
@property (nonatomic,copy) NSString * realName;     //真实姓名
@property (nonatomic,copy) NSString * telNum;       //电话
@property (nonatomic,copy) NSString * deptName;     //中队名称
@property (nonatomic,copy) NSString * firstChar;    //首字母
@property (nonatomic,assign) BOOL canDial;          //是否有权限可以拨号









@end
