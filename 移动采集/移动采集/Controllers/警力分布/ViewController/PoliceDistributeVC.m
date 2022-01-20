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
#import "PoliceDetailDisAnnotationView.h"
#import "PolicePerformView.h"
#import "PoliceReleaseRadioVC.h"
#import "PoliceHistorySearchVC.h"
#import "PoliceCarDetailView.h"
#import "XDSDropDownMenu.h"
#import "UIButton+NoRepeatClick.h"


@interface PoliceDistributeVC ()<MAMapViewDelegate,AMapLocationManagerDelegate,XDSDropDownMenuDelegate>

@property (nonatomic,strong) PoliceDistributeViewModel * viewModel;

@property (weak, nonatomic) IBOutlet UIButton * btn_search;
@property (weak, nonatomic) IBOutlet UIButton * btn_usrLocation;
@property (weak, nonatomic) IBOutlet UIButton * btn_radio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_topView_height;

@property (weak, nonatomic) IBOutlet UIButton *btn_selected_online;
@property (weak, nonatomic) IBOutlet UIButton *btn_selected_offline;
@property (weak, nonatomic) IBOutlet UIButton *btn_refresh;

@property (nonatomic, strong) XDSDropDownMenu *dropDownMenu_online;
@property (nonatomic, strong) XDSDropDownMenu *dropDownMenu_offline;

@property (nonatomic, strong) MAMapView * mapView;
@property (nonatomic, strong) MAPointAnnotation * positionAnnotation; //定位的坐标点
@property (nonatomic, strong) MACircle * positionCircle;              //定位画的圆
@property (nonatomic, strong) PoliceCarDetailView *policeCarDetailView; //警车详情

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
    @weakify(self);
    self.zx_hideBaseNavBar = YES;
    _layout_topView_height.constant = Height_NavBar;
    self.btn_selected_online.isIgnore = YES;
    self.btn_selected_offline.isIgnore = YES;
    
    [self initMapView];
    
    self.dropDownMenu_online = [[XDSDropDownMenu alloc] init];
    self.dropDownMenu_online.tag = 1000;
    self.dropDownMenu_offline = [[XDSDropDownMenu alloc] init];
    self.dropDownMenu_offline.tag = 1000;
    
