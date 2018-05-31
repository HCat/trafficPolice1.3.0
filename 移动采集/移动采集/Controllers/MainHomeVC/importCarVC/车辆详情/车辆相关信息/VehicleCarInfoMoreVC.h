//
//  VehicleCarInfoMoreVC.h
//  移动采集
//
//  Created by hcat on 2018/5/15.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "VehicleRequestType.h"
#import "VehicleAPI.h"

@interface VehicleCarInfoMoreVC : HideTabSuperVC

@property(nonatomic,assign) VehicleCellType infoType;

@property (nonatomic,strong) VehicleDetailReponse *reponse;
@property(nonatomic,strong) VehicleModel *vehicleModel;
@property(nonatomic,strong) MemberInfoModel *memberInfoModel;
@property(nonatomic,strong) VehicleDriverModel *vehicleDriverModel;


@end
