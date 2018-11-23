//
//  PoliceDistributeVC.m
//  移动采集
//
//  Created by hcat on 2018/11/5.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "PoliceDistributeVC.h"
#import "PoliceDistributeViewModel.h"
#import <PureLayout.h>
#import <MAMapKit/MAMapKit.h>
#import "PoliceDistributeAnnotation.h"
#import "PoliceDisAnnotationView.h"
#import "PolicePerformView.h"
#import "PoliceReleaseRadioVC.h"


@interface PoliceDistributeVC ()<MAMapViewDelegate,AMapLocationManagerDelegate>

@property (nonatomic,strong) PoliceDistributeViewModel * viewModel;

@property (weak, nonatomic) IBOutlet UIButton * btn_search;
@property (weak, nonatomic) IBOutlet UIButton * btn_usrLocation;
@property (weak, nonatomic) IBOutlet UIButton * btn_radio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_topView_height;

@property (nonatomic, strong) MAMapView * mapView;
@property (nonatomic, strong) MAPointAnnotation * positionAnnotation; //定位的坐标点
@property (nonatomic, strong) NSNumber * range;                       //半径
@property (nonatomic, strong) MACircle * positionCircle;              //定位画的圆

@property (nonatomic, strong) NSMutableArray *arr_data;     //用来存请求数据
@property (nonatomic, strong) NSMutableArray *arr_point;    //用来存储点数据


@end

@implementation PoliceDistributeVC

