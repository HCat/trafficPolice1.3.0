//
//  SignAPI.h
//  移动采集
//
//  Created by hcat on 2017/9/4.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignModel.h"

#pragma mark - 签到API

@interface SignManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * address;     //地址
@property (nonatomic, strong) NSNumber * longitude; //经度
@property (nonatomic, copy) NSNumber * latitude;    //纬度

/****** 返回数据 ******/
//无返回参数

@end


#pragma mark - 签退API

@interface SignOutManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * address;     //地址
@property (nonatomic, strong) NSNumber * longitude; //经度
@property (nonatomic, copy) NSNumber * latitude;    //纬度

/****** 返回数据 ******/
//无返回参数

@end



#pragma mark - 签到列表

@interface SignListReponse : NSObject

@property (nonatomic,copy) NSArray < SignModel *> * list;    //包含IllegalParkListModel对象
@property (nonatomic,strong) NSNumber * currentTime;                           //当前时间

@end

@interface SignListManger:LRBaseRequest

/****** 请求数据 ******/


/****** 返回数据 ******/
@property (nonatomic, strong) SignListReponse * signListReponse;

@end
