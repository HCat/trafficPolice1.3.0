//
//  LocationHelper.m
//  trafficPolice
//
//  Created by hcat on 2017/5/25.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "LocationHelper.h"
#import "Reachability.h"

@implementation LocationHelper

LRSingletonM(Default)

- (void)startLocation{
    
    //初始化BMKLocationService
    self.locService = [[BMKLocationService alloc]init];
    self.locService.delegate = self;
    //启动LocationService
    [self.locService startUserLocationService];
    
}

- (void)stopLocation{
    [self.locService stopUserLocationService];
    self.locService.delegate = nil;
    self.locService = nil;
}

- (void)startReverseGeocode{

    if (!self.geocodesearch) {
        self.geocodesearch = [[BMKGeoCodeSearch alloc]init];
        self.geocodesearch.delegate = self;
    }

    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){self.latitude, self.longitude};
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        LxPrintf(@"反geo检索发送成功");
    }
    else
    {
        LxPrintf(@"反geo检索发送失败");
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status != NotReachable) {
            [self performSelector:@selector(startReverseGeocode) withObject:nil afterDelay:1.5];
            
        }
    
    }
}

#pragma mark - 百度地图定位Delegate

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    
    LxPrintf(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    LxPrintf(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.latitude = userLocation.location.coordinate.latitude;
    self.longitude = userLocation.location.coordinate.longitude;
    
    [self stopLocation];
    [self startReverseGeocode];
    
}

/**
 *在地图View停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
    LxPrintf(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    LxPrintf(@"location error");
    
}

- (void)dealloc {
    if (_locService != nil) {
        _locService.delegate = nil;
        _locService = nil;
    }
    
    if (_geocodesearch != nil) {
        _geocodesearch.delegate = nil;
        _geocodesearch = nil;
    }
   
}

#pragma mark - ReverGeoCode反向地理编址

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        BMKAddressComponent *component = result.addressDetail;
        self.city = component.city;
        self.streetName = component.streetName;
        self.address = result.address;
        LxDBAnyVar(self.city);
        LxDBAnyVar(self.streetName);
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil userInfo:nil];
        
    }
}


@end
