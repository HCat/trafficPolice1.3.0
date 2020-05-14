//
//  DailyPatrolAnnotationView.h
//  移动采集
//
//  Created by hcat-89 on 2020/4/13.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@class DailyPatrolAnnotation;


typedef void(^DailyPatrolAnnotationBlock)(DailyPatrolAnnotation *carAnnotation);

@interface DailyPatrolAnnotationView : MAAnnotationView

@property(nonatomic,copy) DailyPatrolAnnotationBlock block;

//一定要重写，否则当滑动地图，annotation出现和消失时候会出现数据混乱
- (void)setAnnotation:(id<MAAnnotation>)annotation;


@end


