//
//  IllegalDBModel.h
//  移动采集
//
//  Created by hcat on 2018/9/28.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IllegalParkAPI.h"


NS_ASSUME_NONNULL_BEGIN

@interface IllegalDBModel : NSObject

@property (nonatomic,strong) NSNumber * illegalId;            //违章ID
@property (nonatomic,copy)   NSString * ownId;                //属于谁未上传的违章记录
@property (nonatomic,strong) NSNumber * commitTime;           //提交时间

@property (nonatomic,strong) NSNumber * roadId;               //道路ID 必填，从通用值【道路】获取ID
@property (nonatomic,copy)   NSString * roadName;             //道路名字 如果roadId为0的时候设置
@property (nonatomic,copy)   NSString * address;              //事故地点 必填
@property (nonatomic,copy)   NSString * addressRemark;        //地址备注 非必填
@property (nonatomic,copy)   NSString * carNo;                //车牌号 必填
@property (nonatomic,copy)   NSString * carColor;             //车牌颜色 必填
@property (nonatomic,strong) NSNumber * longitude;            //经度 必填
@property (nonatomic,strong) NSNumber * latitude;             //纬度 必填

@property (nonatomic,copy)   NSArray  * files;                //事故图片 列表，最多可上传30张
@property (nonatomic,copy)   NSString * remarks;              //违停图片名称  违章图片名称，字符串列表。和图片一对一，名称统一命名，车牌近照（一张）、违停照片（可多张）
@property (nonatomic,copy)   NSString * taketimes;            //拍照时间 拍照时间，字符串列表，格式yyyy-MM-dd HH:mm:ss，和图片一对一
//两个参数同时不为空才有效，没有则不填

@property (nonatomic,copy)   NSString * cutImageUrl;          //裁剪车牌近照url
@property (nonatomic,copy)   NSString * taketime;             //裁剪车牌近照时间
@property (nonatomic,strong) NSNumber * isManualPos;          //0自动定位，1手动定位，默认0
@property (nonatomic,strong) NSNumber * type;                 //选填，默认1:违停，1001:朝向错误，1002:锁车，2001:信息录入

- (instancetype)initWithIllegalParkParam:(IllegalParkSaveParam *) param;


- (void)save;
- (void)deleteDB;

@end

NS_ASSUME_NONNULL_END
