//
//  LoginAPI.h
//  trafficPolice
//
//  Created by hcat on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "UserModel.h"

#pragma mark - 登录API

@interface LoginManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * openId;           //实际是微信的unionid
@property (nonatomic, copy) NSString * orgId;           //机构编码

/****** 返回数据 ******/
@property (nonatomic, copy) NSString * phone;            //手机号码
@property (nonatomic, copy) NSString * interfaceUrl;     //返回的服务器地址

@end

#pragma mark - 登录发送验证码API

@interface LoginTakeCodeManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * openId; //实际是微信的unionid

/****** 返回数据 ******/
@property (nonatomic, copy) NSString * acId; //短信ID


@end

#pragma mark - 验证码登录API

@interface LoginCheckParam : NSObject

@property (nonatomic,copy) NSString * openId;        //实际是微信的unionid
@property (nonatomic,copy) NSString * acId;          //短信ID
@property (nonatomic,copy) NSString * authCode;      //验证码
@property (nonatomic,copy) NSString * equipmentId;   //设备ID
@property (nonatomic,copy) NSString * platform;      //设备平台

@end

@interface LoginCheckManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) LoginCheckParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) UserModel * userModel;  //用户

@end

#pragma mark - 游客登录API

@interface LoginVisitorManger : LRBaseRequest

/****** 返回数据 ******/
@property (nonatomic, strong) UserModel * userModel;  //用户

@end


#pragma mark - 手机登录API(19.03.28)

@interface LoginMobileReponse : NSObject

@property (nonatomic, copy) NSString * userId;                  //用户ID
@property (nonatomic, copy) NSString * interfaceUrl;            //返回的服务器地址
@property (nonatomic, copy) NSString * acId;                    //短信ID
@property (nonatomic, strong) NSNumber * codeLength;            //验证码长度
@property (nonatomic, strong) NSNumber * codeType;              //验证码类型

@end


@interface LoginMobileManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * mobile;          //手机号码
@property (nonatomic, copy) NSString * orgId;           //机构编码

/****** 返回数据 ******/

@property(nonatomic, strong) LoginMobileReponse * mobileModel;

@end


#pragma mark - 验证码登录API(19.03.28)

@interface LoginCheck2Param : NSObject

@property (nonatomic,copy) NSString * acId;          //短信ID
@property (nonatomic,copy) NSString * authCode;      //验证码
@property (nonatomic,copy) NSString * equipmentId;   //设备ID
@property (nonatomic,copy) NSString * platform;      //设备平台
@property (nonatomic, copy) NSString * userId;       //用户ID
@property (nonatomic, copy) NSString * mobile;       //手机号

@end

@interface LoginCheck2Manger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) LoginCheck2Param * param;

/****** 返回数据 ******/
@property (nonatomic, strong) UserModel * userModel;  //用户

@end

