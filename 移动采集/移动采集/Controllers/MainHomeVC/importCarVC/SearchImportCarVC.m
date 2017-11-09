//
//  SearchImportCarVC.m
//  移动采集
//
//  Created by hcat on 2017/11/9.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "SearchImportCarVC.h"
#import <MAMapKit/MAMapKit.h>

#import "VehicleAPI.h"
#import "VehicleDetailVC.h"
#import "VehicleCarAnnotation.h"
#import "UINavigationBar+BarItem.h"

@interface SearchImportCarVC ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) VehicleCarAnnotation *search_annotation; //定位的坐标点
@property (nonatomic, strong) VehicleGPSModel * search_vehicleModel;

@end

@implementation SearchImportCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索重点车辆";
    
    [self showRightBarButtonItemWithImage:@"nav_center" target:self action:@selector(makeLocationInCenter)];
    [self initMapView];
    
}

#pragma mark - 数据请求

- (void)searchVehicle{
    WS(weakSelf);
    
    VehicleLocationByPlateNoManger *manger = [[VehicleLocationByPlateNoManger alloc] init];
    manger.plateNo = _plateNo;
    [manger configLoadingTitle:@"搜索"];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        
        if (strongSelf.search_annotation) {
            [strongSelf.mapView removeAnnotation:strongSelf.search_annotation];
            strongSelf.search_annotation = nil;
        }
        
        strongSelf.search_vehicleModel = manger.vehicleGPSModel;
        strongSelf.search_annotation = [[VehicleCarAnnotation alloc] init];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([strongSelf.search_vehicleModel.latitude doubleValue], [strongSelf.search_vehicleModel.longitude doubleValue]);
        strongSelf.search_annotation.coordinate = coordinate;
        strongSelf.search_annotation.title    = [NSString stringWithFormat:@"%ld",[manger.vehicleGPSModel.vehicleId longValue]];
        strongSelf.search_annotation.subtitle = manger.vehicleGPSModel.plateNo;
        strongSelf.search_annotation.vehicleCar = manger.vehicleGPSModel;
        strongSelf.search_annotation.carType = @2;
        
        [strongSelf.mapView addAnnotation:strongSelf.search_annotation];
        
        CLLocationCoordinate2D center_coordinate = CLLocationCoordinate2DMake([strongSelf.search_vehicleModel.latitude doubleValue], [strongSelf.search_vehicleModel.longitude doubleValue]);
        [strongSelf.mapView setCenterCoordinate:center_coordinate animated:YES];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        
        
    }];
    
}

#pragma mark - init

- (void)initMapView{
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    [self.view sendSubviewToBack:_mapView];
    
    
    _mapView.distanceFilter = 200;
    _mapView.showsCompass= NO;
    _mapView.showsScale= NO;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.maxZoomLevel = 20;
    
    [_mapView setZoomLevel:15 animated:YES];
    
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
            vehicleCarView.image = [UIImage imageNamed:@"icon_searchImportCar"];
            
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

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        
        [self searchVehicle];
        
    }
    
    
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
    LxPrintf(@"SearchImportCarVC dealloc");
    
}

@end
