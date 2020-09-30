//
//  ThroughManageShowViewModel.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/30.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "BaseViewModel.h"
#import "ThroughManageAPIS.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThroughManageShowViewModel : BaseViewModel

@property (nonatomic, strong) ThroughManageListPagingParam * param;


@property (nonatomic,strong) NSMutableArray *arr_content;

@property (nonatomic, strong) RACCommand * command_list;
@end

NS_ASSUME_NONNULL_END
