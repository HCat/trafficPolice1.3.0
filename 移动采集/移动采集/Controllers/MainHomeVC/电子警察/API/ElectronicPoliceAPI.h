//
//  ElectronicPoliceAPI.h
//  移动采集
//
//  Created by hcat-89 on 2020/4/24.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "ElectronicTypeModel.h"
#import "ElectronicDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 摄像头类型
@interface ElectronicPoliceTypeManger:LRBaseRequest

/****** 返回数据 ******/
@property (nonatomic,copy)   NSArray<ElectronicTypeModel * > * list;    //包含AccidentListModel对象


@end


#pragma mark - 摄像头列表

@interface ElectronicPoliceListManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * cameraType;    //空值则为传全部

/****** 返回数据 ******/
@property (nonatomic,copy)   NSArray<ElectronicDetailModel * > * list;    //包含AccidentListModel对象

@end


NS_ASSUME_NONNULL_END
