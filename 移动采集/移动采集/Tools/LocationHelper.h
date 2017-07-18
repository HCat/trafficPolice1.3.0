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

@interface LocationHelper : NSObject<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

LRSingletonH(Default)

@property (strong, nonatomic) BMKLocationService * locService;
@property (strong, nonatomic) BMKGeoCodeSearch * geocodesearch;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *streetName;
@property (copy, nonatomic) NSString *address;

- (void)startLocation;
- (void)stopLocation;

@end
