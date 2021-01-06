//
//  AccidentHistoricalListViewmodel.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/11/13.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"
#import "AccidentMoreAPIs.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccidentHistoricalListViewmodel : BaseViewModel

@property (nonatomic, strong) AccidentMoreListPagingParam *param;
@property (nonatomic,strong) NSMutableArray *arr_content;
@property (nonatomic, strong) RACCommand * command_list;


@end

NS_ASSUME_NONNULL_END
