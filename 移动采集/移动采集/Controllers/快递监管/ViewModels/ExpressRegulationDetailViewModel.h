//
//  ExpressRegulationDetailViewModel.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/30.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "BaseViewModel.h"
#import "ExpressRegulationAPIS.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExpressRegulationDetailViewModel : BaseViewModel

@property(nonatomic, copy) NSString * vehicleId;
@property(nonatomic, strong) RACCommand * detail_command;


@end

NS_ASSUME_NONNULL_END
