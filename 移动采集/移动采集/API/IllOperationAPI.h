//
//  IllOperationAPI.h
//  移动采集
//
//  Created by hcat on 2017/12/12.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "LRBaseRequest.h"


#pragma mark - 待监管车辆

@interface IllOperationBeSupervisedManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * carno;   //子任务id

/****** 返回数据 ******/

@end



#pragma mark - 豁免车辆

@interface IllOperationExemptCarnoManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, copy) NSString * carno;   //子任务id

/****** 返回数据 ******/

@end


@interface IllOperationCarDetail:NSObject


@property (nonatomic, copy)   NSString * title;     //标题
@property (nonatomic, copy)   NSString * content;   //内容
@property (nonatomic, strong) NSNumber * flag;      //标识 0未读  1已读
@property (nonatomic, strong) NSNumber * type;      //消息类型 1 识别车牌通知 2 出警推送消息 3警务消息 系统消息(100排班通知 101任务通知) 4非法营运

@property (nonatomic, strong) NSNumber * longitude; //经度
@property (nonatomic, strong) NSNumber * latitude;  //纬度

@property (nonatomic, copy)   NSString * devno;//设备编号
@property (nonatomic, copy)   NSString * carno;//车牌号
@property (nonatomic, copy)   NSString * address;//地址
@property (nonatomic, copy)   NSString * originalPic;//图片地址
@property (nonatomic, strong) NSNumber * isExempt;//是否豁免
@property (nonatomic, copy) NSString * createTime;//创建时间

@end


#pragma mark - 非法车辆详情

@interface IllOperationDetailManger:LRBaseRequest

/****** 请求数据 ******/
@property (nonatomic, strong) NSNumber * messageId;   //子任务id

/****** 返回数据 ******/

@property (nonatomic, strong) IllOperationCarDetail * illCarDetail; //非法车辆详情


@end


