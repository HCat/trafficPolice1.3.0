//
//  AccidentAPI.h
//  trafficPolice
//
//  Created by hcat on 2017/5/19.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "AccidentListModel.h"
#import "AccidentDetailModel.h"
#import "AccidentCountModel.h"

#pragma mark - 获取交通事故通用值API

@interface AccidentGetCodesModel:NSObject

@property (nonatomic,assign)    NSInteger   modelId;
@property (nonatomic,copy)      NSString *  modelName;
@property (nonatomic,assign)    NSInteger   modelType;
@end

@interface AccidentGetCodesResponse : NSObject

@property (nonatomic,copy) NSArray<AccidentGetCodesModel *> *road;               //道路
@property (nonatomic,copy) NSArray<AccidentGetCodesModel *> *cause;              //事故成因
@property (nonatomic,copy) NSArray<AccidentGetCodesModel *> *behaviour;          //违法行为
@property (nonatomic,copy) NSArray<AccidentGetCodesModel *> *vehicle;            //车辆类型
@property (nonatomic,copy) NSArray<AccidentGetCodesModel *> *insuranceCompany;   //保险公司
@property (nonatomic,copy) NSArray<AccidentGetCodesModel *> *responsibility;     //事故责任
@property (nonatomic,copy) NSArray<AccidentGetCodesModel *> *roadType;           //事故地点类型  是Type
@property (nonatomic,copy) NSArray<AccidentGetCodesModel *> *driverDirect;       //行驶状态 是Type

- (NSString *)searchNameWithModelId:(NSInteger)modelId WithArray:(NSArray <AccidentGetCodesModel *>*)items;
- (NSString *)searchNameWithModelType:(NSInteger)modelType WithArray:(NSArray <AccidentGetCodesModel *>*)items;
- (NSInteger)searchNameWithModelName:(NSString *)modelName WithArray:(NSArray <AccidentGetCodesModel *>*)items;//根据

@end

@interface AccidentGetCodesManger:LRBaseRequest

/****** 请求数据 ******/
/***请求参数中有token值，运用统一添加参数的办法添加到后面所有需要token参数的请求中,具体调用LRBaseRequest中的+ (void)setupRequestFilters:(NSDictionary *)arguments 方法***/

/****** 返回数据 ******/
@property (nonatomic, strong) AccidentGetCodesResponse *accidentGetCodesResponse;

@end

#pragma mark - 事故增加API

@interface AccidentSaveParam : NSObject

@property (nonatomic,copy)    NSString * happenTimeStr;     //事故时间 必填，格式：yyyy-MM-dd HH:mm:ss
@property (nonatomic,strong)  NSNumber * roadId;            //道路ID 必填，从通用值【道路】获取ID
@property (nonatomic,strong)  NSString * roadName;          //道路名称
@property (nonatomic,copy)    NSString * address;           //事故地点
@property (nonatomic,strong)  NSNumber * causesType;        //事故成因ID 从通用值【事故成因】获取ID
@property (nonatomic,copy)    NSString * weather;           //天气 默认值从天气接口获取，可编辑
@property (nonatomic,copy)    NSString * injuredNum;        //受伤人数
@property (nonatomic,strong)  NSNumber * roadType;          //事故地点类型 从通用值【事故地点类型】获取ID

@property (nonatomic,copy)    NSString * ptaName;           //甲方姓名 必填，可用身份证、驾驶证识别
@property (nonatomic,copy)    NSString * ptaIdNo;           //甲方身份证号码 必填，可用身份证、驾驶证识别
@property (nonatomic,strong)  NSNumber * ptaVehicleId;      //甲方车辆类型 必填，从通用值【车辆类型】获取ID，可用行驶证识别
@property (nonatomic,copy)    NSString * ptaCarNo;          //甲方车牌号 必填，可用行驶证识别
@property (nonatomic,copy)    NSString * ptaPhone;          //甲方联系电话
@property (nonatomic,strong)  NSNumber * ptaInsuranceCompanyId;        //甲方保险公司 从通用值【保险公司】获取ID
@property (nonatomic,strong)  NSNumber * ptaResponsibilityId;          //甲方责任 从通用值【责任】获取ID
@property (nonatomic,strong)  NSNumber * ptaDirect;         //甲方行驶状态 从通用值【行驶状态】获取ID
@property (nonatomic,strong)  NSNumber * ptaBehaviourId;    //甲方违法行为 从通用值【事故成因】获取ID
@property (nonatomic,strong)  NSNumber * ptaIsZkCl;         //甲方是否暂扣车辆 0否1是
@property (nonatomic,strong)  NSNumber * ptaIsZkXsz;        //甲方是否暂扣行驶证 0否1是
@property (nonatomic,strong)  NSNumber * ptaIsZkJsz;        //甲方是否暂扣驾驶证 0否1是
@property (nonatomic,strong)  NSNumber * ptaIsZkSfz;        //甲方是否暂扣身份证 0否1是
@property (nonatomic,strong)  NSString * ptaDescribe;       //甲方简述

