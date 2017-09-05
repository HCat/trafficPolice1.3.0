//
//  vehicleDriverModel.h
//  移动采集
//
//  Created by hcat on 2017/9/5.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehicleDriverModel : NSObject

@property (nonatomic,copy)   NSString * driverName;         //驾驶员姓名
@property (nonatomic,strong) NSNumber * sex;                //驾驶员姓名
@property (nonatomic,strong) NSNumber * driverCode;         //驾驶证号码
@property (nonatomic,strong) NSNumber * drivingType;        //准驾车型
@property (nonatomic,strong) NSNumber * yearTrialDeadline;  //年审截止日期
@property (nonatomic,strong) NSNumber * invalidDate;        //有效期截止日期
@property (nonatomic,strong) NSNumber * certificationDate;  //从业时间
@property (nonatomic,strong) NSNumber * driverLicence;      //从业资格证号
@property (nonatomic,strong) NSNumber * licenceInvalidTime; //资格证有效期
@property (nonatomic,strong) NSNumber * telephone;          //联系电话
@property (nonatomic,copy)   NSString * address;            //居住地址
@property (nonatomic,copy)   NSArray <NSString *> * driverImgList; //驾驶员证件照片



@end
