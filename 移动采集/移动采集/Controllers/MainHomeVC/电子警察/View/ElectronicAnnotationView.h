//
//  ElectronicAnnotationView.h
//  移动采集
//
//  Created by hcat-89 on 2020/4/24.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@class ElectronicAnnotation;

typedef void(^ElectronicAnnotationBlock)(ElectronicAnnotation *carAnnotation);

@interface ElectronicAnnotationView : MAAnnotationView

@property(nonatomic,copy) ElectronicAnnotationBlock block;

//一定要重写，否则当滑动地图，annotation出现和消失时候会出现数据混乱
- (void)setAnnotation:(id<MAAnnotation>)annotation;


@end


