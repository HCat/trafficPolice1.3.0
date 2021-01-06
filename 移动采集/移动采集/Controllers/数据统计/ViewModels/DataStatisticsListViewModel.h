//
//  DataStatisticsListViewModel.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/12/16.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "BaseViewModel.h"
#import "DataStatisticsAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataStatisticsListViewModel : BaseViewModel


@property (nonatomic, strong) NSNumber * accidentState;
@property (nonatomic, copy) NSString * timeType;

@property (nonatomic,strong) NSMutableArray *arr_content;
@property (nonatomic,assign) NSInteger index; 
@property (nonatomic, strong) RACCommand * command_list;



@end

NS_ASSUME_NONNULL_END
