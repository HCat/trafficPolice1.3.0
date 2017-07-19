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
@property (nonatomic, strong) NSNumber * type;      //消息类型 1 识别车牌通知 2 出警推送消息
@property (nonatomic, strong) NSNumber * createTime;


@end
