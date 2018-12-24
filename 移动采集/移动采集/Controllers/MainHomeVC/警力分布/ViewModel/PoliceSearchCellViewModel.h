//
//  PoliceSearchCellViewModel.h
//  移动采集
//
//  Created by hcat on 2018/12/21.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoliceLocationModel.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "VehicleGPSModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PoliceSearchCellViewModel : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, strong) PoliceLocationModel * policeModel;
@property (nonatomic, strong) AMapPOI * poi;
@property (nonatomic, strong) VehicleGPSModel * carModel;

@end

NS_ASSUME_NONNULL_END
