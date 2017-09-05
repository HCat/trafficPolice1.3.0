//
//  VehicleModel.h
//  移动采集
//
//  Created by hcat on 2017/9/5.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehicleModel : NSObject

@property (nonatomic,strong) NSNumber * plateno;                    //车牌号
@property (nonatomic,strong) NSNumber * carType;                    //车辆类型:1土方车 2水泥砼车 3砂石子车
@property (nonatomic,strong) NSNumber * inspectTimeEnd;             //年审截止日期
@property (nonatomic,strong) NSNumber * compInsuranceTimeEnd;       //强制险截止日期
@property (nonatomic,strong) NSNumber * bussInsuranceTimeEnd;       //商业险截止日期
@property (nonatomic,strong) NSNumber * factoryno;                  //车架号码
@property (nonatomic,strong) NSNumber * motorid;                    //发动机号码
@property (nonatomic,copy)   NSString * description;                //车辆描述
@property (nonatomic,copy)   NSString * driver;                     //车主姓名
@property (nonatomic,strong) NSNumber * dvrcard;                    //车主身份证
@property (nonatomic,strong) NSNumber * drivermobile;               //车主电话
@property (nonatomic,strong) NSNumber * status;                     //车辆状态
@property (nonatomic,strong) NSNumber * remark;                     //备注
@property (nonatomic,strong) NSNumber * carHopperL;                 //车斗信息（长）
@property (nonatomic,strong) NSNumber * carHopperW;                 //车斗信息（宽）
@property (nonatomic,strong) NSNumber * carHopperH;                 //车斗信息（高）

@end
