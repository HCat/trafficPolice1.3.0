//
//  MessageAPI.h
//  trafficPolice
//
//  Created by hcat on 2017/7/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "IdentifyModel.h"

#pragma mark - 消息列表

@interface IdentifyMsgListParam : NSObject

@property (nonatomic,assign) NSInteger start;   //开始的索引号 从0开始
@property (nonatomic,assign) NSInteger length;  //显示的记录数 默认为10

@end


@interface IdentifyMsgListReponse : NSObject

@property (nonatomic,copy)   NSArray < IdentifyModel *> * list;   //包含IdentifyModel对象
@property (nonatomic,assign) NSInteger total;                     //总数

@end


@interface IdentifyMsgListManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) IdentifyMsgListParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) IdentifyMsgListReponse * identifyMsgListReponse;

@end


#pragma mark - 确认接收消息

@interface IdentifySetMsgReadManger : LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * msgId; //主键

/****** 返回数据 ******/


@end





