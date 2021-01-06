//
//  DataStatisticsViewModel.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/11/11.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "BaseViewModel.h"
#import "DataStatisticsAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataStatisticsViewModel : BaseViewModel


@property (nonatomic, strong) NSNumber * accidentState;


@property (nonatomic, strong) RACCommand * command_list;

@property (nonatomic, strong) DataStatisticsReponse * dataStatisticsReponse;

@end

NS_ASSUME_NONNULL_END
