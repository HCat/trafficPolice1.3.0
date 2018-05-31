//
//  ImportCarHomeVC.m
//  移动采集
//
//  Created by hcat on 2017/9/5.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "ImportCarHomeVC.h"
#import "NSTimer+UnRetain.h"
#import <PureLayout.h>
#import "UINavigationBar+BarItem.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#import "VehicleAPI.h"
#import "VehicleCarAnnotation.h"
#import "VehicleCarAnnotationView.h"

#import "VehicleCarMoreVC.h"
#import "QRCodeScanVC.h"
#import "VehicleCameraVC.h"

#import "VehicleSearchListVC.h"
#import "VehicleUpVC.h"

@interface ImportCarHomeVC ()<MAMapViewDelegate,AMapLocationManagerDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, strong) MAPointAnnotation *positionAnnotation; //定位的坐标点
@property (nonatomic, strong) MACircle *positionCircle;              //定位画的圆

@property (nonatomic, strong) NSNumber *latitude;                    //纬度
@property (nonatomic, strong) NSNumber *longitude;                   //经度
@property (nonatomic, strong) NSNumber *location_latitude;           //定位的经纬度
@property (nonatomic, strong) NSNumber *location_longitude;          //定位的经纬度
@property (nonatomic, strong) NSNumber *range;                       //半径


@property (nonatomic, strong) NSTimer * loadRequestTime;
@property (nonatomic, strong) NSMutableArray *arr_vehicles; //用来存储请求数据
@property (nonatomic, strong) NSMutableArray *arr_point;    //用来存储点数据
@property (nonatomic, strong) NSNumber *carType;            //车辆类型

@end

@implementation ImportCarHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重点车辆";

    self.carType = @2;
    self.arr_point = [NSMutableArray array];
    
    [self initMapView];
    [self configLocation];
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
     WS(weakSelf);
    
    if (!self.loadRequestTime) {
        self.loadRequestTime = [NSTimer lr_scheduledTimerWithTimeInterval:10 repeats:YES block:^(NSTimer *timer) {

            SW(strongSelf, weakSelf);
            [strongSelf loadVehicleData];

        }];
        [[NSRunLoop currentRunLoop] addTimer:self.loadRequestTime forMode:NSRunLoopCommonModes];

    }
   
}

- (void)viewDidDisappear:(BOOL)animated{
    
    if (self.loadRequestTime) {
        [self.loadRequestTime timeInterval];
        self.loadRequestTime = nil;
    }

    [super viewDidDisappear:animated];
}


#pragma mark - init

- (void)initMapView{

    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    [self.view sendSubviewToBack:_mapView];
    [_mapView configureForAutoLayout];
    [_mapView autoPinEdgesToSuperviewEdges];
    
    
    _mapView.distanceFilter = 200;
    _mapView.showsCompass= NO;
    _mapView.showsScale= NO;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.maxZoomLevel = 20;
    _mapView.minZoomLevel = 10;
    [_mapView setZoomLevel:12 animated:YES];

}

- (void)configLocation{
    
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
    [self.locationManager setLocationTimeout:7];

    [self.locationManager setLocatingWithReGeocode:NO];
    [self.locationManager startUpdatingLocation];
    
}


