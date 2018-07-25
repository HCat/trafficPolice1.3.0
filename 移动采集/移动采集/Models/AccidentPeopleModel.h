//
//  AccidentPeopleModel.h
//  移动采集
//
//  Created by hcat on 2018/7/25.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccidentPeopleModel : NSObject


@property (nonatomic,copy)    NSString * name;              //姓名 必填，可用身份证、驾驶证识别
@property (nonatomic,copy)    NSString * idNo;              //身份证号码 必填，可用身份证、驾驶证识别
@property (nonatomic,copy)    NSString * carNo;             //车牌号 必填，可用行驶证识别
@property (nonatomic,copy)    NSString * phone;             //联系电话
@property (nonatomic,copy)    NSString * policyNo;          //保险单号

@property (nonatomic,strong)  NSNumber * insuranceCompanyId;//保险公司 从通用值【保险公司】获取ID
@property (nonatomic,strong)  NSNumber * vehicleId;         //车辆类型 必填，从通用值【车辆类型】获取ID，可用行驶证识别
@property (nonatomic,strong)  NSNumber * responsibilityId;  //责任 从通用值【责任】获取ID
@property (nonatomic,strong)  NSNumber * directId;          //行驶状态 从通用值【行驶状态】获取ID
@property (nonatomic,strong)  NSNumber * behaviourId;       //违法行为 从通用值【事故成因】获取ID
@property (nonatomic,strong)  NSNumber * isZkCl;            //是否暂扣车辆 0否1是
@property (nonatomic,strong)  NSNumber * isZkXsz;           //是否暂扣行驶证 0否1是
@property (nonatomic,strong)  NSNumber * isZkJsz;           //是否暂扣驾驶证 0否1是
@property (nonatomic,strong)  NSNumber * isZkSfz;           //是否暂扣身份证 0否1是
@property (nonatomic,strong)  NSString * resume;            //简述
@property (nonatomic,strong)  NSNumber * sorting;           //1.甲方 2.乙方 3.丙方 4.丁方 5.戊方


@end
