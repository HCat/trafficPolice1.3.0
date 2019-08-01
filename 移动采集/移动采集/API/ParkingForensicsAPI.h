//
//  ParkingForensicsAPI.h
//  移动采集
//
//  Created by hcat on 2019/7/25.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "LRBaseRequest.h"
#import "ParkingForensicsModel.h"
#import "ParkingOccPercentModel.h"
#import "ParkingAreaModel.h"
#import "ParkingAreaDetailModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface ParkingForensicsListParam : NSObject

@property (nonatomic,strong) NSNumber * start;   //开始的索引号 从0开始
@property (nonatomic,strong) NSNumber * length;  //显示的记录数 默认为10

@end

@interface ParkingForensicsListReponse : NSObject

@property (nonatomic,copy)   NSArray<ParkingForensicsModel * > * list;    //包含AccidentListModel对象
@property (nonatomic,assign) NSInteger total;    //总数

@end

@interface ParkingForensicsListManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) ParkingForensicsListParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) ParkingForensicsListReponse * parkingReponse;

@end




@interface ParkingOccPercentListParam : NSObject
@property (nonatomic,copy) NSString * parklotid;
@property (nonatomic,strong) NSNumber * start;   //开始的索引号 从0开始
@property (nonatomic,strong) NSNumber * length;  //显示的记录数 默认为10

@end

@interface ParkingOccPercentListReponse : NSObject

@property (nonatomic,copy)   NSArray<ParkingOccPercentModel * > * list;    //包含AccidentListModel对象
@property (nonatomic,assign) NSInteger total;    //总数

@end

@interface ParkingOccPercentListManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) ParkingOccPercentListParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) ParkingOccPercentListReponse * parkingReponse;

@end

#pragma mark - 全部片区列表

@interface ParkingAreaManger:LRBaseRequest

/****** 返回数据 ******/
@property (nonatomic,copy)   NSArray<ParkingAreaModel * > * list;    //包含AccidentListModel对象

@end



#pragma mark - 车位详情

@interface ParkingAreaDetailManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * parkplaceId;

/****** 返回数据 ******/
@property (nonatomic, strong) ParkingAreaDetailModel * parkingReponse;

@end

#pragma mark - 标记无车

@interface ParkingRemarkCarStatusManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * parkplaceId;

@end

#pragma mark - 停车取证

@interface ParkingForensicsParam :  NSObject

@property (nonatomic,strong,nullable) NSNumber * roadId;      //道路ID 必填，从通用值【道路】获取ID
@property (nonatomic,copy,nullable)   NSString * roadName;             //道路名字 如果roadId为0的时候设置
@property (nonatomic,copy,nullable)   NSString * address;              //事故地点 必填
@property (nonatomic,copy,nullable)   NSString * addressRemark;        //地址备注 非必填
@property (nonatomic,copy,nullable)   NSString * carNo;                //车牌号 必填
@property (nonatomic,copy,nullable)   NSString * carColor;             //车牌颜色 必填
@property (nonatomic,strong,nullable) NSNumber * longitude;            //经度 必填
@property (nonatomic,strong,nullable) NSNumber * latitude;             //纬度 必填
@property (nonatomic,copy,nullable)   NSArray  * files;                //事故图片 列表，最多可上传30张
@property (nonatomic,copy,nullable)   NSString * remarks;              //违停图片名称  违章图片名称，字符串列表。和图片一对一，名称统一命名，车牌近照（一张）、违停照片（可多张）
@property (nonatomic,copy,nullable)   NSString * taketimes;            //拍照时间 拍照时间，字符串列表，格式yyyy-MM-dd HH:mm:ss，和图片一对一
//两个参数同时不为空才有效，没有则不填
@property (nonatomic,copy,nullable)   NSString * cutImageUrl;          //裁剪车牌近照url
@property (nonatomic,copy,nullable)   NSString * taketime;             //裁剪车牌近照时间
@property (nonatomic,strong,nullable) NSNumber * isManualPos;          //0自动定位，1手动定位，默认0
@property (nonatomic,strong,nullable) NSNumber * type;                   //停车取证：6001


@end



@interface ParkingForensicsManger:LRBaseRequest

@property (nonatomic, strong) ParkingForensicsParam * param;
@property (nonatomic, assign) CGFloat progress;


@end



NS_ASSUME_NONNULL_END
