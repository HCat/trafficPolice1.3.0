//
//  ParkingForensicsVC.h
//  移动采集
//
//  Created by hcat on 2019/7/29.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "ParkingForensicsViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ParkingForensicsSuccessBlock)(void);

@interface ParkingForensicsVC : HideTabSuperVC

@property(nonatomic,copy) ParkingForensicsSuccessBlock block;

- (instancetype)initWithViewModel:(ParkingForensicsViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
