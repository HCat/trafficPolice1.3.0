//
//  PoliceCommandVC.m
//  移动采集
//
//  Created by hcat on 2017/9/11.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "PoliceCommandVC.h"
#import "NSTimer+UnRetain.h"
#import <MAMapKit/MAMapKit.h>

#import "VehicleAPI.h"
#import "LocationAPI.h"
#import "VehicleCarAnnotation.h"
#import "PoliceAnnotation.h"

@interface PoliceCommandVC ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

@property (nonatomic, strong) NSTimer * loadRequestTime;            //请求时间
@property (nonatomic, strong) NSMutableArray *arr_policeCar;        //用来存储警车请求数据
@property (nonatomic, strong) NSMutableArray *arr_policeCarPoint;   //用来存储警车点数据
@property (nonatomic, strong) NSMutableArray *arr_police;           //用来存储警员请求数据
@property (nonatomic, strong) NSMutableArray *arr_policePoint;      //用来存储警员点数据


@property (weak, nonatomic) IBOutlet UIButton *btn_onePolice;       //单个警察按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_groupPolice;     //群组警察按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_locationPolice;  //定位警察按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_pushPolice;      //广播警察按钮



@end

@implementation PoliceCommandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"勤务指挥";
    self.arr_policeCarPoint = [NSMutableArray array];
    self.arr_policePoint = [NSMutableArray array];
    
    [self initMapView];
    
    WS(weakSelf);
    self.loadRequestTime = [NSTimer lr_scheduledTimerWithTimeInterval:10 repeats:YES block:^(NSTimer *timer) {
        
        SW(strongSelf, weakSelf);
        [strongSelf loadPoliceCarData];
        [strongSelf loadPoliceData];
        
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.loadRequestTime forMode:NSRunLoopCommonModes];
    
    
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
- (void)loadPoliceCarData{

    WS(weakSelf);
    VehicleRangeLocationManger *manger = [[VehicleRangeLocationManger alloc] init];
    manger.lat = @(_mapView.centerCoordinate.latitude);
    manger.lng = @(_mapView.centerCoordinate.longitude);
    manger.range = @5;
    manger.carType = @1;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            if (strongSelf.arr_policeCarPoint && strongSelf.arr_policeCarPoint.count > 0) {
                [strongSelf.mapView removeAnnotations:strongSelf.arr_policeCarPoint];
                [strongSelf.arr_policeCarPoint removeAllObjects];
            }
            
            strongSelf.arr_policeCar = [manger.vehicleGpsList mutableCopy];
            
            for (VehicleGPSModel *model in strongSelf.arr_policeCar) {
                VehicleCarAnnotation *annotation = [[VehicleCarAnnotation alloc] init];
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
                annotation.coordinate = coordinate;
                annotation.title    = [NSString stringWithFormat:@"%ld",[model.vehicleId longValue]];
                annotation.subtitle = model.plateNo;
                annotation.vehicleCar = model;
                annotation.carType = @1;
                
                [strongSelf.arr_policeCarPoint addObject:annotation];
            }
            
            if (strongSelf.arr_policeCarPoint && strongSelf.arr_policeCarPoint.count > 0) {
                [strongSelf.mapView addAnnotations:strongSelf.arr_policeCarPoint];
            }
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}

- (void)loadPoliceData{
    
    WS(weakSelf);
    LocationGetListManger *manger = [[LocationGetListManger alloc] init];
    manger.lat = @(_mapView.centerCoordinate.latitude);
    manger.lng = @(_mapView.centerCoordinate.longitude);
    manger.range = @5;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            if (strongSelf.arr_policePoint && strongSelf.arr_policePoint.count > 0) {
                [strongSelf.mapView removeAnnotations:strongSelf.arr_policePoint];
                [strongSelf.arr_policePoint removeAllObjects];
            }
            
            strongSelf.arr_police = [manger.userGpsList mutableCopy];
            
            for (UserGpsListModel *model in strongSelf.arr_police) {
                PoliceAnnotation *annotation = [[PoliceAnnotation alloc] init];
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
                annotation.coordinate = coordinate;
                annotation.title    = model.userId;
                annotation.subtitle = model.userName;
                annotation.userModel = model;
                
                [strongSelf.arr_policePoint addObject:annotation];
            }
            
            if (strongSelf.arr_policePoint && strongSelf.arr_policePoint.count > 0) {
                [strongSelf.mapView addAnnotations:strongSelf.arr_policePoint];
            }
            
        }

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}


#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[VehicleCarAnnotation class]])
    {
        
        static NSString *customReuseIndetifier = @"VehicleCarViewID";
        MAAnnotationView *policeCarView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (policeCarView == nil)
        {
            policeCarView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            
        }
        
        policeCarView.image = [UIImage imageNamed:@"map_policeCar"];
        
        return policeCarView;
        
    }else if ([annotation isKindOfClass:[PoliceAnnotation class]]){
    

        static NSString *customReuseIndetifier = @"PoliceAnnotationID";
        MAAnnotationView *policeView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (policeView == nil)
        {
            policeView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            
        }
        
        policeView.image = [UIImage imageNamed:@"map_police"];
        
        return policeView;
    
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


- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        
        [self loadPoliceCarData];
        [self loadPoliceData];
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


#pragma mark - 按钮事件

#pragma mark - 单个警察点击按钮
- (IBAction)handleBtnOnePoliceClicked:(id)sender {
    
    
}

#pragma mark - 群组警察点击按钮
- (IBAction)handleBtnGroupPoliceClicked:(id)sender {
    
    
}


#pragma mark - 定位警察点击按钮
- (IBAction)handleBtnLocationPoliceClicked:(id)sender {
    
    
}


#pragma mark - 广播警察点击按钮
- (IBAction)handleBtnPushPoliceClicked:(id)sender {
    
    
    
}




#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    LxPrintf(@"PoliceCommandVC dealloc");

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
