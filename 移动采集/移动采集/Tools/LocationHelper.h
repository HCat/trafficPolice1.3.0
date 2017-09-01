//
//  LocationHelper.h
//  trafficPolice
//
//  Created by hcat on 2017/5/25.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKGeometry.h>
#import <AMapLocationKit/AMapLocationKit.h>

typedef NS_ENUM(NSInteger, LocationTyp) {
    LocationTypeBaidu,   //百度地图
    LocationTypeGaode,   //高德地图
};

@interface LocationHelper : NSObject<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,AMapLocationManagerDelegate>

LRSingletonH(Default)

@property (assign, nonatomic) LocationTyp locationType;
@property (strong, nonatomic) BMKLocationService * locService;
@property (strong, nonatomic) BMKGeoCodeSearch * geocodesearch;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (assign, nonatomic) double baiduLatitude;
@property (assign, nonatomic) double baiduLongitude;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *streetName;
@property (copy, nonatomic) NSString *address;

- (void)startLocation;
- (void)stopLocation;

@end