- (instancetype)initWithViewModel:(PoliceDistributeViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
        self.arr_point = @[].mutableCopy;
        self.arr_data = @[].mutableCopy;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    
    if (IS_IPHONE_X_MORE) {
        _layout_topView_height.constant = _layout_topView_height.constant + 24;
    }
    
    [self initMapView];
    
    //发起定位请求
    [self.viewModel.locationCommand execute:@1];
    //定位之后所要做的UI操作
    [self.viewModel.locationSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(NSNumber * latitude, NSNumber * longitude) = x;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        [self.mapView setCenterCoordinate:coordinate animated:YES];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:NOTIFICATION_POLICE_SHOWDETAIL object:nil] subscribeNext:^(id x) {
        NSLog(@"详情弹出");
        NSNotification * notification = x;
        PoliceLocationModel * notific_model = notification.object;
        
        @strongify(self);
        if (self.arr_point && self.arr_point.count > 0) {
            [self.mapView removeAnnotations:self.arr_point];
            [self.arr_point removeAllObjects];
        }
        
        for (PoliceLocationModel * model in self.arr_data) {
            
            if (model != notific_model) {
                model.isSelected = NO;
            }
            
            PoliceDistributeAnnotation *annotation = [[PoliceDistributeAnnotation alloc] init];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
            annotation.coordinate = coordinate;
            annotation.title    = @"警员";
            annotation.subtitle = @"警员";
            annotation.policeModel = model;
            annotation.policeType = @1;
            
            [self.arr_point addObject:annotation];
        }
        if (self.arr_point && self.arr_point.count > 0) {
            [self.mapView addAnnotations:self.arr_point];
        }
        
    }];
    
    for (int i = 0; i < 10 ; i++) {
        PoliceLocationModel * model = [[PoliceLocationModel alloc] init];
        model.latitude = @(24.49281 + 0.00001 * i * 100);
        model.longitude = @(118.176059+ 0.000001 * i * 100);
        [self.arr_data addObject:model];
    }
    
    //数据请求
    [self.viewModel.policeLocationCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
        @strongify(self);
        
        if (self.arr_point && self.arr_point.count > 0) {
            [self.mapView removeAnnotations:self.arr_point];
            [self.arr_point removeAllObjects];
        }
        
        
        
        
        for (PoliceLocationModel * model in self.arr_data) {
            
            PoliceDistributeAnnotation *annotation = [[PoliceDistributeAnnotation alloc] init];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
            annotation.coordinate = coordinate;
            annotation.title    = @"警员";
            annotation.subtitle = @"警员";
            annotation.policeModel = model;
            annotation.policeType = @1;
            
            [self.arr_point addObject:annotation];
        }
        if (self.arr_point && self.arr_point.count > 0) {
            [self.mapView addAnnotations:self.arr_point];
        }
        
        
    }];
    
    
    [[_btn_radio rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        
        PolicePerformView * view = [PolicePerformView initCustomView];
        
        view.editBlock = ^{
            @strongify(self);
            PoliceReleaseRadioVC * radiovc = [[PoliceReleaseRadioVC alloc] init];
            [self.navigationController pushViewController:radiovc animated:YES];
            
        };
        
        [view show];
        
    }];
    
    [[_btn_search rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
    
    [[_btn_usrLocation rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        //发起定位请求
        [self.viewModel.locationCommand execute:@1];
        
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
    
}

#pragma mark - initMapView

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
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = MAUserTrackingModeNone;
    _mapView.maxZoomLevel = 20;
    _mapView.minZoomLevel = 10;
    [_mapView setZoomLevel:13.2f animated:YES];
    
}


#pragma mark - 画定位的圆形还有坐标

- (void) drawCircleRange{
    
    _range = @3;
    
    if (_positionAnnotation) {
        [_mapView removeAnnotation:_positionAnnotation];
        self.positionAnnotation = nil;
    }
    
    self.positionAnnotation = [[MAPointAnnotation alloc] init];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.viewModel.latitude doubleValue], [self.viewModel.longitude doubleValue]);
    _positionAnnotation.coordinate = coordinate;
    _positionAnnotation.title    = @"百度地图中心点";
    _positionAnnotation.subtitle = @"百度地图中心点";
    
    [_mapView addAnnotation:_positionAnnotation];
    
    if (_positionCircle) {
        [_mapView removeOverlay:_positionCircle];
        self.positionCircle = nil;
    }
    
    self.positionCircle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake([self.viewModel.latitude doubleValue], [self.viewModel.longitude doubleValue]) radius:[_range intValue] * 1000];
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
    
    if ([annotation isKindOfClass:[PoliceDistributeAnnotation class]]){
        
        PoliceDistributeAnnotation *vehicle = (PoliceDistributeAnnotation *)annotation;
        
        static NSString *customReuseIndetifier = @"PoliceViewID";
        PoliceDisAnnotationView *policeView = (PoliceDisAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        if (policeView == nil){
            policeView = [[PoliceDisAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            
        }

        //很重要的，配置关联的模型数据
        policeView.annotation = vehicle;
        
        return policeView;
        
    }else if ([annotation isKindOfClass:[MAPointAnnotation class]]){
        static NSString *customReuseIndetifier = @"positionAnnotationID";
        MAAnnotationView *positionView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (positionView == nil){
            positionView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            
        }
        
        positionView.image = [UIImage imageNamed:@"icon_policeDis_userLocation"];
        
        
        return positionView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    /* Adjust the map center in order to show the callout view completely. */
//    if ([view isKindOfClass:[VehicleCarAnnotationView class]]) {
//
//        if ([view.annotation isKindOfClass:[VehicleCarAnnotation class]]){
//
//
//
//        }
//
//    }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]]){
        
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth   = 1.f;
        circleRenderer.strokeColor = [UIColor clearColor];
        circleRenderer.fillColor   = [UIColorFromRGB(0x3396FC) colorWithAlphaComponent:0.2];
        
        return circleRenderer;
        
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    
    self.viewModel.latitude = @(_mapView.centerCoordinate.latitude);
    self.viewModel.longitude = @(_mapView.centerCoordinate.longitude);
    [self celearPositionRange];
    [self drawCircleRange];
    //请求数据
    [self.viewModel.loadingSubject sendNext:@1];
    
}


#pragma mark - buttonAction

- (IBAction)handleBtnBackClickingAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"PoliceDistributeVC");
}

@end
