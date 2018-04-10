//
//  VehicleSearchListVC.h
//  移动采集
//
//  Created by hcat on 2018/4/4.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "LRSettingItemModel.h"
#import "VehicleAPI.h"

typedef NS_ENUM(NSUInteger, SearchType){
    SearchTypePlatNo = 1,
    SearchTypeSinceNumber = 2
};



@interface SearchCarItemModel : LRSettingItemModel

@property (nonatomic, strong) VehicleListModel * vehicleModel;

@end

@interface VehicleSearchListVC : HideTabSuperVC

@end
