//
//  DailyPatrolLocationHelper.m
//  移动采集
//
//  Created by hcat-89 on 2020/1/13.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "DailyPatrolLocationHelper.h"
#import "BackgroundLocationHelper.h"
#import "NSTimer+UnRetain.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "DailyPatrolAPI.h"

@interface DailyPatrolLocationHelper ()<AMapLocationManagerDelegate>

@property (nonatomic,strong) NSTimer *time_upLocation;
@property (nonatomic, strong) AMapLocationManager * locationManager;
@property (nonatomic, strong) NSNumber * latitude;
@property (nonatomic, strong) NSNumber * longitude;

@property (copy, nonatomic) NSString * city;
@property (copy, nonatomic) NSString * streetName;
@property (copy, nonatomic) NSString * address;
@property (nonatomic,assign) BOOL isLocation; //判断是否已经定位

@end


@implementation DailyPatrolLocationHelper

LRSingletonM(Default)

- (void)startUpLocation{
    
    @weakify(self);
    
    [RACObserve([ShareValue sharedDefault], dailyPratrol_on) subscribeNext:^(id  _Nullable x) {
       
        @strongify(self);
        if ([x boolValue]) {
            
            if (self.isLocation == NO) {
                [self startLocation];
            }
            
        }else{
            
            if (self.isLocation) {
                [self stopLocation];
            }
            
        }
        
        
    }];
    
}


- (void)startLocation{

    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    self.locationManager.distanceFilter = 10.f;
    
    //设置允许连续定位逆地理
    [self.locationManager setLocatingWithReGeocode:YES];
    
    [self.locationManager startUpdatingLocation];
    self.isLocation = YES;
    
    @weakify(self);
    
    if (self.time_upLocation) {
        LxPrintf(@"*********************服务器定时发送注销！*********************");
        [self.time_upLocation invalidate];
        self.time_upLocation = nil;
    }
    
    self.time_upLocation = [NSTimer lr_scheduledTimerWithTimeInterval:30.f repeats:YES block:^(NSTimer *timer) {
        
        @strongify(self);
        if (self.latitude && self.longitude) {
            
            DailyPatrolLocationReportParam * param = [[DailyPatrolLocationReportParam alloc] init];
            param.longitude = self.longitude;
            param.latitude = self.latitude;
            DailyPatrolLocationReportManger * manger = [[DailyPatrolLocationReportManger alloc] init];
            manger.param = param;
            manger.isNoShowFail = YES;
            [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
               

            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                
                
                
            }];
            
        }
        
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.time_upLocation forMode:NSRunLoopCommonModes];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.time_upLocation fire];
    });
    
}


- (void)stopLocation{

    if (self.locationManager) {
        
        [self.locationManager stopUpdatingLocation];
        [self.locationManager setDelegate:nil];
        self.isLocation = NO;
    }
    
    if (self.time_upLocation) {
        LxPrintf(@"*********************服务器定时发送注销！*********************");
        [self.time_upLocation invalidate];
        self.time_upLocation = nil;
    }
   
}


#pragma mark - AMapLocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f; reGeocode:%@}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy, reGeocode.formattedAddress);
    
    self.latitude =  @(location.coordinate.latitude);
    self.longitude = @(location.coordinate.longitude);
    
    if (reGeocode){
        
        self.city = reGeocode.city;
        self.streetName = reGeocode.street;
        self.address = reGeocode.formattedAddress;
       
    }
   
}

- (void)dealloc{
    
    if (self.time_upLocation) {
        LxPrintf(@"*********************服务器定时发送注销！*********************");
        [self.time_upLocation invalidate];
        self.time_upLocation = nil;
    }
    
}


@end
