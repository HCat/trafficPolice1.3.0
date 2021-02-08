//
//  DailyPatrolDetailViewModel.h
//  移动采集
//
//  Created by hcat-89 on 2020/1/8.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DailyPatrolAPI.h"


NS_ASSUME_NONNULL_BEGIN

@interface DailyPatrolDetailViewModel : NSObject

@property(nonatomic, strong) NSNumber * partrolId;  //巡逻编号
@property(nonatomic, strong) NSNumber * type;       //1为站岗  0为巡逻
@property(nonatomic, strong) NSNumber * shiftId;    //班次编号
@property(nonatomic, strong) NSNumber * shiftNum;   //巡逻班次
@property(nonatomic, strong) NSNumber * point;      //第几个途经点
@property(nonatomic, strong) NSNumber * latitude;   //纬度
@property(nonatomic, strong) NSNumber * longitude;  //经度
@property(nonatomic, strong) NSNumber * pointType;  //到岗状态  0为签到  1为签退

@property(nonatomic, strong) NSMutableArray * arr_point;    //存储巡逻点
@property(nonatomic, strong) NSArray * arr_people;   //存储路径点
@property (nonatomic, strong) NSMutableArray * arr_point_people;           // 用来存储警员或者警车点数据
//巡逻详情
@property(nonatomic, strong) DailyPatrolNewDetailReponse * reponseModel;

//巡逻q详情请求
@property(nonatomic, strong) RACCommand * command_detail;

//巡逻打卡请求
@property(nonatomic, strong) RACCommand * command_sign;

//到岗打卡请求
@property(nonatomic, strong) RACCommand * command_pointSign;

//位置上报
@property(nonatomic, strong) RACCommand * command_locationReport;

//实时上报位置列表
@property(nonatomic, strong) RACCommand * command_pointList;






@end

NS_ASSUME_NONNULL_END
