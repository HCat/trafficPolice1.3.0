//
//  UserTaskDetailVC.m
//  移动采集
//
//  Created by hcat on 2017/11/3.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "UserTaskDetailVC.h"
#import <MAMapKit/MAMapKit.h>
#import "UINavigationBar+BarItem.h"

@interface UserTaskDetailVC ()<MAMapViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_detail;
@property (weak, nonatomic) IBOutlet UIView *v_detail;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;


@end

@implementation UserTaskDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务详情";
    [self showRightBarButtonItemWithImage:@"nav_center" target:self action:@selector(makeLocationInCenter)];
    _v_detail.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    _v_detail.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    _v_detail.layer.shadowOpacity = 0.5;//不透明度
    _v_detail.layer.shadowRadius = 10.0;//半径
    [self initMapView];
    [self setTask:_task];
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

#pragma mark - set && get

- (void)setTask:(TaskModel *)task{

    _task = task;
    
    if (_task) {
        _lb_address.text = [ShareFun takeStringNoNull:_task.address];
        _lb_name.text = [ShareFun takeStringNoNull:_task.taskName];
        _lb_time.text = [ShareFun timeWithTimeInterval:_task.arrivalTime];
        _lb_detail.text = [ShareFun takeStringNoNull:_task.content];
        
        if (_task.latitude && _task.longitude) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_task.latitude doubleValue], [_task.longitude doubleValue]);
            
            MAPointAnnotation *annotation_task = [[MAPointAnnotation alloc] init];
            annotation_task.coordinate = coordinate;
            [_mapView addAnnotation:annotation_task];
            
            [_mapView setCenterCoordinate:coordinate animated:YES];
        }
        
    }
    
    
    
    
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"icon_certenLocation"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        //annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    /* Adjust the map center in order to show the callout view completely. */
    if ([view isKindOfClass:[MAAnnotationView class]]) {
        
       
        
    }
}


- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
    
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:183/255.f green:230/255.f blue:251/255.f alpha:0.3];
        pre.strokeColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
        pre.image = [UIImage imageNamed:@"icon_personLocation"];
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
    LxPrintf(@"UserTaskDetailVC dealloc");
    
}


@end
