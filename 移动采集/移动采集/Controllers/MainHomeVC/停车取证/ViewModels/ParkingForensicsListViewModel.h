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
@property(strong, nonatomic)  NSNumber * index;
@property(strong, nonatomic, nullable)  NSString * parklotid;//分页第几页
@property (nonatomic, strong) NSMutableArray * arr_content;
@property(nonatomic,strong)   RACCommand * requestCommand;

@property (nonatomic,strong) NSMutableArray * arr_group;
@property(nonatomic,strong)   RACCommand * groupCommand;

@property(nonatomic, strong) RACCommand * command_isRegister;


@end

NS_ASSUME_NONNULL_END
