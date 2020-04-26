//
//  DailyPatrolDetailVC.m
//  移动采集
//
//  Created by hcat-89 on 2020/1/8.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "DailyPatrolDetailVC.h"
#import "UIButton+NoRepeatClick.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "PeoplePatrolPolyline.h"
#import "PatrolPolyline.h"
#import "PeoplePointAnnotation.h"
#import "IllegalExposureVC.h"
#import "VideoColectVC.h"
#import "IllegalParkVC.h"
#import "DailyPatrolAnnotation.h"
#import "DailyPatrolAnnotationView.h"

@interface DailyPatrolDetailVC ()<MAMapViewDelegate,AMapSearchDelegate>

@property (nonatomic, strong) DailyPatrolDetailViewModel * viewModel;
@property (nonatomic, strong) MAMapView * mapView;

@property (nonatomic, strong) PeoplePatrolPolyline * peoplePatrolPolyline;
@property (nonatomic, strong) PatrolPolyline * patrolPolyline;

@property (weak, nonatomic) IBOutlet UILabel *lb_distance;
@property (weak, nonatomic) IBOutlet UILabel *lb_points;
@property (weak, nonatomic) IBOutlet UILabel *lb_expTime;

@property (weak, nonatomic) IBOutlet UIView *v_top;
@property (weak, nonatomic) IBOutlet UILabel *lb_top;

@property (weak, nonatomic) IBOutlet UIButton *btn_illegal;
@property (weak, nonatomic) IBOutlet UIButton *btn_takePicture;
@property (weak, nonatomic) IBOutlet UIButton *btn_signIn;
@property (weak, nonatomic) IBOutlet UIButton *btn_video;

@property (weak, nonatomic) IBOutlet UIButton *btn_throuht;

@property (weak, nonatomic) IBOutlet UIView *v_daogang;

@property (weak, nonatomic) IBOutlet UILabel *lb_daogangTime;
@property (weak, nonatomic) IBOutlet UILabel *lb_ligangTime;


@property (strong, nonatomic) UIButton *rightButton;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

@end

@implementation DailyPatrolDetailVC

- (instancetype)initWithViewModel:(DailyPatrolDetailViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self lr_configUI];
    [self lr_bindViewModel];
    
    [self.viewModel.command_detail execute:nil];
    if ([self.viewModel.type isEqualToNumber:@0]) {
        [self.viewModel.command_pointList execute:nil];
    }
    
}

