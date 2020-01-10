//
//  DailyPatrolListViewModel.h
//  移动采集
//
//  Created by hcat-89 on 2020/1/8.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailyPatrolListViewModel : NSObject

@property (nonatomic, strong) NSMutableArray * arr_data;     
@property(strong, nonatomic) RACCommand * loadCommand;

@end

NS_ASSUME_NONNULL_END
