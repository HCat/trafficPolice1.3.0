//
//  IdentifyModel.h
//  trafficPolice
//
//  Created by hcat on 2017/7/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdentifyModel : NSObject

@property (nonatomic, strong) NSNumber * msgId;     //主键
@property (nonatomic, copy)   NSString * title;     //标题
@property (nonatomic, copy)   NSString * content;   //内容
@property (nonatomic, strong) NSNumber * flag;      //标识 0未读  1已读
@property (nonatomic, strong) NSNumber * type;      //消息类型 1 识别车牌通知 2 事故报警 3警务消息 4非法车辆 系统消息(100排班通知 101任务通知) 停车取证  103
@property (nonatomic, strong) NSNumber * createTime;//创建时间
@property (nonatomic, strong) NSNumber * longitude; //经度
@property (nonatomic, strong) NSNumber * latitude;  //纬度
@property (nonatomic, strong) NSNumber * state;     //任务状态  0未完成 1完成，(type=2出警任务的状态)
@property (nonatomic, strong) NSNumber * source;    //0 来源列表  1来源通知


@end