//    self.btn_selected_online.layer.cornerRadius = 3.f;
//    self.btn_selected_offline.layer.cornerRadius = 3.f;
    
    self.btn_refresh.layer.cornerRadius = 3.f;
    
    
    //发起定位请求
    [self.viewModel.locationCommand execute:@1];
    //定位之后所要做的UI操作
    [self.viewModel.locationSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(NSNumber * latitude, NSNumber * longitude) = x;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        [self.mapView setCenterCoordinate:coordinate animated:YES];
        
        if (self.positionAnnotation) {
            [self.mapView removeAnnotation:self.positionAnnotation];
            self.positionAnnotation = nil;
        }
        
        self.positionAnnotation = [[MAPointAnnotation alloc] init];
        self.positionAnnotation.coordinate = coordinate;
        self.positionAnnotation.title    = @"百度地图中心点";
        self.positionAnnotation.subtitle = @"百度地图中心点";
        
        [self.mapView addAnnotation:self.positionAnnotation];
        
        
    }];
    
    //点击警员头像显示详情
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:NOTIFICATION_POLICE_SHOWDETAIL object:nil] subscribeNext:^(id x) {
        @strongify(self);
        NSNotification * notification = x;
        PoliceDistributeAnnotation * notific_model = notification.object;
        if ([notific_model.policeType isEqualToNumber:@2]) {
            
            if (self.policeCarDetailView == nil) {
                self.policeCarDetailView = [PoliceCarDetailView initCustomView];
                [self.policeCarDetailView configureForAutoLayout];
                
            }
            
            [self.view addSubview:self.policeCarDetailView];
            [self.policeCarDetailView autoPinEdgesToSuperviewEdges];
            
            self.policeCarDetailView.policeCarName = notific_model.vehicleCar.plateNo;
            
        }else{
            PoliceDetailDisAnnotationView * view = [PoliceDetailDisAnnotationView initCustomView];
            view.policeModel = notific_model.policeModel;
            [view show];
        }
    
    }];
    
    //点击警员头像显示详情
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:NOTIFICATION_POLICE_SEARCH object:nil] subscribeNext:^(id x) {
        @strongify(self);
        NSNotification * notification = x;
        RACTupleUnpack(NSNumber * lat,NSNumber * lng) = notification.object;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
        [self.mapView setCenterCoordinate:coordinate animated:YES];
        
    }];
    
    
    //数据请求
    [self.viewModel.allPoliceCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
        @strongify(self);
    
        if (self.viewModel.arr_point && self.viewModel.arr_point.count > 0) {
            [self.mapView addAnnotations:self.viewModel.arr_point];
        }
        
        if (self.viewModel.peopleNumber) {
           
            NSString * t_string_online = [NSString stringWithFormat:@"在岗数：%d",[self.viewModel.peopleNumber.online intValue]];
            NSString * t_string_offline = [NSString stringWithFormat:@"离岗数：%d",[self.viewModel.peopleNumber.offline intValue]];
            
            [self.btn_selected_online setTitle:t_string_online forState:UIControlStateNormal];
            [self.btn_selected_offline setTitle:t_string_offline forState:UIControlStateNormal];
        
        }
        
    
    }];
    

    [[_btn_radio rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        PolicePerformView * view = [PolicePerformView initCustomView];
        if (self.viewModel.arr_data && self.viewModel.arr_data.count > 0) {
            NSMutableArray * mArr_t = @[].mutableCopy;
            for (PoliceLocationModel * model in self.viewModel.arr_data) {
                [mArr_t addObject:model.userName];
            }
            view.name_string = [mArr_t componentsJoinedByString:@","];
        }
        
        view.editBlock = ^{
            
            @strongify(self);
            
            NSMutableArray * t_arr = @[].mutableCopy;
            if (self.viewModel.arr_data && self.viewModel.arr_data.count > 0) {
                for (PoliceLocationModel * model in self.viewModel.arr_data) {
                    [t_arr addObject:model.userId];
                }
            }
            PoliceReleaseRadioVC * radiovc = [[PoliceReleaseRadioVC alloc] init];
            radiovc.userIds = [t_arr componentsJoinedByString:@","];
            [self.navigationController pushViewController:radiovc animated:YES];
            
        };
        
        [view show];
        
    }];
    
    [[_btn_search rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        PoliceHistorySearchVC * t_vc = [[PoliceHistorySearchVC alloc] init];
        [self.navigationController pushViewController:t_vc animated:YES];
        
    }];
    
    [[_btn_usrLocation rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        //发起定位请求
        [self.viewModel.locationCommand execute:@1];
        
    }];
    
    
    [self.viewModel.allPoliceCommand execute:nil];
    
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
    
    
    _mapView.distanceFilter = 10;
    _mapView.showsCompass= NO;
    _mapView.showsScale= NO;
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = MAUserTrackingModeNone;
    _mapView.maxZoomLevel = 20;
    _mapView.minZoomLevel = 10;
    [_mapView setZoomLevel:12.5f animated:YES];
    
}


#pragma mark - 画定位的圆形还有坐标

- (void) drawCircleRange{
    
    if (_positionCircle) {
        [_mapView removeOverlay:_positionCircle];
        self.positionCircle = nil;
    }
    
    self.positionCircle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake([self.viewModel.latitude doubleValue], [self.viewModel.longitude doubleValue]) radius:[self.viewModel.range intValue] * 1000];
    [_mapView addOverlay:_positionCircle];
    
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
    [self drawCircleRange];
    //请求数据
    [self.viewModel.loadingSubject sendNext:self.mapView];
    
}


#pragma mark - buttonAction

- (IBAction)handleBtnBackClickingAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)handleBtnNumber_online:(id)sender {
    
    if(self.viewModel.arr_people.count > 0){
        
        self.dropDownMenu_online.delegate = self;//设置代理
        //调用方法判断是显示下拉菜单，还是隐藏下拉菜单
        
        NSMutableArray * t_arr = @[].mutableCopy;
        
        for (PoliceLocationModel * model in self.viewModel.arr_people) {
            
            if ([model.isline boolValue]) {
                NSString * t_nameStr = [NSString stringWithFormat:@"%@(%@)",[ShareFun takeStringNoNull:model.userName],[ShareFun takeStringNoNull:model.telNum]];
                [t_arr addObject:t_nameStr];
            }
        
        }
        
        
        
        [self setupDropDownMenu:self.dropDownMenu_online withTitleArray:t_arr andButton:sender andDirection:@"down"];
        [self hideOtherDropDownMenu:self.dropDownMenu_online];
    }
    
}

