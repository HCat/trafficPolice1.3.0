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

@property (nonatomic,strong) RACCommand * allPoliceCommand;         // 所有警员和警车位置数据请求

@property (nonatomic,strong) RACSubject * loadingSubject;           // 用户移动位置之后的用于请求半径内警员数据的热信号
@property (nonatomic,strong) RACCommand * policeLocationCommand;    // 半径内警员位置数据请求

//用于搜索半径内的警员信息
@property (nonatomic, strong) NSNumber * range;                     // 半径
@property (nonatomic, strong) NSNumber * latitude;                  // 纬度
@property (nonatomic, strong) NSNumber * longitude;                 // 经度


@property (nonatomic, strong) NSMutableArray * arr_data;            // 用来存半径内警员请求数据

@property (nonatomic, strong) NSMutableArray * arr_point;           // 用来存储警员或者警车点数据

@end

NS_ASSUME_NONNULL_END