@property (nonatomic,copy)    NSString * ptbName;           //乙方姓名 可用身份证、驾驶证识别
@property (nonatomic,copy)    NSString * ptbIdNo;           //乙方身份证号码 可用身份证、驾驶证识别
@property (nonatomic,strong)  NSNumber * ptbVehicleId;      //乙方车辆类型 从通用值【车辆类型】获取ID，可用行驶证识别
@property (nonatomic,copy)    NSString * ptbCarNo;          //乙方车牌号 可用驾驶证识别
@property (nonatomic,copy)    NSString * ptbPhone;          //乙方联系电话
@property (nonatomic,strong)  NSNumber * ptbInsuranceCompanyId;    //乙方保险公司 从通用值【保险公司】获取ID
@property (nonatomic,strong)  NSNumber * ptbResponsibilityId;      //乙方责任 从通用值【责任】获取ID
@property (nonatomic,strong)  NSNumber * ptbDirect;         //乙方行驶状态 从通用值【行驶状态】获取ID
@property (nonatomic,strong)  NSNumber * ptbBehaviourId;    //乙方违法行为 从通用值【事故成因】获取ID
@property (nonatomic,strong)  NSNumber * ptbIsZkCl;         //乙方是否暂扣车辆 0否1是
@property (nonatomic,strong)  NSNumber * ptbIsZkXsz;        //乙方是否暂扣行驶证 0否1是
@property (nonatomic,strong)  NSNumber * ptbIsZkJsz;        //乙方是否暂扣驾驶证 0否1是
@property (nonatomic,strong)  NSNumber * ptbIsZkSfz;        //乙方是否暂扣身份证 0否1是
@property (nonatomic,copy)    NSString * ptbDescribe;       //乙方简述

@property (nonatomic,copy)    NSString * ptcName;           //丙方姓名 可用身份证、驾驶证识别
@property (nonatomic,copy)    NSString * ptcIdNo;           //丙方身份证号码 可用身份证、驾驶证识别
@property (nonatomic,strong)  NSNumber * ptcVehicleId;      //丙方车辆类型 从通用值【车辆类型】获取ID，可用行驶证识别
@property (nonatomic,copy)    NSString * ptcCarNo;          //丙方车牌号 可用驾驶证识别
@property (nonatomic,copy)    NSString * ptcPhone;          //丙方联系电话
@property (nonatomic,strong)  NSNumber * ptcInsuranceCompanyId;    //丙方保险公司 从通用值【保险公司】获取ID
@property (nonatomic,strong)  NSNumber * ptcResponsibilityId;      //丙方责任 从通用值【责任】获取ID
@property (nonatomic,strong)  NSNumber * ptcDirect;         //丙方行驶状态 从通用值【行驶状态】获取ID
@property (nonatomic,strong)  NSNumber * ptcBehaviourId;    //丙方违法行为 从通用值【事故成因】获取ID
@property (nonatomic,strong)  NSNumber * ptcIsZkCl;         //丙方是否暂扣车辆 0否1是
@property (nonatomic,strong)  NSNumber * ptcIsZkXsz;        //丙方是否暂扣行驶证 0否1是
@property (nonatomic,strong)  NSNumber * ptcIsZkJsz;        //丙方是否暂扣驾驶证 0否1是
@property (nonatomic,strong)  NSNumber * ptcIsZkSfz;        //丙方是否暂扣身份证 0否1是
@property (nonatomic,copy)    NSString * ptcDescribe;       //丙方简述

@property (nonatomic,copy)    NSArray  * files;             //事故图片 列表，最多可上传30张
@property (nonatomic,copy)    NSArray  * certFiles;         //证件图片 识别的图片，文件格式列表。识别后图片不需要显示出来
@property (nonatomic,copy)    NSArray  * certRemarks;       //证件图片名称 识别的图片名称，字符串列表。和证件图片一对一，名称统一命名，命名规则如下
/*
 证件图片名称：
 甲方身份证 甲方驾驶证 甲方行驶证
 乙方身份证 乙方驾驶证 乙方行驶证
 丙方身份证 丙方驾驶证 丙方行驶证
*/

@end

@interface AccidentSaveManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) AccidentSaveParam *param;

/****** 返回数据 ******/
//无返回参数

@end


#pragma mark - 事故列表API

@interface AccidentListPagingParam : NSObject

@property (nonatomic,assign) NSInteger  start;   //开始的索引号 从0开始
@property (nonatomic,assign) NSInteger  length;  //显示的记录数 默认为10
@property (nonatomic,copy)   NSString * search;  //搜索的关键字

@end


@interface AccidentListPagingReponse : NSObject

@property (nonatomic,copy)   NSArray<AccidentListModel *> *list;    //包含AccidentListModel对象
@property (nonatomic,assign) NSInteger total;    //总数


@end


@interface AccidentListPagingManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) AccidentListPagingParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) AccidentListPagingReponse * accidentListPagingReponse;

@end


#pragma mark - 事件详情API

@interface AccidentDetailManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * accidentId; //事故ID

/****** 返回数据 ******/
@property (nonatomic, strong) AccidentDetailModel * accidentDetailModel;

@end

#pragma mark - 通过车牌号统计事故数量API


@interface AccidentCountByCarNoManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSString * carNo;     //车牌号
@property (nonatomic, strong) NSNumber * state;     //查询事故数的state

/****** 返回数据 ******/
@property (nonatomic, strong) AccidentCountModel * accidentCountModel;

@end


#pragma mark - 通过手机号统计事故数量API


@interface AccidentCountByTelNumManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSString * telNum;    //车牌号
@property (nonatomic, strong) NSNumber * state;     //查询事故数的state

/****** 返回数据 ******/
@property (nonatomic, strong) AccidentCountModel * accidentCountModel;

@end

#pragma mark - 通过身份证号统计事故数量API

@interface AccidentCountByidNoManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSString * idNo;      //车牌号
@property (nonatomic, strong) NSNumber * state;     //查询事故数的state

/****** 返回数据 ******/
@property (nonatomic, strong) AccidentCountModel *accidentCountModel;

@end



