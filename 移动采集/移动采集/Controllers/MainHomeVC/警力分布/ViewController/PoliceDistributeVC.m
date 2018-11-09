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
#import <AMapLocationKit/AMapLocationKit.h>

@interface PoliceDistributeVC ()<MAMapViewDelegate,AMapLocationManagerDelegate>

@property (nonatomic,strong) PoliceDistributeViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UIButton *btn_search;
@property (weak, nonatomic) IBOutlet UIButton *btn_usrLocation;
@property (weak, nonatomic) IBOutlet UIButton *btn_radio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_topView_height;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) MAPointAnnotation *positionAnnotation; //定位的坐标点


@end

@implementation PoliceDistributeVC

- (instancetype)initWithViewModel:(PoliceDistributeViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IPHONE_X_MORE) {
        _layout_topView_height.constant = _layout_topView_height.constant + 24;
    }
    
    [self initMapView];
    [self configLocation];
    
    [[_btn_radio rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        
    }];
    
    [[_btn_search rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
    
    [[_btn_usrLocation rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
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


#pragma mark - buttonAction

- (IBAction)handleBtnBackClickingAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"PoliceDistributeVC");
}

@end
