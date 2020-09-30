//
//  MainAllListViewModel.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/14.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "BaseViewModel.h"
#import "MainAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainAllListViewModel : BaseViewModel

@property (nonatomic, copy) NSString * menuType;
@property(nonatomic,strong) NSMutableArray * arr_items;

@property(nonatomic,strong) RACCommand * command_common;

@end

NS_ASSUME_NONNULL_END
