//
//  ExposureCollectAPI.h
//  移动采集
//
//  Created by hcat on 2019/12/5.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IllegalExposureIllegalTypeModel.h"
#import "AccidentPicListModel.h"


NS_ASSUME_NONNULL_BEGIN

#pragma mark - 违法曝光采集

@interface ExposureCollectReportParam :  NSObject

@property (nonatomic,copy,nullable)   NSString * address;               //事故地点 必填
@property (nonatomic,strong,nullable) NSNumber * longitude;             //经度 必填
@property (nonatomic,strong,nullable) NSNumber * latitude;              //纬度 必填
@property (nonatomic,copy,nullable)   NSArray  * files;                 //事故图片 列表，最多可上传30张
@property (nonatomic,copy,nullable)   NSString * carNo;                 //车牌号
@property (nonatomic,strong,nullable) NSString * carColor;
          //车牌颜色
@property (nonatomic,copy,nullable)   NSString * userName;              //真实姓名
@property (nonatomic,copy,nullable)   NSString * illegalType;           //违法类型
@property (nonatomic,copy,nullable)   NSString * addressRemark;         //备注
@property (nonatomic,strong,nullable) NSNumber * roadId;                //道路ID 必填，从通用值【道路】获取ID
@property (nonatomic,copy,nullable)   NSString * roadName;              //道路名字 如果roadId为0的时候设置
@property (nonatomic,strong,nullable) NSNumber * remarkNoCar;           //标记0:无车 1:有车

@property (nonatomic,copy,nullable)   NSString * remarks;              //违停图片名称  违章图片名称，字符串列表。和图片一对一，名称统一命名，车牌近照（一张）、违停照片（可多张）

@property (nonatomic,strong) NSNumber * isManualPos;          //0自动定位，1手动定位，默认0
@property (nonatomic,copy,nullable)   NSString * cutImageUrl;          //裁剪车牌近照url


@end

@interface ExposureCollectReportManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) ExposureCollectReportParam * param;
@property (nonatomic, assign) CGFloat progress;

@end

#pragma mark - 违法类型列表

@interface ExposureCollectTypeListManger:LRBaseRequest

/****** 返回数据 ******/
@property (nonatomic,copy) NSArray < IllegalExposureIllegalTypeModel *> * list;    //包含IllegalParkListModel对象

@end




#pragma mark - 违法曝光列表API

@interface ExposureCollectListModel : NSObject

@property (nonatomic,strong) NSNumber * exposureCollectId ; //主键
@property (nonatomic,strong) NSNumber * collectTime ;   //采集时间
@property (nonatomic,copy)   NSString * roadName ;      //路名
@property (nonatomic,copy)   NSString * carNo;          //车牌号
@property (nonatomic,copy)   NSString * userName;          //违章姓名
@property (nonatomic,copy)   NSNumber * illegalType;          //违章类型
@property (nonatomic,copy)   NSNumber * remarkNoCar;          //标记无车

@end



@interface ExposureCollectListPagingParam : NSObject

@property (nonatomic,assign) NSInteger  start;   //开始的索引号 从0开始
@property (nonatomic,assign) NSInteger  length;  //显示的记录数 默认为10

@end


@interface ExposureCollectListPagingReponse : NSObject

@property (nonatomic,copy) NSArray < ExposureCollectListModel *> * list;    //包含IllegalParkListModel对象
@property (nonatomic,assign) NSInteger total;                           //总数

@end

@interface ExposureCollectListPagingManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) ExposureCollectListPagingParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) ExposureCollectListPagingReponse * exposureCollectListPagingReponse;

@end

#pragma mark - 违法曝光详情API

@interface ExposureCollectModel : NSObject

@property (nonatomic,copy)   NSString * roadName;        //道路名称
@property (nonatomic,copy)   NSString * address;         //地点
@property (nonatomic,copy)   NSString * carNo;           //车牌号
@property (nonatomic,copy)   NSString * userName;        //违章姓名
@property (nonatomic,strong) NSNumber * collectTime;     //采集时间
@property (nonatomic,copy)   NSString * illegalName;     //违章类型
@property (nonatomic,strong)  NSNumber * remarkNoCar;    //是否为无车：0 有车：1
@property (nonatomic,copy)   NSString * addressRemark;   //备注

@end


@interface ExposureCollectDetailModel : NSObject

@property (nonatomic,strong) ExposureCollectModel *collect; //曝光详情
@property (nonatomic,copy) NSArray<AccidentPicListModel *> *pictureList;    //图片列表

@end


@interface ExposureCollectDetailManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * exposureCollectId;

/****** 返回数据 ******/
@property (nonatomic, strong) ExposureCollectDetailModel * exposureCollectDetailModel;

@end



NS_ASSUME_NONNULL_END
