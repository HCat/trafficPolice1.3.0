//
//  LocationHelper.m
//  trafficPolice
//
//  Created by hcat on 2017/5/25.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "LocationHelper.h"

#define DefaultLocationTimeout 7
#define DefaultReGeocodeTimeout 7

@implementation LocationHelper

LRSingletonM(Default)

- (void)startLocation{

    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    self.locationManager.distanceFilter = 20.0f;
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
    
    
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
    
}

- (void)stopLocation{
    
    [self.locationManager stopUpdatingLocation];
    [self.locationManager setDelegate:nil];
    self.locationManager = nil;

}




- (void)dealloc {
   
    if (_locationManager != nil) {
        [_locationManager stopUpdatingLocation];
        [_locationManager setDelegate:nil];
        _locationManager = nil;
    }
   
}



#pragma mark - AMapDelegate 高德地图定位委托

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode){
        NSLog(@"reGeocode:%@", reGeocode);
        
        self.latitude =  location.coordinate.latitude;
        self.longitude = location.coordinate.longitude;
        
        //修改label显示内容
        if (reGeocode){
            
            self.city = reGeocode.city;
            self.streetName = reGeocode.street;
            self.address = reGeocode.formattedAddress;
            LxDBAnyVar(self.city);
            LxDBAnyVar(self.streetName);
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil userInfo:nil];
            
        }
        
        [self.locationManager stopUpdatingLocation];
    }
    
   
}


- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    
    [self.locationManager stopUpdatingLocation];
    
    if (error != nil && error.code == AMapLocationErrorLocateFailed){
        
        //定位错误：此时location和regeocode没有返回值
        LxPrintf(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        
        [self performSelector:@selector(startLocation) withObject:nil afterDelay:1.5];
        
    }
    
    if (error != nil
        && (error.code == AMapLocationErrorReGeocodeFailed
            || error.code == AMapLocationErrorTimeOut
            || error.code == AMapLocationErrorCannotFindHost
            || error.code == AMapLocationErrorBadURL
            || error.code == AMapLocationErrorNotConnectedToInternet
            || error.code == AMapLocationErrorCannotConnectToHost)){
            
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值
            
            LxPrintf(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            [self performSelector:@selector(startLocation) withObject:nil afterDelay:1.5];
            
        }else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation){
            
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            LxPrintf(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
            
        }else{
            
        }
    
}

- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager*)locationManager
{
    [locationManager requestAlwaysAuthorization];
}


@end
