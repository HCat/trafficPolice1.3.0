//
//  SearchImportCarVC.h
//  移动采集
//
//  Created by hcat on 2017/11/9.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "VehicleGPSModel.h"

@interface SearchImportCarVC : HideTabSuperVC

@property (nonatomic, strong) VehicleGPSModel * search_vehicleModel;
@property (nonatomic, assign) NSInteger type; //0 表示查找重点车辆 1表示违法位置
@end
