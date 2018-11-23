//
//  PoliceDistributeAnnotation.h
//  移动采集
//
//  Created by hcat on 2018/11/14.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "PoliceLocationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PoliceDistributeAnnotation : MAPointAnnotation

@property (nonatomic,strong) PoliceLocationModel * policeModel;
@property (nonatomic,strong) NSNumber * policeType; //车辆类型, 1为警员,2为警车


@end

NS_ASSUME_NONNULL_END
