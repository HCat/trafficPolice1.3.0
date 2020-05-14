//
//  IllegalParkListModel.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/21.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IllegalParkListModel : NSObject

@property (nonatomic,strong) NSNumber * illegalParkId ; //主键
@property (nonatomic,strong) NSNumber * collectTime ;   //采集时间
@property (nonatomic,copy)   NSString * roadName ;      //路名
@property (nonatomic,copy)   NSString * carNo;          //车牌号
@property (nonatomic,assign) NSInteger  sendStatus;     //0 未通知 1 已通知
@property (nonatomic,copy)   NSString * stateName;      //状态m名称
@property (nonatomic,strong) NSNumber * state;          //状态
@property (nonatomic,copy)   NSString * address;        //地址
@property (nonatomic,copy)   NSString * operatorName;   //采集人员

@end
