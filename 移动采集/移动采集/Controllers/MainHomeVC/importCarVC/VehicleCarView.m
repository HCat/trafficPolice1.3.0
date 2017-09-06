//
//  VehicleCarView.m
//  移动采集
//
//  Created by hcat on 2017/9/6.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "VehicleCarView.h"

@implementation VehicleCarView

- (void)setCarType:(NSNumber *)carType{

    _carType = carType;
    if ([_carType isEqualToNumber:@1]) {
        self.image = [UIImage imageNamed:@"map_policeCar"];
    }else{
        self.image = [UIImage imageNamed:@"map_truck"];
    
    }
    
}

@end
