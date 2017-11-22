//
//  MessageDetailVC.m
//  移动采集
//
//  Created by hcat on 2017/8/31.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "MessageDetailVC.h"
#import "IdentifyAPI.h"
#import <MAMapKit/MAMapKit.h>

@interface MessageDetailVC ()<MAMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *v_content;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_content;

@property (weak, nonatomic) IBOutlet UIButton *btn_makesure;
@property (weak, nonatomic) IBOutlet UIButton *btn_complete;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_btnAndVContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_btnBottom;


@end

@implementation MessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _btn_makesure.hidden = YES;
    
    _lb_time.text = [ShareFun timeWithTimeInterval:_model.createTime];
    _lb_content.text = _model.content;
    
    if ([_model.type isEqualToNumber:@1]) {
        self.title = @"特殊车辆通知";
        
        _btn_complete.hidden = YES;
        _v_content.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
        _v_content.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
        _v_content.layer.shadowOpacity = 0.5;//不透明度
        _v_content.layer.shadowRadius = 10.0;//半径
    
        self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.showsCompass= NO;
        _mapView.showsScale= NO;
        _mapView.delegate = self;
        [self.view addSubview:_mapView];
        [self.view sendSubviewToBack:_mapView];
        
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        [_mapView setZoomLevel:16.1 animated:YES];
        
        if (_model.latitude && _model.longitude) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_model.latitude doubleValue], [_model.longitude doubleValue]);
            
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            annotation.coordinate = coordinate;
            annotation.title    = self.title;
            annotation.subtitle = _model.content;
            
            [_mapView addAnnotation:annotation];
            
            [_mapView setCenterCoordinate:coordinate animated:YES];
            
        }
        
        
    }else if ([_model.type isEqualToNumber:@2]){
        self.title = @"出警任务";
    
        if ([_model.flag isEqualToNumber:@0]) {
            _btn_complete.hidden = YES;
        }else{
            if ([_model.state isEqualToNumber:@0]) {
                _btn_complete.hidden = NO;
            }else{
                _btn_complete.hidden = YES;
            }
            
        }
        
    }else if ([_model.type isEqualToNumber:@3]){
        
        self.title = @"警务消息";
        _btn_complete.hidden = YES;
    
    }else if ([_model.type isEqualToNumber:@100] || [_model.type isEqualToNumber:@101]){
        
        self.title = @"系统消息";
        _btn_complete.hidden = YES;

    }
    
    _layout_btnAndVContent.priority = UILayoutPriorityDefaultLow;
    [self.view layoutIfNeeded];
    
    [self handleBtnMakeSureClicked:nil];
}

#pragma mark - 确定按钮事件

- (IBAction)handleBtnMakeSureClicked:(id)sender {
    
    if ([_model.flag isEqualToNumber:@0]) {
        
        IdentifySetMsgReadManger *manger = [[IdentifySetMsgReadManger alloc] init];
        manger.msgId = _model.msgId;
        
        WS(weakSelf);
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            SW(strongSelf, weakSelf);
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                strongSelf.model.flag = @1;
                if ([strongSelf.model.state isEqualToNumber:@0]) {
                    strongSelf.btn_complete.hidden = NO;
                }else{
                    strongSelf.btn_complete.hidden = YES;
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MAKESURENOTIFICATION_SUCCESS object:_model.source];
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        
        }];
    }
    
}

#pragma mark - 完成按钮事件

- (IBAction)handleBtnCompleteClicked:(id)sender {
    
    if ([_model.state isEqualToNumber:@0]) {
        
        
        IdentifyFinishPoliceCallManger *manger = [[IdentifyFinishPoliceCallManger alloc] init];
        manger.msgId = _model.msgId;
        [manger configLoadingTitle:@"请求"];
        
        WS(weakSelf);
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            SW(strongSelf, weakSelf);
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                strongSelf.model.state = @1;
                strongSelf.btn_complete.hidden = YES;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COMPLETENOTIFICATION_SUCCESS object:_model.source];
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            
        }];
    }
    
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"map_superCar"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        //annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
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

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation && self.userLocationAnnotationView != nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            
            double degree = userLocation.heading.trueHeading;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
            
        }];
    }
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    LxPrintf(@"MessageDetailVC dealloc");
}


@end
