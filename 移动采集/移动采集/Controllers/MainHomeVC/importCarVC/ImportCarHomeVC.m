//
//  ImportCarHomeVC.m
//  移动采集
//
//  Created by hcat on 2017/9/5.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "ImportCarHomeVC.h"
#import "NSTimer+UnRetain.h"
#import "UINavigationBar+BarItem.h"
#import <MAMapKit/MAMapKit.h>
#import "VehicleAPI.h"
#import "VehicleCarAnnotation.h"

#import "QRCodeScanVC.h"
#import "VehicleCameraVC.h"
#import "VehicleDetailVC.h"
#import "VehicleSearchVC.h"

@interface ImportCarHomeVC ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
@property (nonatomic, strong) NSTimer * loadRequestTime;
@property (nonatomic, strong) NSMutableArray *arr_vehicles; //用来存储请求数据
@property (nonatomic, strong) NSMutableArray *arr_point;    //用来存储点数据
@property (nonatomic, strong) NSNumber *carType;            //车辆类型
@end

@implementation ImportCarHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重点车辆";
    
    [self showRightBarButtonItemWithImage:@"" target:self action:@selector(makeLocationInCenter)];
    self.carType = @2;
    self.arr_point = [NSMutableArray array];
    
    [self initMapView];
    
    
    
    WS(weakSelf);
    self.loadRequestTime = [NSTimer lr_scheduledTimerWithTimeInterval:10 repeats:YES block:^(NSTimer *timer) {
        
        SW(strongSelf, weakSelf);
        [strongSelf loadVehicleData];
        
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.loadRequestTime forMode:NSRunLoopCommonModes];

    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];


}

#pragma mark - init

- (void)initMapView{

    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    [self.view sendSubviewToBack:_mapView];
    
    _mapView.showsUserLocation = YES;
    _mapView.distanceFilter = 200;
    _mapView.showsCompass= NO;
    _mapView.showsScale= NO;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView setZoomLevel:14.1 animated:YES];

}

#pragma mark - 请求数据
- (void)loadVehicleData{

    //土方车请求
    WS(weakSelf);
    VehicleRangeLocationManger *manger = [[VehicleRangeLocationManger alloc] init];
    manger.lat = @(_mapView.centerCoordinate.latitude);
    manger.lng = @(_mapView.centerCoordinate.longitude);
    manger.range = @5;
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

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[VehicleCarAnnotation class]])
    {
        
        VehicleCarAnnotation *vehicle = (VehicleCarAnnotation *)annotation;
        
        static NSString *customReuseIndetifier = @"VehicleCarViewID";
        MAAnnotationView *vehicleCarView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (vehicleCarView == nil)
        {
            vehicleCarView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            
        }
        
        if ([vehicle.carType isEqualToNumber:@1]) {
            vehicleCarView.image = [UIImage imageNamed:@"map_policeCar"];
        }else{
            vehicleCarView.image = [UIImage imageNamed:@"map_truck"];
            
        }
        
        return vehicleCarView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    /* Adjust the map center in order to show the callout view completely. */
    if ([view isKindOfClass:[MAAnnotationView class]]) {
        
        if ([view.annotation isKindOfClass:[VehicleCarAnnotation class]]){
            
            VehicleCarAnnotation *vehicle = (VehicleCarAnnotation *)view.annotation;
            LxDBAnyVar(vehicle);
            
            VehicleDetailVC * t_vc = [[VehicleDetailVC alloc] init];
            t_vc.type = VehicleRequestTypeCarNumber;
            t_vc.NummberId = vehicle.vehicleCar.plateNo;
            [self.navigationController pushViewController:t_vc animated:YES];
        }
    
    }
}


- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        
        [self loadVehicleData];
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:183/255.f green:230/255.f blue:251/255.f alpha:0.3];
        pre.strokeColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        pre.image = [UIImage imageNamed:@"map_location"];
        pre.lineWidth = 1;
        //        pre.lineDashPattern = @[@6, @3];
        
        [self.mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
        view.canShowCallout = NO;
        self.userLocationAnnotationView = view;
    }
    
    
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
   

    if (!updatingLocation && self.userLocationAnnotationView != nil){
        [UIView animateWithDuration:0.1 animations:^{
            
            double degree = userLocation.heading.trueHeading;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
            
        }];
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
                
                VehicleSearchVC *t_vc = [[VehicleSearchVC alloc] init];
                [strongSelf.navigationController pushViewController:t_vc animated:YES];
                
            }else{
            
                VehicleDetailVC * t_vc = [[VehicleDetailVC alloc] init];
                t_vc.type = VehicleRequestTypeCarNumber;
                t_vc.NummberId = camera.commonIdentifyResponse.carNo;
                [strongSelf.navigationController pushViewController:t_vc animated:YES];
            }
            
        }
    };
    [self presentViewController:t_vc
                       animated:NO
                     completion:^{
                     }];
    
}

#pragma mark - 让地图的中心点为定位坐标按钮

- (void)makeLocationInCenter{
    
    [_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
