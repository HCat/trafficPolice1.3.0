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

typedef void(^VehicleCarNoShowBlock)(void);
typedef void(^VehicleCarEditBlock)(void);

@interface VehicleCarCell : UITableViewCell

@property (nonatomic,strong) VehicleModel * vehicle;
@property (nonatomic,strong) NSMutableArray <VehicleImageModel *> * imagelists;
@property (nonatomic,strong) NSNumber *isReportEdit;

@property (nonatomic,copy) VehicleCarNoShowBlock block;
@property (nonatomic,copy) VehicleCarEditBlock editBlock;

@end
