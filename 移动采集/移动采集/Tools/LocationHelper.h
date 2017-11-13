//
//  LocationHelper.h
//  trafficPolice
//
//  Created by hcat on 2017/5/25.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>


@interface LocationHelper : NSObject<AMapLocationManagerDelegate>

LRSingletonH(Default)

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (assign, nonatomic) double latitude;      //纬度
@property (assign, nonatomic) double longitude;     //经度


@property (copy, nonatomic) NSString *city;         //城市
@property (copy, nonatomic) NSString *district;     //县城
@property (copy, nonatomic) NSString *streetName;   //街道
@property (copy, nonatomic) NSString *address;      //详细地址

- (void)startLocation;
- (void)stopLocation;

@end
