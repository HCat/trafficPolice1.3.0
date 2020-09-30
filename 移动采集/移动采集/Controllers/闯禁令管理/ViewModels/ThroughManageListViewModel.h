//
//  ThroughManageListViewModel.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/27.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "BaseViewModel.h"
#import "ThroughManageAPIS.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThroughManageListViewModel : BaseViewModel

@property (nonatomic, strong) ThroughManageListPagingParam * param;

@property (nonatomic,strong) NSMutableArray *arr_content;

@property (nonatomic, strong) RACCommand * command_list;

@property(nonatomic,assign) int type; // 1表示正常列表页面  2表示搜索列表页面

@end

NS_ASSUME_NONNULL_END
