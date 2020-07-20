//
//  ScreenManageAPI.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/6/19.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScreenItemModel : NSObject

@property (nonatomic,strong) NSNumber * Id;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,strong) NSNumber * createTime;
@property (nonatomic,copy) NSString * windowNo;
@property (nonatomic,copy) NSString * orgCode;
@property (nonatomic,copy) NSString * content;
@property (nonatomic,strong) NSNumber * departmentId;

@end

@interface ScreenListParam : NSObject

@property (nonatomic,strong) NSNumber * page;     //页数
@property (nonatomic,strong) NSNumber * rows;     //条数
@property (nonatomic,copy, nullable)   NSString * name;     //姓名

@end


@interface ScreenListResponse : NSObject

@property (nonatomic,copy)   NSArray<ScreenItemModel * > * list;
@property (nonatomic,assign) NSInteger total;    //总数

@end


@interface ScreenListManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) ScreenListParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) ScreenListResponse * screenresponse;

@end

#pragma mark - 领取证件添加

@interface ScreenAddManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * nameArr;

@end


#pragma mark - 领取证件删除

@interface ScreenDelManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * Id;


@end



NS_ASSUME_NONNULL_END
