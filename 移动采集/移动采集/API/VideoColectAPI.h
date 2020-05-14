//
//  VideoColectAPI.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/21.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "VideoColectListModel.h"
#import "ImageFileInfo.h"
#import "ArtVideoModel.h"

#pragma mark - 警情反馈采集增加API

@interface VideoColectSaveParam : NSObject

@property (nonatomic,strong) NSNumber  * longitude;     //经度
@property (nonatomic,strong) NSNumber  * latitude;      //纬度
@property (nonatomic,copy)   NSString  * address;       //详细地址 定位自动获取(不可修改)
@property (nonatomic,copy)   NSString  * memo;          //地址备注
@property (nonatomic,strong) ArtVideoModel  * file;     //视频文件 文件格式
@property (nonatomic,strong) ImageFileInfo  * preview;  //预览图 文件格式
@property (nonatomic,strong) NSNumber * videoLength;    //视频长度 整型，单位：秒

@end


@interface VideoColectSaveManger:LRBaseRequest

/****** 请求数据 ******/
/****** 请求数据 ******/
@property (nonatomic, strong) VideoColectSaveParam *param;

/****** 返回数据 ******/
//无返回参数

@end

#pragma mark - 警情反馈采集列表API

@interface VideoColectListPagingParam : NSObject

@property (nonatomic,assign) NSInteger  start;   //开始的索引号 从0开始
@property (nonatomic,assign) NSInteger  length;  //显示的记录数 默认为10
@property (nonatomic,copy)   NSString * search;  //搜索的关键字

@end


@interface VideoColectListPagingReponse : NSObject

@property (nonatomic,copy) NSArray < VideoColectListModel *> * list;    //包含IllegalParkListModel对象
@property (nonatomic,assign) NSInteger total;                           //总数

@end


@interface VideoColectListPagingManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) VideoColectListPagingParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) VideoColectListPagingReponse * videoColectListPagingReponse;

@end

#pragma mark - 警情反馈采集详情API
//这个接口似乎没有完善

@interface VideoColectDetailManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * start;

/****** 返回数据 ******/
//无返回数据

@end
