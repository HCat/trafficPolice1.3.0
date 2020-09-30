//
//  MainAPI.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/10.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "LRBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN



#pragma mark - 常用个人应用菜单

@interface PoliceMenuListModel : NSObject

@property (nonatomic,copy) NSString * menuListId;   //
@property (nonatomic,copy) NSString * policeId;     //
@property (nonatomic,copy) NSString * menuCode;     //
@property (nonatomic,copy) NSString * menuName;
@property (nonatomic,copy) NSNumber * createTime;   //
@property (nonatomic,copy) NSString * menuIcon;     //
@property (nonatomic,strong) NSNumber * t_template; //
@property (nonatomic,copy) NSString * url;     //
@end


@interface MainPoliceMenuListManger : LRBaseRequest

/****** 返回数据 ******/
@property (nonatomic, copy) NSArray<PoliceMenuListModel * > * mainResponse; //路名信息

@end

#pragma mark - app个人信息头像

@interface MainLoginCheckManger : LRBaseRequest

/****** 返回数据 ******/
@property (nonatomic, copy) NSString * photoUrl; //用户头像

@end


#pragma mark - 机构全部菜单

@interface MenuInfoModel : NSObject

@property (nonatomic, copy) NSString * menuCode;
@property (nonatomic, strong) NSNumber * isOrg;
@property (nonatomic, copy) NSString * menuName;
@property (nonatomic, copy) NSString * menuType;
@property (nonatomic, strong) NSNumber * isActive;
@property (nonatomic, strong) NSNumber * isUser;
@property (nonatomic, strong) NSNumber * t_template;    //0 网址 1 晋江 2石狮
@property (nonatomic, copy) NSString * url;    //
@property (nonatomic, copy) NSString * current;    //1 后台常用应用  不可去掉
@property (nonatomic,copy) NSString * menuIcon;     //

@end

@interface MainGetMenuInfoManger : LRBaseRequest

@property (nonatomic, copy) NSString * menuType;

/****** 返回数据 ******/
@property (nonatomic, copy) NSArray<MenuInfoModel * > * mainResponse; //路名信息



@end


#pragma mark - 保存个人常用菜单

@interface MainGetMenuInfoSaveManger : LRBaseRequest

@property (nonatomic, copy) NSString * menuListArr;


@end

#pragma mark - 菜单类型列表

@interface MenuTypeModel : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * type;

@end

@interface MainMenuTypeManger : LRBaseRequest

/****** 返回数据 ******/
@property (nonatomic, copy) NSArray<MenuTypeModel * > * mainResponse; //路名信息


@end




NS_ASSUME_NONNULL_END
