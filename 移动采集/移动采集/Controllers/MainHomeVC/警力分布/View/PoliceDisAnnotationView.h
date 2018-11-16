//
//  PoliceDisAnnotationView.h
//  移动采集
//
//  Created by hcat on 2018/11/14.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PoliceDistributeAnnotation;

@interface PoliceDisAnnotationView : MAAnnotationView


//一定要重写，否则当滑动地图，annotation出现和消失时候会出现数据混乱
- (void)setAnnotation:(id<MAAnnotation>)annotation;


@end

NS_ASSUME_NONNULL_END
