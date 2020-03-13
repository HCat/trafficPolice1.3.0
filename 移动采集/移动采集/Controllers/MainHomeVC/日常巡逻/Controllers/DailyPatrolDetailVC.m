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


@property (strong, nonatomic) UIButton *rightButton;

@property (nonatomic,strong) NSTimer *time_upLocation;

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
    [self.viewModel.command_pointList execute:nil];
}

- (void)lr_configUI{
    
    self.title = [NSString stringWithFormat:@"班次%@",[ShareFun translationArabicNum:[self.viewModel.shiftNum integerValue]]];
    
    self.v_top.hidden = YES;
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 25)];
    self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 19, 0, -19);
    self.rightButton.isIgnore = YES;
    
    @weakify(self);
    [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        if ([ShareValue sharedDefault].dailyPratrol_on) {
            [ShareValue sharedDefault].dailyPratrol_on = NO;
        }else{
            [ShareValue sharedDefault].dailyPratrol_on = YES;
        }
         
    }];
    UIBarButtonItem * rightitem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightitem;
    
    
    
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
    _mapView.distanceFilter = 200;
    _mapView.showsCompass= NO;
    _mapView.showsScale= NO;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    
    [[self.btn_signIn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        if (![ShareValue sharedDefault].dailyPratrol_on) {
            [ShareFun showTipLable:@"未开启巡逻"];
            return ;
        }
        
        if (self.viewModel.reponseModel.patrolLocationList && self.viewModel.reponseModel.patrolLocationList.count > 0) {
         
            for (int i = 0; i < self.viewModel.reponseModel.patrolLocationList.count; i++) {
            
                DailyPatrolLocationModel * model = self.viewModel.reponseModel.patrolLocationList[i];
                if ([model.type isEqualToNumber:@0]) {
                    continue;
                }
                
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
                if(MACircleContainsCoordinate(self.mapView.userLocation.location.coordinate, coordinate, 50)) {
                    if ([model.status isEqualToNumber:@1]) {
                        DMProgressHUD *hud = [DMProgressHUD showStatusHUDAddedTo:self.view statusType:DMProgressHUDStatusTypeFail];
                        hud.style = DMProgressHUDStyleDark;
                        hud.text = @"当前签到点已经签到过";
                        [hud dismissAfter:1.0f];
                       
                    }else{
                        
                        self.viewModel.latitude = model.latitude;
                        self.viewModel.longitude = model.longitude;
                        self.viewModel.point = model.sort;
                        [self.viewModel.command_sign execute:nil];
                        
                    }
                    
                    break;
                }
                
                if (i == self.viewModel.reponseModel.patrolLocationList.count - 1) {
                    DMProgressHUD *hud = [DMProgressHUD showStatusHUDAddedTo:self.view statusType:DMProgressHUDStatusTypeFail];
                    hud.style = DMProgressHUDStyleDark;
                    hud.text = @"当前不在签到位置范围";
                    [hud dismissAfter:1.0f];
                }
                
            }
            
        }
        
        
    }];
    
    [[self.btn_takePicture rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        if (![ShareValue sharedDefault].dailyPratrol_on) {
            [ShareFun showTipLable:@"未开启巡逻"];
            return ;
        }
        
        IllegalExposureVC * vc = [[IllegalExposureVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [[self.btn_illegal rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        if (![ShareValue sharedDefault].dailyPratrol_on) {
            [ShareFun showTipLable:@"未开启巡逻"];
            return ;
        }
        IllegalExposureVC * vc = [[IllegalExposureVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
         
    }];
    
    [[self.btn_video rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        if (![ShareValue sharedDefault].dailyPratrol_on) {
            [ShareFun showTipLable:@"未开启巡逻"];
            return ;
        }
        VideoColectVC *t_vc = [[VideoColectVC alloc] init];
        [self.navigationController pushViewController:t_vc animated:YES];
         
    }];
    
    [[self.btn_throuht rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        if (![ShareValue sharedDefault].dailyPratrol_on) {
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
                    
                    
                    
                    if (i == 0) {
                        
                        MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
                        startAnnotation.coordinate = coordinate;
                        startAnnotation.title    = @"起点";
                        startAnnotation.subtitle = @"起点";
                        [self.viewModel.arr_point addObject:startAnnotation];
                        
                        PeoplePointAnnotation *annotation = [[PeoplePointAnnotation alloc] init];
                        annotation.coordinate = coordinate;
                        annotation.title    = [NSString stringWithFormat:@"巡逻点%d",i];
                        annotation.model = model;
                        [self.viewModel.arr_point addObject:annotation];
                        
                    }else if(i == t_arr.count - 1){
                        
                        PeoplePointAnnotation *annotation = [[PeoplePointAnnotation alloc] init];
                        annotation.coordinate = coordinate;
                        annotation.title    = [NSString stringWithFormat:@"巡逻点%d",i];
                        annotation.model = model;
                        [self.viewModel.arr_point addObject:annotation];
                        
                        MAPointAnnotation *endAnnotation = [[MAPointAnnotation alloc] init];
                        endAnnotation.coordinate = coordinate;
                        endAnnotation.title    = @"终点";
                        endAnnotation.subtitle = @"终点";
                        [self.viewModel.arr_point addObject:endAnnotation];
                        
                    }else{
                        
                        PeoplePointAnnotation *annotation = [[PeoplePointAnnotation alloc] init];
                        annotation.coordinate = coordinate;
                        annotation.title    = [NSString stringWithFormat:@"巡逻点%d",i];
                        annotation.model = model;
                        [self.viewModel.arr_point addObject:annotation];
                        
                    }
                    
                }
                
            }
            
            if (self.viewModel.arr_point.count > 0) {
                
                [self.mapView addAnnotations:self.viewModel.arr_point];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    @strongify(self);
                    [self showsAnnotations:self.viewModel.arr_point edgePadding:UIEdgeInsetsMake(50, 50, 50, 50) andMapView:self.mapView];
                    
                });
            }
            
            //画巡逻折线
            if (x.patrolLocationList && x.patrolLocationList.count > 0) {
            
            
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
            
            
            if (x.patrolInfo) {
                
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
        
            if (self.viewModel.reponseModel.patrolLocationList && self.viewModel.reponseModel.patrolLocationList.count > 0) {
            
               for (int i = 0; i < self.viewModel.reponseModel.patrolLocationList.count; i++) {
               
                   DailyPatrolLocationModel * model = self.viewModel.reponseModel.patrolLocationList[i];
                   if ([model.sort isEqualToNumber:self.viewModel.point]) {
                       model.status = @1;
                       self.viewModel.reponseModel = self.viewModel.reponseModel;
                   }
                
               }
            }
           
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
    
    if ([annotation isKindOfClass:[PeoplePointAnnotation class]]){
        
        PeoplePointAnnotation *vehicle = (PeoplePointAnnotation *)annotation;
        
        static NSString *customReuseIndetifier = @"PeoplePointAnnotationID";
        MAAnnotationView *positionView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
               
        if (positionView == nil) {
            positionView = [[MAAnnotationView alloc] initWithAnnotation:vehicle reuseIdentifier:customReuseIndetifier];
        }
               
        positionView.canShowCallout = YES;
        //起点，终点的图标标注
        if ([vehicle.model.status isEqualToNumber:@0]) {
            positionView.image = [UIImage imageNamed:@"icon_dailyPatrol_unSignIn"];
        }else{
            positionView.image = [UIImage imageNamed:@"icon_dailyPatrol_signIn"];
        }
               
        return positionView;
        
    }else if ([annotation isKindOfClass:[MAPointAnnotation class]]){
        static NSString *customReuseIndetifier = @"positionAnnotationID";
        MAAnnotationView *positionView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (positionView == nil) {
            positionView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
        }
        
        positionView.canShowCallout = YES;
        positionView.centerOffset = CGPointMake(0, -16.8f);
        //起点，终点的图标标注
        if ([annotation.title isEqualToString:@"起点"]) {
            positionView.image = [UIImage imageNamed:@"icon_map_origin"];
        }else{
            positionView.image = [UIImage imageNamed:@"icon_map_destination"];
        }
        
        return positionView;
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
    
    [mapView setVisibleMapRect:rect edgePadding:insets animated:YES];
}



#pragma mark - dealloc

- (void)dealloc{
    LxPrintf(@"DailyPatrolDetailVC dealloc");
}

@end
