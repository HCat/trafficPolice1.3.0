//
//  DailyPatrolAnnotation.h
//  移动采集
//
//  Created by hcat-89 on 2020/4/13.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "DailyPatrolLocationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DailyPatrolAnnotation : MAPointAnnotation

@property(nonatomic, strong) DailyPatrolLocationModel * model;
@property(nonatomic, strong) NSNumber * type;

@end

NS_ASSUME_NONNULL_END
