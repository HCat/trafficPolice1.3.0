//
//  VehicleTypeVC.h
//  移动采集
//
//  Created by 黄芦荣 on 2021/9/8.
//  Copyright © 2021 Hcat. All rights reserved.
//

#import "BaseViewController.h"
#import "HideTabSuperVC.h"

#import "CommonAPI.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^VehicleTypeBlock)(CommonGetVehicleModel  * model);


@interface VehicleTypeVC : HideTabSuperVC

@property (nonatomic,copy) VehicleTypeBlock vehicleTypeBlock;

@property (nonatomic,copy, nullable) NSArray *arr_content;
@property (nonatomic,copy) NSArray *arr_temp; //用于临时存储总数据
@property (nonatomic,copy) NSString * search_text;  //搜索字段


@end

NS_ASSUME_NONNULL_END
