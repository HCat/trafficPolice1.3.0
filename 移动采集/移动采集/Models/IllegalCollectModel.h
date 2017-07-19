//
//  IllegalCollectModel.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/21.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IllegalCollectModel : NSObject

@property (nonatomic,strong) NSNumber * roadId;         //道路ID
@property (nonatomic,copy)   NSString * roadName;       //道路名称
@property (nonatomic,copy)   NSString * address;        //地点
@property (nonatomic,copy)   NSString * carNo;          //车牌号
@property (nonatomic,strong) NSNumber * collectTime;    //采集时间
@property (nonatomic,strong) NSNumber * state;          //状态
@property (nonatomic,copy)   NSString * stateName;      //状态名称

@end
