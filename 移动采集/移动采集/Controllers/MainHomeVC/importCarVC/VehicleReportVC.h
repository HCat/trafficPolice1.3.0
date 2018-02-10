//
//  VehicleReportVC.h
//  移动采集
//
//  Created by hcat on 2018/2/8.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "VehicleAPI.h"

typedef void(^VehicleReportVCBlock)(VehicleImageModel *imageModel,NSString *oldImgId,NSString *carriageOutsideH);

@interface VehicleReportVC : HideTabSuperVC

@property (nonatomic,strong) NSString *platNo;

@property (nonatomic,copy) VehicleReportVCBlock block;

@end
