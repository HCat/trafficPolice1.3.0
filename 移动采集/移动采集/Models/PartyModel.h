//
//  PartyModel.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/28.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccidentAPI.h"

@interface PartyModel : NSObject

@property (nonatomic,copy)   NSString * partyName;                  //姓名
@property (nonatomic,copy)   NSString * partyIdNummber;             //身份证号码
@property (nonatomic,copy)   NSString * partyCarNummber;            //车牌号
@property (nonatomic,copy)   NSString * partyPhone;                 //联系电话
@property (nonatomic,copy)   NSString * partyPolicyNo;              //保险单号

@property (nonatomic,strong) NSNumber * partyVehicleId;             //车辆类型ID
@property (nonatomic,strong) NSNumber * partyInsuranceCompanyId;    //保险公司ID
@property (nonatomic,strong) NSNumber * partyResponsibilityId;      //责任ID
@property (nonatomic,strong) NSNumber * partyDirectId;              //行驶状态ID
@property (nonatomic,strong) NSNumber * partyBehaviourId;           //违法行为ID

@property (nonatomic,strong) NSNumber * partyIsZkCl;                //是否暂扣车辆 0否1是
@property (nonatomic,strong) NSNumber * partyIsZkXsz;               //是否暂扣行驶证 0否1是
@property (nonatomic,strong) NSNumber * partyIsZkJsz;               //是否暂扣驾驶证 0否1是
@property (nonatomic,strong) NSNumber * partyIsZkSfz;               //是否暂扣身份证 0否1是
@property (nonatomic,strong) NSString * partyDescribe;              //简述


@property(nonatomic,copy)    NSString * partycarType;
@property(nonatomic,copy)    NSString * partyDriverDirect;
@property(nonatomic,copy)    NSString * partyBehaviour;
@property(nonatomic,copy)    NSString * partyInsuranceCompany;
@property(nonatomic,copy)    NSString * partyResponsibility;

@property(nonatomic,assign)  AccidentType accidentType;             //用于判断是快处还是事故录入
@property (nonatomic,strong) AccidentGetCodesResponse * codes;      //

//初始化
//
-(instancetype)initWithIndex:(NSInteger)type withParam:(AccidentSaveParam *)param;

@end
