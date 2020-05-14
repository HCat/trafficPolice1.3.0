//
//  WeatherModel.h
//  移动采集
//
//  Created by hcat on 2017/10/20.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject

@property (nonatomic,copy) NSString * weather;         //当前天气
@property (nonatomic,copy) NSString * temperature;     //气温
@property (nonatomic,copy) NSString * winddirection;   //风向
@property (nonatomic,copy) NSString * humidity;       //空气湿度
@property (nonatomic,copy) NSString * windpower;       //风力



@end
