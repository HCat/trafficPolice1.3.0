//
//  ShareValue.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/16.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRSingleton.h"
#import "AccidentAPI.h"
#import "CommonAPI.h"

#define kmaxPreviewCount 30
#define kmaxSelectCount 30


typedef NS_ENUM(NSInteger, AccidentType) {
    AccidentTypeAccident,       //事故
    AccidentTypeFastAccident,   //快处
};

typedef NS_ENUM(NSInteger, IllegalType) {
    IllegalTypePark,        //违停
    IllegalTypeThrough,     //闯禁令
};

typedef NS_ENUM(NSUInteger, ParkType) {
    ParkTypePark = 1,               //违停
    ParkTypeReversePark = 1001,     //逆向违停
    ParkTypeLockPark = 1002,        //违停锁车
    ParkTypeCarInfoAdd = 2001,      //车辆录入
    ParkTypeThrough = 2333          //闯禁令
};

typedef NS_ENUM(NSUInteger, MessageType) {
    MessageTypeAll = 0,         //全部
    MessageTypeCar = 1,         //识别车牌通知
    MessageTypeAccident = 2,    //出警推送消息
    MessageTypePolice = 3,      //警务消息(指挥中心)
    MessageTypeIllegalCar = 4,  //非法营运车辆通知
    MessageTypeTask   = 101,    //101任务通知
    MessageTypeWatch  = 100,    //100排班通知
   
};


@interface ShareValue : NSObject

LRSingletonH(Default)

@property (nonatomic, copy) NSString *unionid;      //微信unionid
@property (nonatomic, copy) NSString *token;        //token值
@property (nonatomic, copy) NSString *phone;        //登录返回的手机号码
@property (nonatomic, assign) NSInteger makeNumber; //推送消息数目

@property (nonatomic, copy) NSString *server_url;       //服务器地址
@property (nonatomic, copy) NSString *webSocket_url;    //webSocket地址


@property (nonatomic, strong) AccidentGetCodesResponse * accidentCodes;  //事故通用值
@property (nonatomic, copy) NSArray <CommonGetRoadModel *> * roadModels; //道路通用值


@end
