//
//  TaskModel.h
//  移动采集
//
//  Created by hcat on 2017/11/3.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskModel : NSObject

@property (nonatomic,strong) NSNumber * taskId;     //任务id
@property (nonatomic,copy)   NSString * taskName;   //任务名称
@property (nonatomic,strong) NSNumber * arrivalTime;//到岗时间
@property (nonatomic,copy)   NSString * taskStatus; //任务状态
@property (nonatomic,copy)   NSString * address;    //任务地址
@property (nonatomic,copy)   NSString * content;    //内容
@property (nonatomic,strong) NSNumber * longitude;  //经度
@property (nonatomic,strong) NSNumber * latitude;   //纬度


@end
