//
//  TaskFlowsListModel.h
//  移动采集
//
//  Created by hcat-89 on 2020/3/3.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskFlowsListModel : NSObject

@property (nonatomic, strong) NSNumber * taskFlowsId;   //任务流编号    integer
@property (nonatomic, strong)   NSNumber * status;      //任务状态    String
@property (nonatomic, copy)   NSString * userPolice;    //转发人员
@property (nonatomic, copy)   NSString * content;       //任务内容    String
@property (nonatomic, copy)   NSString * complaintName; 
@property (nonatomic, copy)   NSString * complaintPhone;
@property (nonatomic, strong) NSNumber * createTime;    //创建时间    Date
@property (nonatomic, copy)   NSString * createPolice;  //创建警员    String
@property (nonatomic, strong) NSNumber * replyCount;    //回复条数    integer
@property (nonatomic, strong) NSNumber * type;          //任务类型    0你是我的眼 1警务任务 2疫情复工 3.车辆通行证
@property (nonatomic, copy)   NSString * startPoint;          //起点地址
@property (nonatomic, copy)   NSString * endPoint;          //终点地址
@property (nonatomic, copy)   NSString * carNo;          //车牌


- (void)showPhotoBrowser:(NSArray *)photos inView:(UITableViewCell *)cell withTag:(long)tag;

@end

NS_ASSUME_NONNULL_END
