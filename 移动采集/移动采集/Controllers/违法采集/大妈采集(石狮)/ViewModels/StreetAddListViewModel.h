//
//  StreetAddListViewModel.h
//  移动采集
//
//  Created by 黄芦荣 on 2021/4/6.
//  Copyright © 2021 Hcat. All rights reserved.
//

#import "BaseViewModel.h"
#import "IllegalAPI.h"
#import "StreetAPIS.h"

NS_ASSUME_NONNULL_BEGIN

@interface StreetAddListViewModel : BaseViewModel

@property(strong, nonatomic)  NSNumber * start;
@property(copy, nonatomic,nullable)  NSString * search;
@property (nonatomic,strong,nullable) NSNumber *  state;   //上报状态
@property (nonatomic, strong) NSMutableArray * arr_content;
@property(nonatomic, strong) RACCommand * command_loadList;       //加载列表
@property (nonatomic,strong) NSNumber * permission;               //确认异常权限 true有 false没有


@end

NS_ASSUME_NONNULL_END
