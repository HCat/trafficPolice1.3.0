//
//  VehicleCarCell.h
//  移动采集
//
//  Created by hcat on 2017/9/7.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleModel.h"
#import "VehicleAPI.h"

@interface VehicleCarCell : UITableViewCell

@property (nonatomic,strong) VehicleModel * vehicle;
@property (nonatomic,strong) NSArray <VehicleImageModel *> * imagelists;


@end
