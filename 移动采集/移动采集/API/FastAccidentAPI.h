//
//  FastAccident.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/19.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRBaseRequest.h"
#import "AccidentListModel.h"
#import "AccidentDetailsModel.h"

#pragma mark - 获取快处事故通用值API

@interface FastAccidentGetCodesManger:LRBaseRequest

/****** 请求数据 ******/
/***请求参数中有token值，运用统一添加参数的办法添加到后面所有需要token参数的请求中,具体调用LRBaseRequest中的+ (void)setupRequestFilters:(NSDictionary *)arguments 方法***/

/****** 返回数据 ******/
/*这里因为和事故的通用值返回的参数一样，故不创建新的对象来当返回数据，直接调用
AccidentGetCodesResponse来当返回参数，具体详情请查看AccidentGetCodesResponse对象
*/
@property (nonatomic, strong) AccidentGetCodesResponse * fastAccidentGetCodesResponse;

@end

#pragma mark - 快处事故增加API(旧)

@interface FastAccidentSaveManger:LRBaseRequest

/****** 请求数据 ******/
/*这里因为和事故的请求参数参数一样，故不创建新的对象来当返回数据，直接调用
AccidentSaveParam来当返回参数，具体详情请查看AccidentSaveParam对象
*/

@property (nonatomic, strong) AccidentSaveParam * param;

/****** 返回数据 ******/
//无返回参数

@end


#pragma mark - 快处事故增加API

@interface FastAccidentUpManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) AccidentUpParam *param;
@property (nonatomic, assign) BOOL isUpCache;
@property (nonatomic, assign) CGFloat progress;
/****** 返回数据 ******/
//无返回参数

@end



#pragma mark - 快处事故列表API

@interface FastAccidentListPagingParam : NSObject

@property (nonatomic,assign) NSInteger  start;      //开始的索引号 从0开始
@property (nonatomic,assign) NSInteger  length;     //显示的记录数 默认为10
@property (nonatomic,copy)   NSString * search;     //搜索的关键字
//@property (nonatomic,strong) NSNumber * isHandle;   //选填，1已处理 0未处理

@end


@interface FastAccidentListPagingReponse : NSObject

@property (nonatomic,copy) NSArray <AccidentListModel *> * list;  //包含AccidentListModel对象
@property (nonatomic,assign) NSInteger total;                     //总数


@end


@interface FastAccidentListPagingManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) FastAccidentListPagingParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) FastAccidentListPagingReponse * fastAccidentListPagingReponse;

@end


#pragma mark - 快处事件详情API

@interface FastAccidentDetailsManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * fastaccidentId;

/****** 返回数据 ******/
@property (nonatomic, strong) AccidentDetailsModel * fastAccidentDetailModel;


@end

#pragma mark - 用户提交的快处信息

@interface AccidentDisposePeopelModel : NSObject

@property (nonatomic,strong) NSNumber * peopleId;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,strong) NSNumber * responsibilityId;

@end


@interface FastAccidentDetailManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * accidentId; //事故ID

/****** 返回数据 ******/
@property (nonatomic, strong) NSArray <AccidentDisposePeopelModel *> * accidentFastPeopleModel;

@end

#pragma mark - 处理用户提交的快处信息

@interface FastAccidentDealAccidentParam : NSObject



@property (nonatomic, strong) NSNumber * accidentId; //事故ID
@property (nonatomic, strong) NSArray <AccidentDisposePeopelModel *> * accidentInfoList;

@end



@interface FastAccidentDealAccidentManger:LRBaseRequest

/****** 请求数据 ******/

@property (nonatomic, copy) NSString * accidentJson;


@end

#pragma mark - 是否有权限处理用户提交的快处信息


@interface FastAccidentCheckPermissManger:LRBaseRequest

/****** 请求数据 ******/

@property (nonatomic, strong) NSNumber * hasPermiss;

@end


#pragma mark - 处理用户提交的快处信息

@interface FastAccidentAuditAccidentManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * accidentId; //事故ID


@end
