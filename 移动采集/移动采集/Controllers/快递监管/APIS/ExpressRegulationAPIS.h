//
//  ExpressRegulationAPIS.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/29.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "LRBaseRequest.h"

#pragma mark - 根据条件查询快递员列表API

@interface ExpressRegulationListItem: NSObject

@property (nonatomic,copy)   NSString * expressRegulationId;
@property (nonatomic,copy)   NSString * courierName;
@property (nonatomic,copy)   NSString * telephone;
@property (nonatomic,copy)   NSString * licenseNo;
@property (nonatomic,copy)   NSString * frameNo;
@property (nonatomic,strong) NSNumber * score;
@property (nonatomic,strong) NSNumber * scoreCount;
@property (nonatomic,copy)   NSString * orgNo;
@property (nonatomic,strong) NSNumber * createTime;
@property (nonatomic,strong) NSNumber * updateTime;


@end



@interface ExpressRegulationListParam : NSObject

@property (nonatomic,strong) NSNumber * start;          //开始的索引号 从0开始
@property (nonatomic,strong) NSNumber * length;         //显示的记录数 默认为10
@property (nonatomic,copy)   NSString * searchName;     //搜索的关键字
@property (nonatomic,strong) NSNumber * searchType;     //字段类型:Integer，0 姓名 1身份证  2车架号 3 车牌号


@end


@interface ExpressRegulationListReponse : NSObject

@property (nonatomic,copy) NSArray < ExpressRegulationListItem *> * list;    //包含IllegalParkListModel对象
@property (nonatomic,assign) NSInteger total;                           //总数

@end

@interface ExpressRegulationListManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) ExpressRegulationListParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) ExpressRegulationListReponse * takeOutReponse;

@end


#pragma mark - 详情


@interface ExpressRegulationDetailReponse:NSObject

@property (nonatomic,copy)   NSString * plateNo;     //"885522",
@property (nonatomic,copy)   NSString * address;     //"中上路",
@property (nonatomic,copy)   NSString * chargePerson;     //"柯兰",
@property (nonatomic,copy)   NSString * powerNo;     //"9966331",
@property (nonatomic,copy)   NSString * licenseNo;     //"35068119920602020",
@property (nonatomic,copy)   NSString * frameNo;     //"996633",
@property (nonatomic,copy)   NSString * companyName;     //"中国邮政集团有限公司福建省晋江市分公司",
@property (nonatomic,copy)   NSString * telephone;     //"159592652212",
@property (nonatomic,copy)   NSString * name;     //柯某某",
@property (nonatomic,copy)   NSString * chargePhone;     //"15956261629"


@end


@interface ExpressRegulationDetailManger:LRBaseRequest

@property (nonatomic, copy) NSString * vehicleId;          //手机号码

/****** 返回数据 ******/
@property (nonatomic, strong) ExpressRegulationDetailReponse * takeOutReponse;

@end
