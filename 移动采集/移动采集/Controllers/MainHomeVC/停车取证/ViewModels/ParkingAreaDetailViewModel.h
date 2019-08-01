//
//  ParkingAreaDetailViewModel.h
//  移动采集
//
//  Created by hcat on 2019/7/28.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParkingForensicsAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParkingAreaDetailViewModel : NSObject

@property(copy, nonatomic, nullable)  NSString * parkplaceId;

@property(nonatomic,strong)   RACCommand * requestCommand;
@property(nonatomic,strong)   RACCommand * noCarCommand;


@property(nonatomic,strong) ParkingAreaDetailModel * areaDetailModel;

@end

NS_ASSUME_NONNULL_END
