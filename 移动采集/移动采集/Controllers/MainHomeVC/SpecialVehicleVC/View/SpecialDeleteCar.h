//
//  SpecialDeleteCar.h
//  移动采集
//
//  Created by hcat on 2018/9/11.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialCarAPI.h"

@interface SpecialDeleteCar : UIView

@property (nonatomic,strong) SpecialCarModel * model;

+ (SpecialDeleteCar *)initCustomView;

- (void)show;

- (void)hide;

@end
