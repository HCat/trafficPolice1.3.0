//
//  ElectronicPoliceViewModel.h
//  移动采集
//
//  Created by hcat-89 on 2020/4/23.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ElectronicPoliceAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface ElectronicPoliceViewModel : NSObject

@property (nonatomic,strong)    NSMutableArray * arr_group;
@property (nonatomic,strong)    RACCommand * command_group;
@property (nonatomic,assign)    BOOL isSate;         //是否是卫星图层


@property (nonatomic,strong)    NSMutableArray * arr_detail;
@property (nonatomic,strong)    RACCommand * command_detail;


@property(nonatomic, strong) NSMutableArray * arr_point;    //存储标记点

@end

NS_ASSUME_NONNULL_END
