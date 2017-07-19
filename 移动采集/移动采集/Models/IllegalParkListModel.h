//
//  IllegalParkListModel.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/21.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IllegalParkListModel : NSObject

@property (nonatomic,strong) NSNumber * illegalParkId ; //主键
@property (nonatomic,strong) NSNumber * collectTime ;   //采集时间
@property (nonatomic,copy)   NSString * roadName ;      //路名
@property (nonatomic,copy)   NSString * carNo;          //车牌号


@end