#pragma mark - 请求数据
- (void)loadVehicleData{

    //土方车请求
    WS(weakSelf);
    VehicleRangeLocationManger *manger = [[VehicleRangeLocationManger alloc] init];
    manger.lat = @(_mapView.centerCoordinate.latitude);
    manger.lng = @(_mapView.centerCoordinate.longitude);
    manger.range = @5;
    manger.isLog = NO;
    manger.carType = _carType;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            if (strongSelf.arr_point && strongSelf.arr_point.count > 0) {
                [strongSelf.mapView removeAnnotations:strongSelf.arr_point];
                [strongSelf.arr_point removeAllObjects];
            }
           
            strongSelf.arr_vehicles = [manger.vehicleGpsList mutableCopy];
            
            for (VehicleGPSModel *model in strongSelf.arr_vehicles) {
                VehicleCarAnnotation *annotation = [[VehicleCarAnnotation alloc] init];
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
                annotation.coordinate = coordinate;
                annotation.title    = [NSString stringWithFormat:@"%ld",[model.vehicleId longValue]];
                annotation.subtitle = model.plateNo;
                annotation.vehicleCar = model;
                annotation.carType = @2;
                
                [strongSelf.arr_point addObject:annotation];
            }
            if (strongSelf.arr_point && strongSelf.arr_point.count > 0) {
                [strongSelf.mapView addAnnotations:strongSelf.arr_point];
            }
            
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}


#pragma mark - 画定位的圆形还有坐标

- (void) drawPositionRange{
    
    _range = @6;
    
    if (_positionAnnotation) {
        [_mapView removeAnnotation:_positionAnnotation];
        self.positionAnnotation = nil;
    }
    
    self.positionAnnotation = [[MAPointAnnotation alloc] init];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue]);
    _positionAnnotation.coordinate = coordinate;
    _positionAnnotation.title    = @"百度地图中心点";
    _positionAnnotation.subtitle = @"百度地图中心点";
    
    [_mapView addAnnotation:_positionAnnotation];
    
    if (_positionCircle) {
        [_mapView removeOverlay:_positionCircle];
        self.positionCircle = nil;
    }
    
    self.positionCircle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue]) radius:[_range intValue] * 1000];
    [_mapView addOverlay:_positionCircle];
    
}

- (void)celearPositionRange{
    
    if (_positionAnnotation) {
        [_mapView removeAnnotation:_positionAnnotation];
        self.positionAnnotation = nil;
    }
    
    if (_positionCircle) {
        [_mapView removeOverlay:_positionCircle];
        self.positionCircle = nil;
    }
    
}



#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[VehicleCarAnnotation class]])
    {
        
        VehicleCarAnnotation *vehicle = (VehicleCarAnnotation *)annotation;
        
        static NSString *customReuseIndetifier = @"VehicleCarViewID";
        VehicleCarAnnotationView *vehicleCarView = (VehicleCarAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        WS(weakSelf);
        if (vehicleCarView == nil)
        {
            vehicleCarView = [[VehicleCarAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            vehicleCarView.block = ^(VehicleCarAnnotation *carAnnotation) {
                
                LxDBAnyVar(carAnnotation);
            
                [VehicleCarMoreVC loadVehicleRequest:VehicleRequestTypeCarNumber withNumber:vehicle.vehicleCar.plateNo withBlock:^(VehicleDetailReponse *vehicleDetailReponse) {
                    SW(strongSelf, weakSelf);
                    VehicleCarMoreVC * t_vc = [[VehicleCarMoreVC alloc] init];
                    t_vc.type = VehicleRequestTypeCarNumber;
                    t_vc.numberId = carAnnotation.vehicleCar.plateNo;
                    t_vc.reponse = vehicleDetailReponse;
                    [strongSelf.navigationController pushViewController:t_vc animated:YES];
                    
                }];
                
            };
        }
        
        //很重要的，配置关联的模型数据
        vehicleCarView.annotation = vehicle;
        
        
        return vehicleCarView;
        
    }else if ([annotation isKindOfClass:[MAPointAnnotation class]]){
        static NSString *customReuseIndetifier = @"positionAnnotationID";
        MAAnnotationView *positionView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (positionView == nil)
        {
            positionView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            
        }
        
        positionView.image = [UIImage imageNamed:@"icon_importCarCenter"];
        
        
        return positionView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    /* Adjust the map center in order to show the callout view completely. */
    if ([view isKindOfClass:[VehicleCarAnnotationView class]]) {
        
        if ([view.annotation isKindOfClass:[VehicleCarAnnotation class]]){
            
           
            
        }
    
    }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]]){
        
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth   = 1.f;
        circleRenderer.strokeColor = [UIColor clearColor];
        circleRenderer.fillColor   = [UIColorFromRGB(0x4281e8) colorWithAlphaComponent:0.3];
        
        return circleRenderer;
        
    
    }
    
    return nil;
}


- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    _latitude = @(_mapView.centerCoordinate.latitude);
    _longitude = @(_mapView.centerCoordinate.longitude);
    [self celearPositionRange];
    [self drawPositionRange];
    [self loadVehicleData];
    
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    if (!updatingLocation ){
        self.location_latitude = @(_mapView.userLocation.location.coordinate.latitude);
        self.location_longitude = @(_mapView.userLocation.location.coordinate.longitude);
    
    }
}


#pragma mark - AMapDelegate 高德地图定位委托

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    self.latitude =  @(location.coordinate.latitude);
    self.longitude = @(location.coordinate.longitude);
    self.location_latitude = @(location.coordinate.latitude);
    self.location_longitude = @(location.coordinate.longitude);
    [self drawPositionRange];
    [self makeLocationInCenter:nil];
    [self.locationManager stopUpdatingLocation];
    [self.locationManager setDelegate:nil];
    
}


- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    
    [self.locationManager stopUpdatingLocation];
    
    if (error != nil && error.code == AMapLocationErrorLocateFailed){
        
        //定位错误：此时location和regeocode没有返回值
        LxPrintf(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        
        [self performSelector:@selector(configLocation) withObject:nil afterDelay:1.5];
        
    }
    
}

#pragma mark - button Action

- (IBAction)handleBtnQRCodeClicked:(id)sender {
    QRCodeScanVC *t_vc = [[QRCodeScanVC alloc] init];
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

- (IBAction)handleBtnCarNumberClicked:(id)sender {
    
    WS(weakSelf);
    VehicleCameraVC *t_vc = [[VehicleCameraVC alloc] init];
    t_vc.fininshCaptureBlock = ^(VehicleCameraVC *camera) {
        SW(strongSelf, weakSelf);
        if (camera) {
            
            if (camera.isHandSearch) {
                
            
            }else{
                
                [VehicleCarMoreVC loadVehicleRequest:VehicleRequestTypeCarNumber withNumber:camera.commonIdentifyResponse.carNo withBlock:^(VehicleDetailReponse *vehicleDetailReponse) {
                   
                    VehicleCarMoreVC * t_vc = [[VehicleCarMoreVC alloc] init];
                    t_vc.type = VehicleRequestTypeCarNumber;
                    t_vc.numberId = camera.commonIdentifyResponse.carNo;
                    t_vc.reponse = vehicleDetailReponse;
                    [strongSelf.navigationController pushViewController:t_vc animated:YES];
                    
                }];
                

            }
            
        }
    };
    [self presentViewController:t_vc
                       animated:NO
                     completion:^{
                     }];
    
}

- (IBAction)handleBtnSearchBtnClicked:(id)sender {
    
    VehicleSearchListVC *t_vc = [[VehicleSearchListVC alloc] init];
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

- (IBAction)handleBtnUpBtnClicked:(id)sender {
    
    VehicleUpVC *t_vc = [[VehicleUpVC alloc] init];
    t_vc.param = [[VehicleCarlUpParam alloc] init];
    [self.navigationController pushViewController:t_vc animated:YES];
    
    
}



#pragma mark - 让地图的中心点为定位坐标按钮

- (IBAction)makeLocationInCenter:(id)sender{
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_location_latitude doubleValue], [_location_longitude doubleValue]);
    [_mapView setCenterCoordinate:coordinate animated:YES];
    
}



#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    if (self.loadRequestTime) {
        [self.loadRequestTime timeInterval];
        self.loadRequestTime = nil;
    }
    
    LxPrintf(@"ImportCarHomeVC dealloc");

}



@end
