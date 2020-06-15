//
//  ActionAPI.h
//  移动采集
//
//  Created by hcat on 2018/8/1.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "LRBaseRequest.h"

#pragma mark - 获取行动分页列表API

@interface ActionListModel : NSObject

@property (nonatomic,strong) NSNumber   * actionId;           //行动id
@property (nonatomic,copy) NSString   * actionName;         //行动名称
@property (nonatomic,strong) NSNumber * status;             //行动状态
@property (nonatomic,copy) NSString   * createName;         //创建人名称
@property (nonatomic,strong) NSNumber * createTime;         //创建时间
@property (nonatomic,copy) NSString   * createPhone;        //创建人电话
@property (nonatomic,copy) NSString   * publishName;        //发布人名称
@property (nonatomic,strong) NSNumber * publishTime;        //发布时间
@property (nonatomic,copy) NSString   * publishPhone;       //发布人电话
@property (nonatomic,copy) NSString   * endName;            //结束人名称
@property (nonatomic,strong) NSNumber * endTime;            //结束时间
@property (nonatomic,copy) NSString   * endPhone;           //结束人电话

@end


@interface ActionPageListParam : NSObject

@property (nonatomic,assign) NSInteger  start;      //开始的索引号 从0开始
@property (nonatomic,assign) NSInteger  length;     //显示的记录数 默认为10
@property (nonatomic,strong) NSNumber  *status;     //显示的记录数 默认为10
@property (nonatomic,copy)   NSString * actionName;     //搜索的关键字

@end

@interface ActionPageListReponse : NSObject

@property (nonatomic,copy)   NSArray<ActionListModel * > * list;    //包含ActionListModel对象
@property (nonatomic,assign) NSInteger total;    //总数


@end


@interface ActionPageListManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) ActionPageListParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) ActionPageListReponse * acctionReponse;

@end

#pragma mark - 行动详情

//人员信息列表

@interface ActionPeopleModel : NSObject

@property (nonatomic, strong) NSNumber *userId;             //人员id
@property (nonatomic, copy) NSString * userName;           //人员名称
@property (nonatomic, copy) NSString * userPhone;          //人员电话

@end


//taskShowList列表
@interface ActionShowListModel :NSObject

@property (nonatomic, copy) NSString * name;           //字段名称
@property (nonatomic, copy) NSString * content;        //字段内容
@property (nonatomic, strong) NSNumber * type;           //字段类型
@property (nonatomic,copy)   NSArray<ActionPeopleModel * > * peopleArr;      //人员列表


@end


//actionTaskList列
@interface ActionTaskListModel :NSObject

@property (nonatomic,copy)   NSArray<ActionShowListModel * > *taskShowList;           //任务展示列表
@property (nonatomic, strong) NSNumber * taskId;                 //任务id
@property (nonatomic, copy) NSString * taskTitle;               //任务标题
@property (nonatomic, strong) NSNumber * actionStatus;          //行动状态    0=未发布  1=已发布 2=已结束
@property (nonatomic, strong) NSNumber * longitude;             //经度
@property (nonatomic, strong) NSNumber * latitude;              //维度



@end


@interface ActionInfoModel : NSObject

@property (nonatomic, strong) NSNumber * actionId;         //行动id
@property (nonatomic, copy) NSString * actionName;         //行动名称
@property (nonatomic, copy) NSString * actionContent;      //行动内容
@property (nonatomic, strong) NSNumber * status;           //任务状态


@end


@interface ActionDetailReponse :NSObject

@property (nonatomic,strong)   NSArray<ActionTaskListModel * > *actionTaskList;           //行动任务列表
@property (nonatomic, strong) ActionInfoModel * action;

@end

@interface ActionDetailManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * actionId; //行动ID
/****** 返回数据 ******/
@property (nonatomic, strong) ActionDetailReponse * acctionReponse;

@end

#pragma mark - 更改行动状态


@interface ActionChangeStatusManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * actionId; //行动ID
@property (nonatomic, strong) NSNumber * status; //行动状态


@end


#pragma mark - 根据类型选择行动

@interface ActionGetTypeListParam : NSObject

@property (nonatomic,assign) NSInteger  start;   //开始的索引号 从0开始
@property (nonatomic,assign) NSInteger  length;  //显示的记录数 默认为10
@property (nonatomic,strong) NSNumber  *actionStatus;  //0=未发布  1=已发布 2=已结束，全部不传
@end


@interface ActionGetTypeListReponse : NSObject

@property (nonatomic,copy) NSArray < ActionTaskListModel *> * list;    //包含IllegalParkListModel对象
@property (nonatomic,assign) NSInteger total;                           //总数

@end

@interface ActionGetTypeListManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) ActionGetTypeListParam * param;

/****** 返回数据 ******/
@property (nonatomic, strong) ActionGetTypeListReponse * actionReponse;

@end