- (IBAction)handleBtnNumber_offline:(id)sender {
    
    if(self.viewModel.arr_people.count > 0){
        
        self.dropDownMenu_offline.delegate = self;//设置代理
        //调用方法判断是显示下拉菜单，还是隐藏下拉菜单
        
        NSMutableArray * t_arr = @[].mutableCopy;
        
        for (PoliceLocationModel * model in self.viewModel.arr_people) {
            
            if (![model.isline boolValue]) {
                NSString * t_nameStr = [NSString stringWithFormat:@"%@(%@)",[ShareFun takeStringNoNull:model.userName],[ShareFun takeStringNoNull:model.telNum]];
                [t_arr addObject:t_nameStr];
            }
        }
        
        
        [self setupDropDownMenu:self.dropDownMenu_offline withTitleArray:t_arr andButton:sender andDirection:@"down"];
        [self hideOtherDropDownMenu:self.dropDownMenu_offline];
    }
    
}


- (IBAction)handleBtnRefresh:(id)sender {
    
    [self.viewModel.allPoliceCommand execute:nil];
    
    
    
}


#pragma mark - 设置dropDownMenu

/*
 判断是显示dropDownMenu还是收回dropDownMenu
 */

- (void)setupDropDownMenu:(XDSDropDownMenu *)dropDownMenu withTitleArray:(NSArray *)titleArray andButton:(UIButton *)button andDirection:(NSString *)direction{
    
    CGRect btnFrame = button.frame; //如果按钮在UIIiew上用这个
    
    //  CGRect btnFrame = [self getBtnFrame:button];//如果按钮在UITabelView上用这个
    
    
    if(dropDownMenu.tag == 1000){
        
        /*
         如果dropDownMenu的tag值为1000，表示dropDownMenu没有打开，则打开dropDownMenu
         */
        
        if (dropDownMenu == self.dropDownMenu_offline) {
            btnFrame.origin.x = btnFrame.origin.x - 125;
            [self.btn_selected_offline setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btn_selected_offline setBackgroundColor:UIColorFromRGB(0x247DF0)];
            
            [self.btn_selected_online setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [self.btn_selected_online setBackgroundColor:[UIColor whiteColor]];
        }else{
            [self.btn_selected_online setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.btn_selected_online setBackgroundColor:UIColorFromRGB(0x247DF0)];
            
            [self.btn_selected_offline setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [self.btn_selected_offline setBackgroundColor:[UIColor whiteColor]];
        }
        
        
        
        
        //初始化选择菜单
        [dropDownMenu showDropDownMenu:button withButtonFrame:btnFrame arrayOfTitle:titleArray arrayOfImage:nil animationDirection:direction];
        
        //添加到主视图上
        [self.view addSubview:dropDownMenu];
        
        //将dropDownMenu的tag值设为2000，表示已经打开了dropDownMenu
        dropDownMenu.tag = 2000;
        
    }else {
        

//        /*
//         如果dropDownMenu的tag值为2000，表示dropDownMenu已经打开，则隐藏dropDownMenu
//         */
//
//        [dropDownMenu hideDropDownMenuWithBtnFrame:btnFrame];
//        dropDownMenu.tag = 1000;
    }
}

#pragma mark - 隐藏其它DropDownMenu
/*
 在点击按钮的时候，隐藏其它打开的下拉菜单（dropDownMenu）
 */
- (void)hideOtherDropDownMenu:(XDSDropDownMenu *)dropDownMenu{
    
    
    if (dropDownMenu != self.dropDownMenu_online) {
        CGRect btnFrame = self.btn_selected_online.frame;//如果按钮在UIIiew上用这个
        
        
        [self.dropDownMenu_online hideDropDownMenuWithBtnFrame:btnFrame];
        self.dropDownMenu_online.tag = 1000;
    }
    
    if (dropDownMenu != self.dropDownMenu_offline) {
        CGRect btnFrame = self.btn_selected_offline.frame;//如果按钮在UIIiew上用这个
        btnFrame.origin.x = btnFrame.origin.x - 125;
        [self.dropDownMenu_offline hideDropDownMenuWithBtnFrame:btnFrame];
        self.dropDownMenu_offline.tag = 1000;
    }
    
}




#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"PoliceDistributeVC dealloc");
}

@end
