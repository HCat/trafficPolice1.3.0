//
//  LocationHelper.m
//  trafficPolice
//
//  Created by hcat on 2017/5/25.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "LocationHelper.h"
#import "BackgroundLocationHelper.h"
#import "UserModel.h"
#import "WebSocketHelper.h"

#define DefaultLocationTimeout 2
#define DefaultReGeocodeTimeout 5


@implementation LocationHelper

LRSingletonM(Default)

- (void)startLocation{

    if (_locationType == LocationTypeBaidu) {
        
        //初始化BMKLocationService
        self.locService = [[BMKLocationService alloc]init];
        self.locService.delegate = self;
        //启动LocationService
        [self.locService startUserLocationService];
        
    }else if (_locationType == LocationTypeGaode){
        self.locationManager = [[AMapLocationManager alloc] init];
        
        [self.locationManager setDelegate:self];
        
        //设置期望定位精度
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        //设置不允许系统暂停定位
        [self.locationManager setPausesLocationUpdatesAutomatically:YES];
        
        //设置允许在后台定位
        [self.locationManager setAllowsBackgroundLocationUpdates:NO];
        
        //设置定位超时时间
        [self.locationManager setLocationTimeout:DefaultLocationTimeout];
        
        //设置逆地理超时时间
        [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
    
        WS(weakSelf);
        
        [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            SW(strongSelf, weakSelf);
            
            if (error != nil && error.code == AMapLocationErrorLocateFailed){
                
                //定位错误：此时location和regeocode没有返回值
                NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
                
                [weakSelf performSelector:@selector(startLocation) withObject:nil afterDelay:1.5];
                
                return;
                
            }
            
            
            
            strongSelf.latitude =  location.coordinate.latitude;
            strongSelf.longitude = location.coordinate.longitude;
            
            LxPrintf(@"didUpdateUserLocation gaodelat %f,gaodelong %f",strongSelf.latitude,strongSelf.longitude);
            
            NSDictionary* testdic = BMKConvertBaiduCoorFrom(location.coordinate,BMK_COORDTYPE_COMMON);
            CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(testdic);

            strongSelf.baiduLatitude = baiduCoor.latitude;
            strongSelf.baiduLongitude = baiduCoor.longitude;
            
            LxPrintf(@"didUpdateUserLocation baidulat %f,baidulong %f",strongSelf.baiduLatitude,strongSelf.baiduLongitude);
            
            if (error != nil
                     && (error.code == AMapLocationErrorReGeocodeFailed
                         || error.code == AMapLocationErrorTimeOut
                         || error.code == AMapLocationErrorCannotFindHost
                         || error.code == AMapLocationErrorBadURL
                         || error.code == AMapLocationErrorNotConnectedToInternet
                         || error.code == AMapLocationErrorCannotConnectToHost)){
                         
                //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值
                         
                NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
                
                [weakSelf performSelector:@selector(startLocation) withObject:nil afterDelay:1.5];
            
            }else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation){
                
                //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
                NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
                return;
                
            }else{
                
            }
            
            //修改label显示内容
            if (regeocode){
                
                strongSelf.city = regeocode.city;
                strongSelf.district = regeocode.district;
                strongSelf.streetName = regeocode.street;
                strongSelf.address = regeocode.formattedAddress;
                LxDBAnyVar(self.city);
                LxDBAnyVar(self.streetName);
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil userInfo:nil];
                
            }
            
            [self stopLocation];

        }];
        
    }
    
}

- (void)stopLocation{
    
    if (_locationType == LocationTypeBaidu) {
        [self.locService stopUserLocationService];
        self.locService.delegate = nil;
        self.locService = nil;

    }else if (_locationType == LocationTypeGaode){
        [self.locationManager stopUpdatingLocation];
        [self.locationManager setDelegate:nil];
        
    }
    
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
    LxPrintf(@"didUpdateUserLocation gaolat %f,gaolong %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.latitude = userLocation.location.coordinate.latitude;
    self.longitude = userLocation.location.coordinate.longitude;
    
    NSDictionary* testdic = BMKConvertBaiduCoorFrom(userLocation.location.coordinate,BMK_COORDTYPE_COMMON);
    
    CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(testdic);
    
    self.baiduLatitude = baiduCoor.latitude;
    self.baiduLongitude = baiduCoor.longitude;
   
    LxPrintf(@"didUpdateUserLocation baidulat %f,baidulong %f",self.baiduLatitude,self.baiduLongitude);
    
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
        self.district = component.district;
        self.address = result.address;
        LxDBAnyVar(self.city);
        LxDBAnyVar(self.streetName);
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil userInfo:nil];
        
    }
}


@end
