//
//  PoliceDistributeViewModel.h
//  移动采集
//
//  Created by hcat on 2018/11/5.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PoliceDistributeViewModel : NSObject

@property (nonatomic,strong) RACCommand * locationCommand;          // 定位请求
@property (nonatomic,strong) RACSubject * locationSubject;          // 定位成功之后的热信号
@property (nonatomic,strong) RACSubject * loadingSubject;           // 用户移动位置之后的y用于请求数据的热信号
@property (nonatomic,strong) RACCommand * allPoliceCommand;         // 所有警员和警车位置数据请求
@property (nonatomic,strong) RACCommand * policeLocationCommand;    // 半径内警员位置数据请求

@property (nonatomic, strong) NSNumber * range;                     // 半径
@property (nonatomic, strong) NSNumber * latitude;                  // 纬度
@property (nonatomic, strong) NSNumber * longitude;                 // 经度


@property (nonatomic, strong) NSMutableArray * arr_data;            // 用来存请求数据
@property (nonatomic, strong) NSMutableArray * arr_point;           // 用来存储点数据

@end

NS_ASSUME_NONNULL_END
