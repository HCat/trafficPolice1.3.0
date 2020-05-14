//
//  TaskFlowsReplyModel.h
//  移动采集
//
//  Created by hcat-89 on 2020/3/5.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskFlowsReplyModel : NSObject

@property (nonatomic, copy)   NSString * replyContent;      //回复内容    String
@property (nonatomic, strong) NSNumber * createTime;        //创建时间    date
@property (nonatomic, copy)   NSString * sendUser;          //回复人姓名    String
@property (nonatomic, strong) NSNumber * replyType;         //0转发回复  1 完成回复
@property (nonatomic, strong) NSNumber * replyStatus;       //1未审核 2不通过 3通过
@property (nonatomic, strong) NSString * receiveUserName;   //接收人


@end

NS_ASSUME_NONNULL_END
