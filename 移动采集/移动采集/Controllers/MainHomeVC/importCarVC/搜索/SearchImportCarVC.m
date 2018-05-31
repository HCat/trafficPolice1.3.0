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

#import "VehicleCarAnnotation.h"
#import "UINavigationBar+BarItem.h"

@interface SearchImportCarVC ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) VehicleCarAnnotation *search_annotation; //定位的坐标点

@end

@implementation SearchImportCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索重点车辆";
    
    [self showRightBarButtonItemWithImage:@"nav_center" target:self action:@selector(makeLocationInCenter)];
    [self initMapView];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self searchVehicle];
    
}

#pragma mark - 数据请求

- (void)searchVehicle{
    
    if (self.search_annotation) {
        [self.mapView removeAnnotation:self.search_annotation];
        self.search_annotation = nil;
    }
    
    self.search_annotation = [[VehicleCarAnnotation alloc] init];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_search_vehicleModel.latitude doubleValue], [_search_vehicleModel.longitude doubleValue]);
    self.search_annotation.coordinate = coordinate;
    self.search_annotation.title    = [NSString stringWithFormat:@"%ld",[_search_vehicleModel.vehicleId longValue]];
    self.search_annotation.subtitle = _search_vehicleModel.plateNo;
    self.search_annotation.vehicleCar = _search_vehicleModel;
    self.search_annotation.carType = @2;
    
    [_mapView addAnnotation:_search_annotation];
    
    CLLocationCoordinate2D center_coordinate = CLLocationCoordinate2DMake([_search_vehicleModel.latitude doubleValue], [_search_vehicleModel.longitude doubleValue]);
    [self.mapView setCenterCoordinate:center_coordinate animated:YES];
    
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
        
        static NSString *customReuseIndetifier = @"VehicleCarViewsearchID";
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
            
        }
        
    }
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        

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