- (void)lr_configUI{
    
    self.title = [NSString stringWithFormat:@"班次%@",[ShareFun translationArabicNum:[self.viewModel.shiftNum integerValue]]];
    
    self.v_top.hidden = YES;
    
    @weakify(self);
    
    if ([self.viewModel.type isEqualToNumber:@0]) {
        self.v_daogang.hidden = YES;
        self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 25)];
        self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 19, 0, -19);
        self.rightButton.isIgnore = YES;
    
        [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            if ([ShareValue sharedDefault].dailyPratrol_on) {
                [ShareValue sharedDefault].dailyPratrol_on = NO;
            }else{
                [ShareValue sharedDefault].dailyPratrol_on = YES;
            }
             
        }];
        UIBarButtonItem * rightitem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
        self.navigationItem.rightBarButtonItem = rightitem;
    }else{
        self.v_daogang.hidden = NO;
    }
    

    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    [self.view sendSubviewToBack:_mapView];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    _mapView.distanceFilter = 5.f;
    _mapView.showsCompass= NO;
    _mapView.showsScale= NO;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    
    [[self.btn_takePicture rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        if (![ShareValue sharedDefault].dailyPratrol_on &&[self.viewModel.type isEqualToNumber:@0]) {
            [ShareFun showTipLable:@"未开启巡逻"];
            return ;
        }
        
        IllegalExposureVC * vc = [[IllegalExposureVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [[self.btn_illegal rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        if (![ShareValue sharedDefault].dailyPratrol_on&&[self.viewModel.type isEqualToNumber:@0]) {
            [ShareFun showTipLable:@"未开启巡逻"];
            return ;
        }
        IllegalExposureVC * vc = [[IllegalExposureVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
         
    }];
    
    [[self.btn_video rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        if (![ShareValue sharedDefault].dailyPratrol_on&&[self.viewModel.type isEqualToNumber:@0]) {
            [ShareFun showTipLable:@"未开启巡逻"];
            return ;
        }
        VideoColectVC *t_vc = [[VideoColectVC alloc] init];
        [self.navigationController pushViewController:t_vc animated:YES];
         
    }];
    
    [[self.btn_throuht rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        if (![ShareValue sharedDefault].dailyPratrol_on&&[self.viewModel.type isEqualToNumber:@0]) {
            [ShareFun showTipLable:@"未开启巡逻"];
            return ;
        }
        IllegalParkVC *t_vc = [[IllegalParkVC alloc] init];
        t_vc.illegalType = IllegalTypeThrough;
        [self.navigationController pushViewController:t_vc animated:YES];
         
    }];
    
    
}

- (void)lr_bindViewModel{
    
    @weakify(self);
    
    [RACObserve([ShareValue sharedDefault], dailyPratrol_on) subscribeNext:^(id  _Nullable x) {
        
        @strongify(self);
        
        if ([x boolValue]) {
            
            [self.rightButton setImage:[UIImage imageNamed:@"btn_dailyPatrol_on"] forState:UIControlStateNormal];
            if (self.peoplePatrolPolyline) {
                [self.mapView addOverlay:self.peoplePatrolPolyline];
            }
            
            
        }else{
            
            [self.rightButton setImage:[UIImage imageNamed:@"btn_dailyPatrol_off"] forState:UIControlStateNormal];
            if (self.peoplePatrolPolyline) {
                [self.mapView removeOverlay:self.peoplePatrolPolyline];
            }
        
        }
    
    }];
    
    
    [RACObserve(self.viewModel, reponseModel) subscribeNext:^(DailyPatrolDetailReponse  * _Nullable x) {
        @strongify(self);
        
        if (x) {
            
            //画折线点
            if (x.patrolLocationList && x.patrolLocationList.count > 0) {
                
                if (self.viewModel.arr_point.count > 0) {
                    [self.mapView removeAnnotations:self.viewModel.arr_point];
                    [self.viewModel.arr_point removeAllObjects];
                }
                
                
                
                NSMutableArray * t_arr = @[].mutableCopy;
                for (int i = 0; i < x.patrolLocationList.count; i++) {
                    DailyPatrolLocationModel * model = x.patrolLocationList[i];
                    if ([model.type isEqualToNumber:@1]) {
                        [t_arr addObject:model];
                    }
                }
                
                for (int i = 0; i < t_arr.count; i++) {
                    
                    DailyPatrolLocationModel * model = t_arr[i];
                    
                    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
                    
                    if ([self.viewModel.type isEqualToNumber:@1]) {
                        
                        if (x.patrolSignList &&x.patrolSignList.count > 0) {
                            
                            for (int j = 0; j < x.patrolSignList.count; j++) {
                                DailyPatrolSignModel * t_model = x.patrolSignList[j];
                                
                                if (j == 0) {
                                    model.pointType = @0;
                                    model.signInTime = t_model.createTime;
                                    self.lb_daogangTime.text = [NSString stringWithFormat:@"到岗时间：%@",[ShareFun timeWithTimeInterval:t_model.createTime dateFormat:@"MM-dd HH:mm:ss"]];
                                }else if (j == 1){
                                    model.pointType = @1;
                                    model.signOutTime = t_model.createTime;
                                    self.lb_ligangTime.text = [NSString stringWithFormat:@"离岗时间：%@",[ShareFun timeWithTimeInterval:t_model.createTime dateFormat:@"MM-dd HH:mm:ss"]];
                                }
                            
                            }
                            
                        }else{
                            model.pointType = @2;
                        }
                        
                        DailyPatrolAnnotation * annotation = [[DailyPatrolAnnotation alloc] init];
                        annotation.coordinate = coordinate;
                        annotation.title    = [NSString stringWithFormat:@"巡逻点%d",i];
                        annotation.model = model;
                        annotation.type = self.viewModel.type;
                        [self.viewModel.arr_point addObject:annotation];
                        break;
                        
                    }
                    
                    
                    if (i == 0) {
                        
                        DailyPatrolAnnotation * annotation = [[DailyPatrolAnnotation alloc] init];
                        annotation.coordinate = coordinate;
                        annotation.title    = [NSString stringWithFormat:@"巡逻点%d",i];
                        annotation.model = model;
                        [self.viewModel.arr_point addObject:annotation];
                        
//                        MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
//                        startAnnotation.coordinate = coordinate;
//                        startAnnotation.title    = @"起点";
//                        startAnnotation.subtitle = @"起点";
//                        [self.viewModel.arr_point addObject:startAnnotation];
                        
                    }else if(i == t_arr.count - 1){
                        
                        DailyPatrolAnnotation *annotation = [[DailyPatrolAnnotation alloc] init];
                        annotation.coordinate = coordinate;
                        annotation.title    = [NSString stringWithFormat:@"巡逻点%d",i];
                        annotation.model = model;
                        [self.viewModel.arr_point addObject:annotation];
                        
//                        MAPointAnnotation *endAnnotation = [[MAPointAnnotation alloc] init];
//                        endAnnotation.coordinate = coordinate;
//                        endAnnotation.title    = @"终点";
//                        endAnnotation.subtitle = @"终点";
//                        [self.viewModel.arr_point addObject:endAnnotation];
                        
                    }else{
                        
                        DailyPatrolAnnotation *annotation = [[DailyPatrolAnnotation alloc] init];
                        annotation.coordinate = coordinate;
                        annotation.title    = [NSString stringWithFormat:@"巡逻点%d",i];
                        annotation.model = model;
                        [self.viewModel.arr_point addObject:annotation];
                        
                    }
                    
                }
                
            }
            
            if (self.viewModel.arr_point.count > 0) {
                
                [self.mapView addAnnotations:self.viewModel.arr_point];
                
                if ([self.viewModel.type isEqualToNumber:@1]) {
                    DailyPatrolAnnotation *annotation = self.viewModel.arr_point[0];
                    [self.mapView setCenterCoordinate:annotation.coordinate];
                    [self.mapView setZoomLevel:15];
                }else{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        @strongify(self);
                        [self showsAnnotations:self.viewModel.arr_point edgePadding:UIEdgeInsetsMake(50, 50, 50, 50) andMapView:self.mapView];
                        
                    });
                }
                
                
            }
            
            //画巡逻折线
            if (x.patrolLocationList && x.patrolLocationList.count > 0 && [self.viewModel.type isEqualToNumber:@0]) {
            
            
                NSMutableArray * t_arr = @[].mutableCopy;
                for (int i = 0; i < x.patrolLocationList.count; i++) {
                    DailyPatrolLocationModel * model = x.patrolLocationList[i];
                    if ([model.type isEqualToNumber:@0]) {
                        [t_arr addObject:model];
                    }
                }
                
                
                CLLocationCoordinate2D commonPolylineCoords[t_arr.count];
            
                for (int i = 0; i < t_arr.count; i++) {
                    DailyPatrolLocationModel * model = t_arr[i];
                
                    commonPolylineCoords[i].latitude = [model.latitude doubleValue];
                    commonPolylineCoords[i].longitude = [model.longitude doubleValue];
                }
                //构造折线对象
                
                if (self.patrolPolyline) {
                    [self.mapView removeOverlay:self.patrolPolyline];
                }
                
                self.patrolPolyline = [PatrolPolyline polylineWithCoordinates:commonPolylineCoords count:t_arr.count];
                
                [self.mapView addOverlay:self.patrolPolyline];
                
            }
            
            
            if (x.patrolInfo && [self.viewModel.type isEqualToNumber:@0]) {
                
                NSString * t_distance = [NSString stringWithFormat:@"路线长度%@m",x.patrolInfo.distance];  //距离
                self.lb_distance.attributedText = [ShareFun highlightInString:t_distance withSubString:x.patrolInfo.distance];
            
                NSString * t_points = [NSString stringWithFormat:@"打卡点%@个",[x.patrolInfo.points stringValue]];  //打卡点
                self.lb_points.attributedText = [ShareFun highlightInString:t_points withSubString:[x.patrolInfo.points stringValue]];
                
                NSString * t_expTime = [NSString stringWithFormat:@"约%@分钟",[x.patrolInfo.expTime stringValue]];  //花费时间
                self.lb_expTime.attributedText = [ShareFun highlightInString:t_expTime withSubString:[x.patrolInfo.expTime stringValue]];
                
            }
            
            
            if ([x.status isEqualToNumber:@0]) {
                self.v_top.hidden = NO;
                self.lb_top.text = @"未到开始时间";
                self.rightButton.hidden = YES;
            }else if ([x.status isEqualToNumber:@2]){
                self.v_top.hidden = NO;
                self.rightButton.hidden = YES;
                self.lb_top.text = @"已超时";
            }else{
                self.rightButton.hidden = NO;
                self.v_top.hidden = YES;
            }
            
        }
        
    }];
    
    [self.viewModel.command_sign.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
    
        if ([x isEqualToString:@"签到成功"]) {
        
                [self.viewModel.command_detail execute:nil];
            
        }
        
    }];
    
    [self.viewModel.command_pointSign.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        if ([x isEqualToString:@"签到成功"]) {
            [self.viewModel.command_detail execute:nil];
        }
            
    }];
    
    [RACObserve(self.viewModel, arr_people) subscribeNext:^(NSArray<DailyPatrolPointModel *>  * _Nullable x) {
        @strongify(self);
        
        if (x && x.count > 0) {
            
            CLLocationCoordinate2D commonPolylineCoords[x.count];
            
            for (int i = 0; i < x.count; i++) {
                
                DailyPatrolPointModel * model = x[i];
                
                commonPolylineCoords[i].latitude = [model.latitude doubleValue];
                commonPolylineCoords[i].longitude = [model.longitude doubleValue];
                
            }
            
            if (self.peoplePatrolPolyline) {
                [self.mapView removeOverlay:self.peoplePatrolPolyline];
            }
            
            self.peoplePatrolPolyline = [PeoplePatrolPolyline polylineWithCoordinates:commonPolylineCoords count:x.count];
            
            [self.mapView addOverlay:self.peoplePatrolPolyline];
            
        }
    
    }];
    

}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[DailyPatrolAnnotation class]]){
        
        DailyPatrolAnnotation *vehicle = (DailyPatrolAnnotation *)annotation;
        
        static NSString *customReuseIndetifier = @"DailyPatrolAnnotationID";
        DailyPatrolAnnotationView *vehicleCarView = (DailyPatrolAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        @weakify(self);
        if (vehicleCarView == nil)
        {
            vehicleCarView = [[DailyPatrolAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            vehicleCarView.block = ^(DailyPatrolAnnotation *carAnnotation) {
                @strongify(self);
                LxDBAnyVar(carAnnotation);
                
                
                if ([carAnnotation.type isEqualToNumber:@1]) {
                    //站岗
                    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([carAnnotation.model.latitude doubleValue], [carAnnotation.model.longitude doubleValue]);
                    
                    if ([carAnnotation.model.pointType isEqualToNumber:@2]) {
                    if(MACircleContainsCoordinate(self.mapView.userLocation.location.coordinate, coordinate, 50)) {
                                
                            self.viewModel.latitude = @(self.mapView.userLocation.location.coordinate.latitude);
                            self.viewModel.longitude = @(self.mapView.userLocation.location.coordinate.longitude);
                            self.viewModel.point = @0;
                            self.viewModel.pointType = @0;
                            [self.viewModel.command_pointSign execute:nil];
                                    
                        }else{
                            DMProgressHUD *hud = [DMProgressHUD showStatusHUDAddedTo:self.view statusType:DMProgressHUDStatusTypeFail];
                            hud.style = DMProgressHUDStyleDark;
                            hud.text = @"当前不在签到位置范围";
                            [hud dismissAfter:1.0f];
                        }
                    }else if ([carAnnotation.model.pointType isEqualToNumber:@0]){
                    if(MACircleContainsCoordinate(self.mapView.userLocation.location.coordinate, coordinate, 50)) {
                                
                            self.viewModel.latitude = @(self.mapView.userLocation.location.coordinate.latitude);
                            self.viewModel.longitude = @(self.mapView.userLocation.location.coordinate.longitude);
                            self.viewModel.point = @0;
                            self.viewModel.pointType = @1;
                            [self.viewModel.command_pointSign execute:nil];
                                    
                        }else{
                            DMProgressHUD *hud = [DMProgressHUD showStatusHUDAddedTo:self.view statusType:DMProgressHUDStatusTypeFail];
                            hud.style = DMProgressHUDStyleDark;
                            hud.text = @"当前不在签到位置范围";
                            [hud dismissAfter:1.0f];
                        }
                        
                    }else{
                        [LRShowHUD showError:@"已离岗无法操作" duration:1.5];
                    }
                    
                    
                }else{
                    if (![ShareValue sharedDefault].dailyPratrol_on) {
                        [ShareFun showTipLable:@"未开启巡逻"];
                        return ;
                    }
                    
                    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([carAnnotation.model.latitude doubleValue], [carAnnotation.model.longitude doubleValue]);
                if(MACircleContainsCoordinate(self.mapView.userLocation.location.coordinate, coordinate, 50)) {
                        
                        self.viewModel.latitude = @(self.mapView.userLocation.location.coordinate.latitude);
                        self.viewModel.longitude = @(self.mapView.userLocation.location.coordinate.longitude);
                        self.viewModel.point = carAnnotation.model.sort;
                            [self.viewModel.command_sign execute:nil];
                            
                    }else{
                        DMProgressHUD *hud = [DMProgressHUD showStatusHUDAddedTo:self.view statusType:DMProgressHUDStatusTypeFail];
                        hud.style = DMProgressHUDStyleDark;
                        hud.text = @"当前不在签到位置范围";
                        [hud dismissAfter:1.0f];
                    }
                    
                }
                
            };
        }
        
        //很重要的，配置关联的模型数据
        vehicleCarView.annotation = vehicle;
        
        
        return vehicleCarView;
        
    }
        
    return nil;
}


- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[PatrolPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 6.f;
        polylineRenderer.strokeColor  = UIColorFromRGB(0x3396FC);
        polylineRenderer.lineJoin = kCGLineJoinRound;
        polylineRenderer.lineCap  = kCGLineCapRound;
        
        return polylineRenderer;
    }else if ([overlay isKindOfClass:[PeoplePatrolPolyline class]]){
        
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
               
        polylineRenderer.lineWidth    = 6.f;
        polylineRenderer.strokeColor  = UIColorFromRGB(0xFC7E2C);
        polylineRenderer.lineJoin = kCGLineJoinRound;
        polylineRenderer.lineCap  = kCGLineCapRound;
               
        return polylineRenderer;
        
    }
    return nil;
}



/**
 * brief 根据传入的annotation来展现：保持中心点不变的情况下，展示所有传入annotation
 * @param annotations annotation
 * @param insets 填充框，用于让annotation不会靠在地图边缘显示
 * @param mapView 地图view
 */
- (void)showsAnnotations:(NSArray *)annotations edgePadding:(UIEdgeInsets)insets andMapView:(MAMapView *)mapView {
    
    MAMapRect rect = MAMapRectZero;
    
    for (MAPointAnnotation *annotation in annotations) {
        
        ///annotation相对于中心点的对角线坐标
        CLLocationCoordinate2D diagonalPoint = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude - (annotation.coordinate.latitude - mapView.centerCoordinate.latitude),mapView.centerCoordinate.longitude - (annotation.coordinate.longitude - mapView.centerCoordinate.longitude));
        
        MAMapPoint annotationMapPoint = MAMapPointForCoordinate(annotation.coordinate);
        MAMapPoint diagonalPointMapPoint = MAMapPointForCoordinate(diagonalPoint);
        
        ///根据annotation点和对角线点计算出对应的rect（相对于中心点）
        MAMapRect annotationRect = MAMapRectMake(MIN(annotationMapPoint.x, diagonalPointMapPoint.x), MIN(annotationMapPoint.y, diagonalPointMapPoint.y), ABS(annotationMapPoint.x - diagonalPointMapPoint.x), ABS(annotationMapPoint.y - diagonalPointMapPoint.y));
        
        rect = MAMapRectUnion(rect, annotationRect);
    }
    
    [mapView setVisibleMapRect:rect edgePadding:insets animated:NO];
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor clearColor];
        pre.strokeColor = [UIColor clearColor];
        pre.image = [UIImage imageNamed:@"map_location"];
        pre.lineWidth = 0;
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

- (void)dealloc{
    LxPrintf(@"DailyPatrolDetailVC dealloc");
}

@end
