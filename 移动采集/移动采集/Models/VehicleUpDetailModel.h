//
//  VehicleUpDetailModel.h
//  移动采集
//
//  Created by hcat on 2018/5/25.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehcleUpImageModel : NSObject

@property(nonatomic,copy) NSString * mediaUrl;

@end



@interface VehicleUpDetailModel : NSObject

@property (nonatomic,copy)      NSString * upId;            //违法操作的id
@property (nonatomic,strong)    NSNumber * carId;           //车在如果在车库的id
@property (nonatomic,strong)    NSNumber * creatorId;       //录入者ID
@property (nonatomic,copy)      NSString * creatorName;     //录入者
@property (nonatomic,strong)    NSNumber * entryDate;       //录入时间
@property (nonatomic,copy)      NSString * plateNo;         //车牌号 必填
@property (nonatomic,copy)      NSString * driver;          //驾驶员姓名 必填，可用身份证、驾驶证识别
@property (nonatomic,copy)      NSString * idCardNum;       //驾驶员身份证号码 必填，可用身份证、驾驶证识别
@property (nonatomic,copy)      NSString * road;            //道路名字 如果roadId为0的时候设置
@property (nonatomic,copy)      NSString * position;        //事故地点 必填
@property (nonatomic,copy)      NSString * illegalType;     //违法类型

@property (nonatomic,copy)    NSArray  <VehcleUpImageModel *>* imgList;           //上传上报图片 列表，最多可上传30张
@property (nonatomic,copy)    NSString * remark;        //上报备注

@end
