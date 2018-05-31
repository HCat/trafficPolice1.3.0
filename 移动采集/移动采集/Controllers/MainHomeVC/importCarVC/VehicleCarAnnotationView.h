//
//  VehicleCarAnnotationView.h
//  移动采集
//
//  Created by hcat on 2018/5/24.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@class VehicleCarAnnotation;

typedef void(^VehicleCarAnnotationBlock)(VehicleCarAnnotation *carAnnotation);

@interface VehicleCarAnnotationView : MAAnnotationView

@property(nonatomic,copy) VehicleCarAnnotationBlock block;

//一定要重写，否则当滑动地图，annotation出现和消失时候会出现数据混乱
- (void)setAnnotation:(id<MAAnnotation>)annotation;

@end
