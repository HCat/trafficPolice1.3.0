//
//  VehicleDriverCell.h
//  移动采集
//
//  Created by hcat-89 on 2017/9/8.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleDriverModel.h"

typedef void(^VehicleDriverNoShowBlock)();

@interface VehicleDriverCell : UITableViewCell

@property(nonatomic,strong)VehicleDriverModel *driver;

@property (nonatomic,copy) VehicleDriverNoShowBlock block;

@end
