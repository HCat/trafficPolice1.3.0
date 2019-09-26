//
//  ParkingForensicsListViewModel.h
//  移动采集
//
//  Created by hcat on 2019/7/25.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParkingForensicsAPI.h"


NS_ASSUME_NONNULL_BEGIN

@interface ParkingForensicsListViewModel : NSObject

@property(strong, nonatomic)  NSNumber * longitude;
@property(strong, nonatomic)  NSNumber * latitude;
@property(strong, nonatomic)  NSNumber * index;          //分页第几页
@property (nonatomic, strong) NSMutableArray * arr_content;
@property(nonatomic,strong)   RACCommand * requestCommand;

@end

NS_ASSUME_NONNULL_END
