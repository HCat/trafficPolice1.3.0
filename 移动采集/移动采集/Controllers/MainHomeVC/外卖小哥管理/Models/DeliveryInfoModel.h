//
//  DeliveryInfoModel.h
//  移动采集
//
//  Created by hcat on 2019/5/9.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeliveryCompanyModel : NSObject

@property (nonatomic,copy) NSString * companyId;   //企业id
@property (nonatomic,copy) NSString * companyName; //企业名称
@property (nonatomic,copy) NSString * teamName;    //所属加盟商
@property (nonatomic,copy) NSString * companyNo;   //快递员绑定的企业编码

@end

@interface DeliveryVehicleInfoModel : NSObject

@property (nonatomic,copy) NSString * vehicleId;   //车辆id
@property (nonatomic,copy) NSString * companyName; //企业名称
@property (nonatomic,copy) NSString * plateNo;   //快递员绑定的企业编码

@end

@interface DeliveryInfoModel : NSObject

@property (nonatomic,copy) NSString * deliveryId;      //快递员id
@property (nonatomic,copy) NSString * name; //快递员姓名
@property (nonatomic,copy) NSString * telephone; //快递员电话
@property (nonatomic,copy) NSString * licenseNo;//快递员身份证
@property (nonatomic,strong) NSNumber * score; //快递员剩余分数
@property (nonatomic,strong) NSNumber * scoreCount; //快递员扣分次数
@property (nonatomic,copy) NSString * picUrl; //快递员人头像照片
@property (nonatomic,copy) NSString * deliveryTypeStr;//暂无，兼职，专职
@property (nonatomic,strong) NSArray <DeliveryCompanyModel *> * dcList; //快递员绑定企业列表
@property (nonatomic,strong) NSArray <DeliveryVehicleInfoModel *> * dvList; ////快递员绑定车辆列表

@end

NS_ASSUME_NONNULL_END
