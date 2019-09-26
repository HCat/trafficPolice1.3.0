//
//  ParkingManageViewModel.h
//  移动采集
//
//  Created by hcat on 2019/9/17.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParkingManagementAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParkingManageViewModel : NSObject

@property (nonatomic, strong) NSNumber * type;                  //0车牌号1强制单号 2 车架号
@property (nonatomic, copy, nullable) NSString * keywords;      //搜索内容
@property(strong, nonatomic) NSNumber * index;                  //分页第几页
@property (nonatomic, strong) NSMutableArray * arr_data;        //列表中显示单元Cell信息的ViewModel
@property (nonatomic, strong) RACCommand * searchCommand;       //搜索请求

@end

NS_ASSUME_NONNULL_END
