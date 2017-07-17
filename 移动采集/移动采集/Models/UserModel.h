//
//  UserModel.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

#define kPersonInfoPath [KDocumentPath stringByAppendingPathComponent:@"userModel.archiver"]


@interface UserModel : BaseModel

@property (nonatomic,copy) NSString *token;         //token
@property (nonatomic,copy) NSString * userId;       //用户Id
@property (nonatomic,copy) NSString * phone;        //用户手机
@property (nonatomic,copy) NSString * name;         //用户名
@property (nonatomic,copy) NSString * nickName;     //昵称
@property (nonatomic,copy) NSString * realName;     //真实姓名
@property (nonatomic,assign) BOOL isInsurance;      //是否保险人员 0否 1是
@property (nonatomic,copy) NSArray *menus;          //可操作的菜单列表

/******** menus ********
 有权限的菜单编码值，参考下面的编码值，数组类型
 菜单编码：
 
 "ACCIDENT_LIST",
 "FASTACC_LIST",
 "ILLEGAL_LIST",
 "THROUGH_LIST",
 "VIDEO_COLLECT_LIST"
 
 "NORMAL_ACCIDENT_ADD",
 "FAST_ACCIDENT_ADD",
 "ILLEGAL_PARKING",
 "ILLEGAL_THROUGH",
 "VIDEO_COLLECT",
*/


//归档
+ (void)setUserModel:(UserModel *)model;

//解档
+ (UserModel *)getUserModel;

//获取列表权限
+ (BOOL)isPermissionForAccidentList;        //事故权限
+ (BOOL)isPermissionForFastAccidentList;    //快处权限
+ (BOOL)isPermissionForIllegalList;         //违章权限
+ (BOOL)isPermissionForThroughList;         //闯禁令权限
+ (BOOL)isPermissionForVideoCollectList;    //视频录入权限
 
@end
