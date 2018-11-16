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

@property (nonatomic,strong) RACCommand * locationCommand;  // 定位请求
@property (nonatomic,strong) RACSubject * locationSubject;
@property (nonatomic,strong) RACSubject * loadingSubject;   // 用于请求数据用,防止一秒内重复发出请求信号用
@property (nonatomic,strong) RACCommand * policeLocationCommand;    //警员位置数据请求

@property (nonatomic, strong) NSNumber *latitude;                    //纬度
@property (nonatomic, strong) NSNumber *longitude;                   //经度


@end

NS_ASSUME_NONNULL_END
