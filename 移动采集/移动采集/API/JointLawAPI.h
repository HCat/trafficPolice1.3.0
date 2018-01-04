//
//  JointLawAPI.h
//  移动采集
//
//  Created by hcat on 2017/12/28.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "LRBaseRequest.h"

#pragma mark - 联合执法增加

@interface JointLawSaveParam: NSObject

@property (nonatomic,copy)    NSString * illegalTimeStr;   //执法时间    格式：yyyy-MM-dd HH:mm:ss
@property (nonatomic,copy)    NSString * plateno;   //车牌号    必填
@property (nonatomic,copy)    NSString * illegalAddress;   //执法地点
@property (nonatomic,copy)    NSString * ownerName;   //车主姓名
@property (nonatomic,copy)    NSString * ownerIdCard;   //车主身份证
@property (nonatomic,copy)    NSString * ownerPhone;   //车主电话
@property (nonatomic,copy)    NSString * driverName;   //驾驶员姓名
@property (nonatomic,copy)    NSString * driverIdCard;   //驾驶员身份证
@property (nonatomic,copy)    NSString * driverPhone;   //驾驶员电话
@property (nonatomic,copy)    NSString * dealResult;   //处罚结果    119900,118800,117700   用这种格式字符串，中间用逗号隔开
@property (nonatomic,copy)    NSString * dealRemark;   //处罚结果备注
@property (nonatomic,copy)    NSArray  * imgIds;   //照片id集合    传数组[]
@property (nonatomic,copy)    NSArray  * videoIds;   //视频id集合    传数组[]
@property (nonatomic,strong)  NSNumber * launchOrgType;   //发起方机构类型    2交警 6渣土办 7交通局 8行政执法办 这个可以不用传，看后续需求，现在app都是交警用，后台默认为交警

@end


@interface JointLawSaveManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) AccidentSaveParam *param;

/****** 返回数据 ******/
//无返回参数

@end

#pragma mark - 违法条例列表

@interface JointLawIllegalCodeModel : NSObject

@property (nonatomic,strong)  NSNumber * illegalCode;   //违法代码    119900
@property (nonatomic,copy)    NSString * content;   //违法内容    超速
@property (nonatomic,copy)    NSString * points;   //扣分
@property (nonatomic,copy)    NSString * fines;   //罚款

@end


@interface JointLawGetIllegalCodeListManger : LRBaseRequest

//请求参数

@property(nonatomic,strong) NSNumber * launchOrgType;   //发起方机构类型

//返回参数

@property(nonatomic,copy) NSArray<JointLawIllegalCodeModel *> *list;

@end

#pragma mark - 联合执法上传照片

@interface JointLawImageModel:NSObject

@property (nonatomic,copy)    NSString * imgId;  //照片id
@property (nonatomic,copy)    NSString * imgUrl;  //照片url


@end


@interface JointLawImgUploadManger: LRBaseRequest

//请求数据
@property (nonatomic,copy)    NSArray  * files;  //照片文件集合    文件数组[]
@property (nonatomic,copy)    NSArray  * oldImgIds;  //旧照片id集合    数组[]

//返回数据

@property (nonatomic,copy) NSArray<JointLawImageModel *>* list;     //新照片信息列表

@end


#pragma mark - 联合执法上传视频

@interface JointLawVideoModel:NSObject

@property (nonatomic,copy)    NSString * videoId;  //视频id
@property (nonatomic,copy)    NSString * videoUrl;  //视频url


@end


@interface JointLawVideoUploadManger: LRBaseRequest

//请求数据
@property (nonatomic,strong)  ImageFileInfo  * file;  //单个文件
@property (nonatomic,copy)    NSArray  * oldVideoId;  //旧视频id    单个id，删除旧视频用

//返回数据

@property (nonatomic,copy) JointLawImageModel * jointLawImageModel;     //新照片信息列表

@end







