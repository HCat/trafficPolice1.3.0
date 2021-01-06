//
//  AccidentListViewModel.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/10/30.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "BaseViewModel.h"
#import "AccidentAPI.h"
#import "FastAccidentAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccidentListViewModel : BaseViewModel

@property(nonatomic,assign) AccidentType accidentType;

@property(nonatomic,assign) int type; // 1表示正常列表页面  2表示搜索列表页面



@property (nonatomic,strong) NSMutableArray *arr_content;
@property (nonatomic,assign) NSInteger index; //加载更多数据索引
@property (nonatomic,copy) NSString *str_search;


@property (nonatomic,assign) NSInteger stateType; //0 未结案 1结案 2关注 3全部
@property (nonatomic,copy) NSString * str_car;
@property (nonatomic,copy) NSString * str_name;
@property (nonatomic,copy) NSString * str_address;
@property (nonatomic,copy) NSString * str_startTime;
@property (nonatomic,copy) NSString * str_endTime;


@property (nonatomic, strong) RACCommand * command_list;

@end

NS_ASSUME_NONNULL_END
