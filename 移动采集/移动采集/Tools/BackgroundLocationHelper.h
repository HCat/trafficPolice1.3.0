//
//  BackgroundLocationHelper.h
//  移动采集
//
//  Created by hcat on 2017/9/5.
//  Copyright © 2017年 Hcat. All rights reserved.
//

/***************** 用于后台持续定位 ********************/

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface BackgroundLocationHelper : NSObject<AMapLocationManagerDelegate>

LRSingletonH(Default)

@property (nonatomic, strong) AMapLocationManager * locationManager;
@property (nonatomic, strong) NSNumber * latitude;
@property (nonatomic, strong) NSNumber * longitude;

@property (copy, nonatomic) NSString * city;
@property (copy, nonatomic) NSString * streetName;
@property (copy, nonatomic) NSString * address;
@property (nonatomic,assign) BOOL isLocation; //判断是否已经定位

- (void)startLocation;  //开始定位
- (void)stopLocation;   //停止定位

@end
