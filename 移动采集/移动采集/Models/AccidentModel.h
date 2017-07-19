//
//  AccidentModel.h
//  trafficPolice
//
//  Created by hcat on 2017/5/19.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccidentModel : NSObject

@property (nonatomic,strong) NSNumber * happenTime;       //事故时间 必填，格式：yyyy-MM-dd HH:mm:ss
@property (nonatomic,strong) NSNumber * roadId;           //道路ID 必填，从通用值【道路】获取ID
@property (nonatomic,copy)   NSString * address;          //事故地点
@property (nonatomic,strong) NSNumber * causesType;       //事故成因ID 从通用值【事故成因】获取ID
@property (nonatomic,copy)   NSString * weather;          //天气 默认值从天气接口获取，可编辑
@property (nonatomic,copy)   NSString * injuredNum;       //受伤人数
@property (nonatomic,strong) NSNumber * roadType;         //事故地点类型 从通用值【事故地点类型】获取ID


@property (nonatomic,copy)   NSString * ptaName;          //甲方姓名 必填，可用身份证、驾驶证识别
@property (nonatomic,copy)   NSString * ptaIdNo;          //甲方身份证号码 必填，可用身份证、驾驶证识别
@property (nonatomic,strong) NSNumber * ptaVehicleId;     //甲方车辆类型 必填，从通用值【车辆类型】获取ID，可用行驶证识别
@property (nonatomic,copy)   NSString * ptaCarNo;         //甲方车牌号 必填，可用行驶证识别
@property (nonatomic,copy)   NSString * ptaPhone;         //甲方联系电话
@property (nonatomic,strong) NSNumber * ptaInsuranceCompanyId;        //甲方保险公司 从通用值【保险公司】获取ID
@property (nonatomic,strong) NSNumber * ptaResponsibilityId;          //甲方责任 从通用值【责任】获取ID
@property (nonatomic,strong) NSNumber * ptaDirect;        //甲方行驶状态 从通用值【行驶状态】获取ID
@property (nonatomic,strong) NSNumber * ptaBehaviourId;   //甲方违法行为 从通用值【事故成因】获取ID
@property (nonatomic,copy)   NSString * ptaDescribe;      //甲方简述


@property (nonatomic,copy)   NSString * ptbName;          //乙方姓名 可用身份证、驾驶证识别
@property (nonatomic,copy)   NSString * ptbIdNo;          //乙方身份证号码 可用身份证、驾驶证识别
@property (nonatomic,strong) NSNumber * ptbVehicleId;     //乙方车辆类型 从通用值【车辆类型】获取ID，可用行驶证识别
@property (nonatomic,copy)   NSString * ptbCarNo;         //乙方车牌号 可用驾驶证识别
@property (nonatomic,copy)   NSString * ptbPhone;         //乙方联系电话
@property (nonatomic,strong) NSNumber * ptbInsuranceCompanyId;    //乙方保险公司 从通用值【保险公司】获取ID
@property (nonatomic,strong) NSNumber * ptbResponsibilityId;      //乙方责任 从通用值【责任】获取ID
@property (nonatomic,strong) NSNumber * ptbDirect;        //乙方行驶状态 从通用值【行驶状态】获取ID
@property (nonatomic,strong) NSNumber * ptbBehaviourId;   //乙方违法行为 从通用值【事故成因】获取ID
@property (nonatomic,copy)   NSString * ptbDescribe;      //乙方简述


@property (nonatomic,copy)   NSString * ptcName;          //丙方姓名 可用身份证、驾驶证识别
@property (nonatomic,copy)   NSString * ptcIdNo;          //丙方身份证号码 可用身份证、驾驶证识别
@property (nonatomic,strong) NSNumber * ptcVehicleId;     //丙方车辆类型 从通用值【车辆类型】获取ID，可用行驶证识别
@property (nonatomic,copy)   NSString * ptcCarNo;         //丙方车牌号 可用驾驶证识别
@property (nonatomic,copy)   NSString * ptcPhone;         //丙方联系电话
@property (nonatomic,strong) NSNumber * ptcInsuranceCompanyId;    //丙方保险公司 从通用值【保险公司】获取ID
@property (nonatomic,strong) NSNumber * ptcResponsibilityId;      //丙方责任 从通用值【责任】获取ID
@property (nonatomic,strong) NSNumber * ptcDirect;        //丙方行驶状态 从通用值【行驶状态】获取ID
@property (nonatomic,strong) NSNumber * ptcBehaviourId;   //丙方违法行为 从通用值【事故成因】获取ID
@property (nonatomic,copy)   NSString * ptcDescribe;      //丙方简述


@end
