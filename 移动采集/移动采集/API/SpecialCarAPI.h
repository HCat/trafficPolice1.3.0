//
//  SpecialCarAPI.h
//  移动采集
//
//  Created by hcat on 2018/9/11.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "LRBaseRequest.h"

#pragma mark - 特殊传车辆管理组的获取和组的车牌获取API

@interface SpecialCarModel : NSObject

@property (nonatomic,strong) NSNumber   * carId;    //车牌id
@property (nonatomic,copy)   NSString   * name;     //组名称,也可车牌号(查询用)
@property (nonatomic,strong) NSNumber   * parentId; //组的id
@property (nonatomic,copy)   NSString   * remark;   //备注

@end

@interface SpecialGroupListParam : NSObject

@property (nonatomic,assign) NSInteger  start;      //开始的索引号 从1开始
@property (nonatomic,assign) NSInteger  length;     //显示的记录数 默认为10
@property (nonatomic,strong) NSNumber   * parentId; //组的id
@property (nonatomic,copy)   NSString   * name;     //组名称,也可车牌号(查询用)

@end

@interface SpecialGroupListReponse : NSObject

@property (nonatomic,copy)   NSArray<SpecialCarModel * > * list;    //包含SpecialCarModel对象
@property (nonatomic,assign) NSInteger total;    //总数


@end

@interface SpecialGroupListManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) SpecialGroupListParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) SpecialGroupListReponse * specialReponse;


@end

#pragma mark - 特殊传车辆管理获取识别记录列表API

@interface SpecialRecordModel : NSObject

@property (nonatomic,strong) NSNumber   * recordId;     //记录id
@property (nonatomic,strong) NSNumber   * parentId;     //组Id （Long）
@property (nonatomic,strong) NSNumber   * happenTime;   //时间
@property (nonatomic,copy)   NSString   * originalPic;  //图片
@property (nonatomic,copy)   NSString   * groupName;    //组名称 （String）
@property (nonatomic,copy)   NSString   * carno;        //车牌 （String）
@property (nonatomic,copy)   NSString   * color;        //车颜色  （String）
@property (nonatomic,copy)   NSString   * address;      //地址 （String）
@property (nonatomic,copy)   NSString   * devno;      //地址 （String）
@end

@interface SpecialRecordListParam : NSObject

@property (nonatomic,assign) NSInteger  start;      //开始的索引号 从1开始
@property (nonatomic,assign) NSInteger  length;     //显示的记录数 默认为10
@property (nonatomic,strong) NSNumber   * groupId;   //组id  筛选的时候传 （Long）
@property (nonatomic,copy)   NSString   *carno;    //车牌号 搜索的时候传 （String）

@end

@interface SpecialRecordListReponse : NSObject

@property (nonatomic,copy)   NSArray<SpecialRecordModel * > * list;    //包含SpecialRecordModel对象
@property (nonatomic,assign) NSInteger total;    //总数


@end

@interface SpecialRecordListManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) SpecialRecordListParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) SpecialRecordListReponse * specialReponse;


@end

#pragma mark - 特殊传车辆管理获取识别记录详情

@interface SpecialRecordDetailModel : NSObject

@property (nonatomic,copy)   NSString   * groupName;     //组名称
@property (nonatomic,copy)   NSString   * devno;     //设备编号 （String）
@property (nonatomic,copy)   NSString   * carno;     //车牌
@property (nonatomic,copy)   NSString   * originalPic;     //图片
@property (nonatomic,strong) NSNumber   * happenTime;     //识别时间戳
@property (nonatomic,copy)   NSString   * address;     //地址

@end


@interface SpecialRecordDetailManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * recordId;

/****** 返回数据 ******/
@property (nonatomic, strong) SpecialRecordDetailModel * specialReponse;


@end

#pragma mark - 特殊车辆管理保存组合保存车辆

@interface SpecialSaveGroupParam : NSObject

@property (nonatomic,copy)   NSString   * remark;         //备注
@property (nonatomic,assign) NSNumber   * parentId;     //父id  添加车辆和修改车辆的时候需要传，其实就等于组ID
@property (nonatomic,strong) NSNumber   * groupId;      //组id  筛选的时候传 （Long）
@property (nonatomic,copy)   NSString   * name;         //车牌号 搜索的时候传 （String）

@end


@interface SpecialSaveGroupManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) SpecialSaveGroupParam * param;


@end

#pragma mark - 删除车辆

@interface SpecialDeleteManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic,strong) NSNumber   * groupId;      //组id  筛选的时候传 （Long）


@end

#pragma mark - 获取设置通知人员列表


@interface SpecialNoticeModel : NSObject

@property (nonatomic,strong) NSNumber   * noticeId;     //组id
@property (nonatomic,copy)   NSString   * name;         //"特殊车牌1组", 名称
@property (nonatomic,assign) NSInteger  flag;           //是否选中  1未选中 0选中


@end


@interface SpecialNoticeParam : NSObject

@property (nonatomic,assign) NSInteger  start;      //开始的索引号 从1开始
@property (nonatomic,assign) NSInteger  length;     //显示的记录数 默认为10
@property (nonatomic,strong) NSNumber   * groupId;  //组id  筛选的时候传 （Long）
@property (nonatomic,strong) NSNumber   * userId;    //登录用户id 必传

@end

@interface SpecialNoticeReponse : NSObject

@property (nonatomic,copy)   NSArray<SpecialNoticeModel * > * list;    //包含SpecialNoticeModel对象
@property (nonatomic,assign) NSInteger total;    //总数


@end


@interface SpecialNoticeManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) SpecialNoticeParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) SpecialNoticeReponse * specialReponse;


@end

#pragma mark - 保存置通知人员

@interface SpecialSaveNoticeManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic,strong) NSNumber   * groupId;      //组id  筛选的时候传 （Long）
@property (nonatomic,copy) NSString   * ids; //组id字符串 选几个人员就将id拼接起来，用逗号隔开，例子: 1,35,21

@end

