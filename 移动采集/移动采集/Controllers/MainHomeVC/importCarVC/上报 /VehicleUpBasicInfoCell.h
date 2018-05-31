//
//  VehicleUpBasicInfoCell.h
//  移动采集
//
//  Created by hcat on 2018/5/15.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleAPI.h"

@interface VehicleUpBasicInfoCell : UITableViewCell

@property (nonatomic,strong) VehicleCarlUpParam *param;

- (void)startLocation;

- (void)getRoadId;

@end
