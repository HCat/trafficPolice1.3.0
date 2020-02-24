//
//  IllegalAddListViewModel.h
//  移动采集
//
//  Created by hcat-89 on 2020/2/19.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IllegalAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface IllegalAddListViewModel : NSObject

@property(strong, nonatomic)  NSNumber * start;
@property(copy, nonatomic,nullable)  NSString * search;
@property (nonatomic,strong,nullable) NSNumber *  state;   //上报状态
@property (nonatomic, strong) NSMutableArray * arr_content;
@property(nonatomic, strong) RACCommand * command_loadList;       //加载列表
@property (nonatomic,strong) NSNumber * permission;               //确认异常权限 true有 false没有

@end

NS_ASSUME_NONNULL_END
