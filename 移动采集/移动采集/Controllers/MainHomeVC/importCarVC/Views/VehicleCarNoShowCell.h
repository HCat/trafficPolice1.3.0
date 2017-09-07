//
//  VehicleCarNoShowCell.h
//  移动采集
//
//  Created by hcat-89 on 2017/9/7.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleModel.h"

typedef void(^VehicleCarShowBlock)();

@interface VehicleCarNoShowCell : UITableViewCell

@property (nonatomic,strong) VehicleModel * vehicle;

@property (nonatomic,copy) VehicleCarShowBlock block;

@end
