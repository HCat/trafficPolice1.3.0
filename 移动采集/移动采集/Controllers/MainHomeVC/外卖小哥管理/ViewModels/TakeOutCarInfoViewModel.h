//
//  TakeOutCarInfoViewModel.h
//  移动采集
//
//  Created by hcat on 2019/5/9.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TakeOutAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface TakeOutCarInfoViewModel : NSObject

@property(nonatomic,strong) DeliveryVehicleModel * model;

@property(nonatomic,copy) NSString * vehicleId;

@property(nonatomic,strong) RACCommand * requestCommand;


@end

NS_ASSUME_NONNULL_END
