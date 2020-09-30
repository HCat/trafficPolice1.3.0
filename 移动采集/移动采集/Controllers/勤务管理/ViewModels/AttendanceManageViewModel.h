//
//  AttendanceManageViewModel.h
//  移动采集
//
//  Created by hcat on 2019/4/3.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonAPI.h"
#import "PoliceDistributeAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface AttendanceManageViewModel : NSObject

@property (nonatomic,strong) NSNumber * departmentId;           //部门ID
@property (nonatomic,copy)   NSString * departmentName;         //部门名称
@property (nonatomic,strong) NSNumber * groupId;                //分组ID
@property (nonatomic,copy)   NSString * groupName;              //分组名称
@property (nonatomic, copy) NSString * workDateStr;             //时间 

@property (nonatomic, strong) NSMutableArray * arr_department;  //部门数组
@property (nonatomic, strong) NSNumber * count_department;      //部门数组数目
@property (nonatomic, strong) NSMutableArray * arr_group;       //分组数组
@property (nonatomic, strong) NSNumber * count_group;           //分组数组数目

@property (nonatomic, strong) RACCommand * command_department;  //部门请求
@property (nonatomic, strong) RACCommand * command_group;       //分组请求

@property(strong, nonatomic)  NSMutableArray * arr_polices;      //警员数组
@property(strong, nonatomic)  NSNumber * index_polices;          //警员数组索引
@property (nonatomic, strong) RACCommand * command_polices;      //警员列表请求


@end

NS_ASSUME_NONNULL_END
