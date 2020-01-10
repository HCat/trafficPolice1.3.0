//
//  PeoplePointAnnotation.h
//  移动采集
//
//  Created by hcat-89 on 2020/1/9.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "DailyPatrolLocationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PeoplePointAnnotation : MAPointAnnotation

@property(nonatomic,strong) DailyPatrolLocationModel * model;

@end

NS_ASSUME_NONNULL_END
