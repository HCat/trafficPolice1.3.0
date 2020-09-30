//
//  ParkingForensicsAPI.h
//  移动采集
//
//  Created by hcat on 2019/7/25.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "LAJIBaseRequest.h"
#import "ParkingForensicsModel.h"
#import "ParkingOccPercentModel.h"
#import "ParkingAreaModel.h"
#import "ParkingAreaDetailModel.h"

NS_ASSUME_NONNULL_BEGIN


#pragma mark - 片区工单

@interface ParkingForensicsListParam : NSObject

@property (nonatomic,copy)   NSString * fkParklotId;        //片区iD
@property (nonatomic,strong) NSNumber * longitude;          //巡检员经度
@property (nonatomic,strong) NSNumber * latitude;           //巡检员纬度
@property (nonatomic,strong) NSNumber * pageNum;            //页码数
@property (nonatomic,strong) NSNumber * pageSize;           //每页记录数
@property (nonatomic,strong) NSString * onlyShowWaitToQz;  //只显示待取证:true

@end

@interface ParkingForensicsListReponse : NSObject

@property (nonatomic,copy)   NSArray<ParkingForensicsModel * > * list;    //包含ParkingForensicsModel对象
@property (nonatomic,assign) NSInteger total;    //总数

@end

@interface ParkingForensicsListManger:LAJIBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) ParkingForensicsListParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) ParkingForensicsListReponse * parkingReponse;

@end

#pragma mark - 片区车位

@interface ParkingOccPercentListParam : NSObject

@property (nonatomic,copy)   NSString * fkParklotId;
@property (nonatomic,strong) NSNumber * pageNum;//开始的索引号 从1开始
@property (nonatomic,strong) NSNumber * pageSize;;  //显示的记录数 默认为10

@end

@interface ParkingOccPercentListReponse : NSObject

@property (nonatomic,copy)   NSArray<ParkingOccPercentModel * > * rows;    //包含ParkingOccPercentModel对象
@property (nonatomic,assign) NSInteger total;    //总数

@end

@interface ParkingOccPercentListManger:LAJIBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) ParkingOccPercentListParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) ParkingOccPercentListReponse * parkingReponse;

@end

#pragma mark - 全部片区列表

@interface ParkingAreaManger:LAJIBaseRequest

/****** 返回数据 ******/
@property (nonatomic,copy)   NSArray<ParkingAreaModel * > * list;    //包含ParkingAreaModel对象

@end



#pragma mark - 车位详情

@interface ParkingAreaDetailManger:LAJIBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * parkPlaceId;

/****** 返回数据 ******/
@property (nonatomic, strong) ParkingAreaDetailModel * parkingReponse;

@end

#pragma mark - 停车取证

@interface ParkingForensicsParam :  NSObject

@property (nonatomic,copy) NSString * fkParkplaceId;                   //车位id

@property (nonatomic,copy,nullable)   NSString * carNo;                //车牌号 必填
@property (nonatomic,copy,nullable)   NSString * carColor;             //车牌颜色

@property (nonatomic,copy,nullable)   NSArray  * files;                //事故图片 列表，最多可上传30张
@property (nonatomic,copy,nullable)   NSString * remarks;              //违停图片名称  违章图片名称，字符串列表。和图片一对一，名称统一命名，车牌近照（一张）、违停照片（可多张）

@property (nonatomic,copy,nullable)   NSString * cutImageUrl;          //裁剪车牌近照url
@property (nonatomic,copy,nullable)   NSString * absoluteUrl;          //绝对路径


@end



@interface ParkingForensicsManger:LAJIBaseRequest

@property (nonatomic, strong) ParkingForensicsParam * param;
@property (nonatomic, assign) CGFloat progress;


@end

#pragma mark - 证件识别API

@interface ParkingIdentifyResponse : NSObject

@property (nonatomic, copy) NSString * carNo;        //车牌号
@property (nonatomic, copy) NSString * vehicleType;  //车辆类型
@property (nonatomic, copy) NSString * color;        //车牌颜色
@property (nonatomic, copy) NSString * name;         //姓名，或者车辆所有人
@property (nonatomic, copy) NSString * idNo;         //证件号码
@property (nonatomic, strong) NSNumber * isFristPark;  //是否为第一次违停记录
@property (nonatomic, copy) NSString * cutImageUrl;  //车牌号近照路径
@property (nonatomic, copy) NSString * absoluteUrl;  //显示用的

@end

@interface ParkingIdentifyManger:LAJIBaseRequest

/****** 请求数据 ******/

@property (nonatomic, strong) ImageFileInfo * imageInfo;    //图片文件
@property (nonatomic, assign) NSInteger type;               //文件类型1：车牌号 2：身份证 3：驾驶证 4：行驶证

/****** 返回数据 ******/
@property (nonatomic, strong) ParkingIdentifyResponse * parkingIdentifyResponse; //证件信息

@end

#pragma mark - 验证是否为第一次违停



@interface ParkingIsFirstParkManger:LAJIBaseRequest

/****** 请求数据 ******/

@property (nonatomic, copy) NSString * carNo;        //车牌号

/****** 返回数据 ******/
@property (nonatomic, strong) NSNumber * isFristPark;  //是否为第一次违停记录

@end


#pragma mark - 验证用户是否在系统有效注册


@interface ParkingIsRegisteManger:LAJIBaseRequest

/****** 请求数据 ******/

@property (nonatomic, copy) NSString * phone;        //车牌号

/****** 返回数据 ******/
@property (nonatomic, strong) NSNumber * isRegiste;  //是否为第一次违停记录

@end




NS_ASSUME_NONNULL_END
