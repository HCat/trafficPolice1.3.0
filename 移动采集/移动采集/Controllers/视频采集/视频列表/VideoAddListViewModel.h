//
//  VideoAddListViewModel.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/29.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "BaseViewModel.h"
#import "VideoColectAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoAddListViewModel : BaseViewModel

@property(nonatomic,assign) int type; // 1表示正常列表页面  2表示搜索列表页面

@property (nonatomic,strong) NSMutableArray *arr_content;
@property (nonatomic,assign) NSInteger index; //加载更多数据索引
@property (nonatomic,copy) NSString *str_search;
@property (nonatomic, strong) RACCommand * command_list;



@end

NS_ASSUME_NONNULL_END
