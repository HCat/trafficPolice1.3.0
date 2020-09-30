//
//  VehicleCarInfoVC.h
//  移动采集
//
//  Created by hcat on 2018/5/14.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleRequestType.h"
#import "VehicleAPI.h"

@interface VehicleCarInfoVC : UIViewController

@property (nonatomic,strong) VehicleDetailReponse *reponse;   //车辆基本信息
@property (nonatomic,assign) VehicleRequestType type;
@property (nonatomic,copy) NSString *nummberId;   //查询号，可以是车牌号也可以是二维码


@end
