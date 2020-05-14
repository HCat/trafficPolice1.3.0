//
//  VehicleDriverNoShowCell.h
//  移动采集
//
//  Created by hcat-89 on 2017/9/8.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleDriverModel.h"

typedef void(^VehicleDriverShowBlock)();

@interface VehicleDriverNoShowCell : UITableViewCell

@property(nonatomic,strong)VehicleDriverModel *driver;

@property (nonatomic,copy) VehicleDriverShowBlock block;

@end
