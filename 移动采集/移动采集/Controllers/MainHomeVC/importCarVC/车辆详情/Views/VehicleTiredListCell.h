//
//  VehicleTiredListCell.h
//  移动采集
//
//  Created by hcat on 2018/5/24.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleAlarmModel.h"

@interface VehicleTiredListCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageV_preview;

@property(nonatomic,strong) VehicleTiredImageModel *model;

@end
