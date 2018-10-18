//
//  BackgroundLocationHelper.m
//  移动采集
//
//  Created by hcat on 2017/9/5.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "BackgroundLocationHelper.h"
#import "NSTimer+UnRetain.h"
#import "WebSocketHelper.h"
#import "StepNumberHelper.h"

#import "LocationModel.h"
#import "SocketModel.h"
#import "UserModel.h"


@interface BackgroundLocationHelper ()

@property (nonatomic,strong) NSTimer *time_upLocation;

@end



@implementation BackgroundLocationHelper

LRSingletonM(Default)

- (void)startLocation{

    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    self.locationManager.distanceFilter = 50.f;
    
    //设置允许连续定位逆地理
    [self.locationManager setLocatingWithReGeocode:YES];
    
    [self.locationManager startUpdatingLocation];
    self.isLocation = YES;
    
    LxPrintf(@"**********************发送定时器生成！*********************");
    
    WS(weakSelf);
    
    double frequency = [[ShareValue sharedDefault].frequency doubleValue];
    
    self.time_upLocation = [NSTimer lr_scheduledTimerWithTimeInterval:frequency repeats:YES block:^(NSTimer *timer) {
        
        SW(strongSelf, weakSelf);
        if (strongSelf.latitude && strongSelf.longitude) {
            LocationModel *t_locationModel = [[LocationModel alloc] init];
            t_locationModel.latitude = strongSelf.latitude;
            t_locationModel.longitude = strongSelf.longitude;
            SocketModel *t_socketModel  = [[SocketModel alloc] init];
            t_socketModel.fromUserId = @([[UserModel getUserModel].userId integerValue]);
            t_socketModel.msgType = @(WEBSOCKTETYPE_POLICELOCATION);
            
            t_socketModel.message = t_locationModel;
            if ([StepNumberHelper sharedDefault].isRuning) {
                t_socketModel.totalStep = [StepNumberHelper sharedDefault].stepNumber;
            }
            
            NSString *json_string = t_socketModel.modelToJSONString;
            
            [[WebSocketHelper sharedDefault].webSocket send:json_string];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
            LxPrintf(@"发送成功，时间：%@",destDateString);
            [ShareFun locationlog:destDateString andValue:strongSelf.address];
            
            
        }
        
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.time_upLocation forMode:NSRunLoopCommonModes];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SW(strongSelf, weakSelf);
        [strongSelf.time_upLocation fire];
    });
    
}

- (void)stopLocation{

    if (self.locationManager) {
        
        [self.locationManager stopUpdatingLocation];
        [self.locationManager setDelegate:nil];
        self.isLocation = NO;
    }
   
    if (self.time_upLocation) {
        LxPrintf(@"**********************发送定时器注销！*********************");
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



@end
