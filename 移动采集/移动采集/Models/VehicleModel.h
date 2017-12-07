//
//  VehicleModel.h
//  移动采集
//
//  Created by hcat on 2017/9/5.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehicleModel : NSObject

@property (nonatomic,copy)   NSString * plateno;                    //车牌号
@property (nonatomic,copy)   NSString * memFormNo;  //运输主体自编号
@property (nonatomic,copy)   NSString * selfNo;  //车辆自编号

@property (nonatomic,strong) NSNumber * carType;                    //车辆类型:1土方车 2水泥砼车 3砂石子车
@property (nonatomic,strong) NSNumber * inspectTimeEnd;             //年审截止日期
@property (nonatomic,strong) NSNumber * compInsuranceTimeEnd;       //强制险截止日期
@property (nonatomic,strong) NSNumber * bussInsuranceTimeEnd;       //商业险截止日期
@property (nonatomic,copy)   NSString * factoryno;                  //车架号码
@property (nonatomic,copy)   NSString * motorid;                    //发动机号码
@property (nonatomic,copy)   NSString * description_text;           //车辆描述
@property (nonatomic,copy)   NSString * driver;                     //车主姓名
@property (nonatomic,copy)   NSString * dvrcard;                    //车主身份证
@property (nonatomic,copy)   NSString * drivermobile;               //车主电话
@property (nonatomic,copy)   NSString * status;                     //车辆状态 1正常 0暂停运营 2停止运营 3未审核 4未提交 5审核未通过
@property (nonatomic,copy)   NSString * remark;                     //备注
@property (nonatomic,copy)   NSString * carriageOutsideH;          //车厢外高度
@property (nonatomic,copy)   NSString * carHopperL;                 //车斗信息（长）
@property (nonatomic,copy)   NSString * carHopperW;                 //车斗信息（宽）
@property (nonatomic,copy)   NSString * carHopperH;                 //车斗信息（高）

@end
