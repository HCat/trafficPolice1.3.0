//
//  PoliceDetailDisAnnotationView.h
//  移动采集
//
//  Created by hcat on 2018/11/19.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoliceLocationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PoliceDetailDisAnnotationView : UIView

@property (nonatomic, strong) PoliceLocationModel * policeModel;

+ (PoliceDetailDisAnnotationView *)initCustomView;

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
