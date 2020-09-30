//
//  DriverChooseView.h
//  移动采集
//
//  Created by hcat on 2018/5/28.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleDriverModel.h"

typedef void(^DriverChooseViewBlock)(VehicleDriverModel *driverModel);

@interface DriverChooseView : UIView


@property (nonatomic,strong) NSArray *arr_driver;
@property (nonatomic,copy) DriverChooseViewBlock block;

+ (DriverChooseView *)initCustomView;


@end
