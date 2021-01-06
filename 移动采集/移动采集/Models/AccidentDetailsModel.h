//
//  AccidentDetailsModel.h
//  移动采集
//
//  Created by hcat on 2018/7/25.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccidentPicListModel.h"
#import "AccidentPeopleModel.h"

@interface AccidentInfoModel : NSObject

@property (nonatomic,strong) NSNumber * happenTime;       //事故时间 必填，格式：yyyy-MM-dd HH:mm:ss
@property (nonatomic,strong) NSNumber * roadId;           //道路ID 必填，从通用值【道路】获取ID
@property (nonatomic,copy)   NSString * address;          //事故地点
@property (nonatomic,strong) NSNumber * causesType;       //事故成因ID 从通用值【事故成因】获取ID
@property (nonatomic,copy)   NSString * weather;          //天气 默认值从天气接口获取，可编辑
@property (nonatomic,copy)   NSString * injuredNum;       //受伤人数
@property (nonatomic,strong) NSNumber * roadType;         //事故地点类型 从通用值【事故地点类型】获取ID

@property (nonatomic,strong) NSNumber * state;            //事故状态,1为结案(已处理) 3为中队调解中
@property (nonatomic,copy)   NSString * casualties;       //伤亡情况
@property (nonatomic,copy)   NSString * causes;           //事故成因
@property (nonatomic,copy)   NSString * mediationRecord;  //中队调解记录
@property (nonatomic,copy)   NSString * memo;             //备注记录与领导意见
@property (nonatomic,copy)   NSString * responsibility;   //事故责任认定建议,这个只有快处才有的数据

@property (nonatomic,copy)   NSString * callpoliceMan;    //报案人
@property (nonatomic,copy)   NSString * callpoliceManPhone;  //手机号


@end

@interface AccidentDetailsModel : NSObject

@property (nonatomic,strong) AccidentInfoModel *accident;      //事故对象
@property (nonatomic,copy) NSArray<AccidentPicListModel *> *picList;    //图片列表
@property (nonatomic,copy) NSArray<AccidentPeopleModel *> *accidentList; //事故人员对象

@end
