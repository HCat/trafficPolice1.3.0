//
//  DutyAPI.h
//  移动采集
//
//  Created by hcat on 2017/10/25.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "AddressBookModel.h"



@interface DutyPeopleModel:NSObject

@property (nonatomic,copy) NSString * name;         //用户名
@property (nonatomic,copy) NSString * realName;     //真实姓名
@property (nonatomic,copy) NSString * telNum;       //电话
@property (nonatomic,copy) NSString * dutyName;     //中队名称

@end

@interface DutyGroupModel:NSObject

@property (nonatomic,copy)  NSString *name;  //组名
@property (nonatomic,strong) NSArray <DutyPeopleModel *> * helpList;
@property (nonatomic,strong) NSArray <DutyPeopleModel *> * policeList;


@end

#pragma mark - 获取月排班

@interface DutyMonthModel:NSObject

@property(nonatomic,copy) NSString *dutyDay;
@property(nonatomic,copy) NSArray <NSString *> * leaderList;

@end


@interface DutyGetDutyByMonthManger:LRBaseRequest

/****** 请求数据 ******/

@property (nonatomic,copy) NSString * dateStr;

/****** 返回数据 ******/
@property (nonatomic, strong) NSArray <DutyMonthModel *> * monthReponse;


@end


#pragma mark - 按天获取排班详

@interface DutyGetDutyByDayReponse :NSObject

@property (nonatomic, strong) NSArray <DutyPeopleModel *> * leaderList;
@property (nonatomic, strong) NSArray <DutyPeopleModel *> * policeList;
@property (nonatomic, strong) NSArray <DutyPeopleModel *> * othersList;

@end

@interface DutyGetDutyByDayManger:LRBaseRequest

/****** 请求数据 ******/

@property (nonatomic,copy) NSString * dateStr;

/****** 返回数据 ******/
@property (nonatomic,strong) DutyGetDutyByDayReponse *dutyGetDutyByDayReponse;

@end

#pragma mark - 按天获取排班详情(分组)

@interface DutyGetWorkByDayReponse :NSObject

@property (nonatomic, strong) NSArray <DutyPeopleModel *> * leaderList;
@property (nonatomic, strong) NSArray <DutyGroupModel *> * helpTeam;
@property (nonatomic, strong) NSArray <DutyGroupModel *> * policeTeam;

@end

@interface DutyGetWorkByDayManger:LRBaseRequest

/****** 请求数据 ******/

@property (nonatomic,copy) NSString * dateStr;

/****** 返回数据 ******/
@property (nonatomic,strong) DutyGetWorkByDayReponse *workReponse;

@end
