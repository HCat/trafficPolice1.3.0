//
//  PoliceDistributeViewModel.m
//  移动采集
//
//  Created by hcat on 2018/11/5.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "PoliceDistributeViewModel.h"
#import "PoliceLocationModel.h"
#import "PoliceDistributeAnnotation.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import "PoliceDistributeAPI.h"
#import "VehicleAPI.h"

@interface PoliceDistributeViewModel ()<AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;

@end


@implementation PoliceDistributeViewModel


- (instancetype)init{
    
    if (self = [super init]) {
        
        self.arr_point = @[].mutableCopy;
        self.arr_data = @[].mutableCopy;
        self.range = @5;

        self.locationManager = [[AMapLocationManager alloc] init];
        [_locationManager setDelegate:self];
        _locationManager.distanceFilter = 20.0f;
        //设置期望定位精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        //设置不允许系统暂停定位
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        //设置允许在后台定位
        [_locationManager setAllowsBackgroundLocationUpdates:NO];
        //设置定位超时时间
        [_locationManager setLocationTimeout:7];
        [_locationManager setLocatingWithReGeocode:NO];
        
        @weakify(self);
        
        //定位请求
        self.locationCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [self.locationManager startUpdatingLocation];
                [subscriber sendCompleted];
                return nil;
            }];
            
            return signal;
            
        }];
        
        self.locationSubject = [RACSubject subject];
        self.loadingSubject = [RACSubject subject];
        
        // 节流，在一定时间（1秒）内，不接收任何信号内容，过了这个时间（1秒）获取最后发送的信号内容发出。
        
        [[self.loadingSubject throttle:1] subscribeNext:^(id x) {
            @strongify(self);
            [self.policeLocationCommand execute:x];
            
        }];
        
        self.allPoliceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                PoliceDistributeGetListParam * param = [[PoliceDistributeGetListParam alloc] init];
    
                PoliceDistributeGetListManger * manger = [[PoliceDistributeGetListManger alloc] init];
                manger.param = param;
                manger.isNeedShowHud = NO;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    
                    MAMapView * mapView = (MAMapView *)input;
                    if (self.arr_point && self.arr_point.count > 0) {
                        [mapView removeAnnotations:self.arr_point];
                        [self.arr_point removeAllObjects];
                        
                    }
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        for (PoliceLocationModel * model in manger.userGpsList) {
                            
                            PoliceDistributeAnnotation *annotation = [[PoliceDistributeAnnotation alloc] init];
                            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
                            annotation.coordinate = coordinate;
                            annotation.title    = @"警员";
                            annotation.subtitle = @"警员";
                            annotation.policeModel = model;
                            annotation.policeType = @1;
                            [self.arr_point addObject:annotation];
                        }
                        
                    };
                    
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:nil];
                    [subscriber sendError:request.error];
                }];
                
            
                return nil;
            }];
            
            
            RACSignal * signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                
                VehicleRangeLocationManger *manger = [[VehicleRangeLocationManger alloc] init];
                manger.isNeedShowHud = NO;
                manger.carType = @1;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        for (VehicleGPSModel *model in manger.vehicleGpsList) {
                            
                            PoliceDistributeAnnotation *annotation = [[PoliceDistributeAnnotation alloc] init];
                            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
                            annotation.coordinate = coordinate;
                            annotation.title    = @"警车";
                            annotation.subtitle = @"警车";
                            annotation.vehicleCar = model;
                            annotation.policeType = @2;
                            [self.arr_point addObject:annotation];
                        }
                        
                    }
                    
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                    
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:nil];
                    [subscriber sendError:request.error];
                
                }];
                
                return nil;
            }];
            
            RACSignal *signal = [signalA concat:signalB];
            
            return signal;
            
        }];
        
        
        
        self.policeLocationCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               @strongify(self);
                PoliceDistributeGetListParam * param = [[PoliceDistributeGetListParam alloc] init];
                param.lat = self.latitude;
                param.lng = self.longitude;
                param.range = self.range;
                
                PoliceDistributeGetListManger * manger = [[PoliceDistributeGetListManger alloc] init];
                manger.param = param;
                manger.isNeedShowHud = NO;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    
                    if (self.arr_data && self.arr_data.count > 0) {
                        [self.arr_data removeAllObjects];
                    }
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        [self.arr_data addObjectsFromArray:manger.userGpsList];
                        
                    };
                    
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendError:request.error];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return signal;
            
        }];
        
        
        
        
    }
    
    return self;
    
}


#pragma mark - AMapDelegate 高德地图定位委托

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    self.latitude =  @(location.coordinate.latitude);
    self.longitude = @(location.coordinate.longitude);
    
    RACTuple *tuple = RACTuplePack(self.latitude,self.longitude);
    [self.locationSubject sendNext:tuple];
    
    [self.locationManager stopUpdatingLocation];

}


- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    
    [self.locationManager stopUpdatingLocation];
    
    if (error != nil && error.code == AMapLocationErrorLocateFailed){
        
        //定位错误：此时location和regeocode没有返回值
        LxPrintf(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        
        @weakify(self);
        [[RACScheduler currentScheduler] afterDelay:1.5 schedule:^{
            @strongify(self);
            [self.locationCommand execute:nil];
        }];
        
        
    }
    
}


- (void)dealloc{
    
    [self.locationSubject sendCompleted];
    [self.loadingSubject sendCompleted];
    NSLog(@"PoliceDistributeViewModel dealloc");
    
}

@end
