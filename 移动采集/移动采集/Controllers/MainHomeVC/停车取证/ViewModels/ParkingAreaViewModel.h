//
//  ParkingAreaViewModel.h
//  移动采集
//
//  Created by hcat on 2019/7/26.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParkingForensicsAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParkingAreaViewModel : NSObject

@property(strong, nonatomic, nullable)  NSString * parklotid;     
@property(strong, nonatomic)  NSNumber * index;          //分页第几页


@property (nonatomic, strong) NSMutableArray * arr_content;
@property (nonatomic,strong) NSMutableArray * arr_group;

@property(nonatomic,strong)   RACCommand * requestCommand;
@property(nonatomic,strong)   RACCommand * groupCommand;

@end

NS_ASSUME_NONNULL_END
