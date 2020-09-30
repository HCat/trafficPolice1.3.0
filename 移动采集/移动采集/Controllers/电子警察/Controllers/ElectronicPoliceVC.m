//
//  ElectronicPoliceVC.m
//  移动采集
//
//  Created by hcat-89 on 2020/4/23.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ElectronicPoliceVC.h"
#import <PureLayout.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "UIButton+NoRepeatClick.h"


#import "ElectronicPoliceAPI.h"
#import "PFNavigationDropdownMenu.h"
#import "ElectronicPoliceViewModel.h"

#import "ElectronicAnnotation.h"
#import "ElectronicAnnotationView.h"
#import "ElectronicImageVC.h"

@interface ElectronicPoliceVC ()<MAMapViewDelegate>

@property (strong,nonatomic) PFNavigationDropdownMenu * menuView;
@property (nonatomic, strong) MAMapView * mapView;

//@property (strong, nonatomic) UIButton *rightButton;
@property(nonatomic,strong) ElectronicPoliceViewModel * viewModel;



@end

@implementation ElectronicPoliceVC

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.viewModel = [[ElectronicPoliceViewModel alloc] init];
    
    }
    
    return self;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel];
    
    [self.viewModel.command_group execute:nil];
    
}

- (void)configUI{
    
    self.title = @"电子警察位置";

    @weakify(self);
    
//    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 25)];
//    self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 35, 0, -35);
//    self.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -95, 0, 0);
//    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
//    [self.rightButton setTitle:@"卫星" forState:UIControlStateNormal];
//    self.rightButton.isIgnore = YES;
//
//    [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        @strongify(self);
//        self.viewModel.isSate = !self.viewModel.isSate;
//    }];
//    UIBarButtonItem * rightitem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
//    self.navigationItem.rightBarButtonItem = rightitem;
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    [self.view sendSubviewToBack:_mapView];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(Height_NavBar));
        make.right.equalTo(@0);
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    _mapView.distanceFilter = 10.f;
    _mapView.showsCompass= NO;
    _mapView.showsScale= NO;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    
}


- (void)bindViewModel{
    
    @weakify(self);

    [RACObserve(self.viewModel, isSate) subscribeNext:^(NSNumber * _Nullable x) {
        
        @strongify(self);
        
        if ([x boolValue]) {
            
            //self.zx_navTintColor = nil;
            self.zx_navRightBtn.isTintColor = YES;
            [self.zx_navRightBtn setImage:[UIImage imageNamed:@"btn_dailyPatrol_on"] forState:UIControlStateNormal];
            [self.zx_navRightBtn setTitle:@"卫星" forState:UIControlStateNormal];
            [self zx_rightClickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
                @strongify(self);
                self.viewModel.isSate = !self.viewModel.isSate;
            
            }];
            
            //[self.rightButton setImage:[UIImage imageNamed:@"btn_dailyPatrol_on"] forState:UIControlStateNormal];
            [self.mapView setMapType:MAMapTypeSatellite];
                       
        }else{
            //self.zx_navTintColor = nil;
            self.zx_navRightBtn.isTintColor = YES;
            [self.zx_navRightBtn setImage:[UIImage imageNamed:@"btn_dailyPatrol_off"] forState:UIControlStateNormal];
            [self.zx_navRightBtn setTitle:@"卫星" forState:UIControlStateNormal];
            [self zx_rightClickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
                @strongify(self);
                self.viewModel.isSate = !self.viewModel.isSate;
            
            }];
                       
            //[self.rightButton setImage:[UIImage imageNamed:@"btn_dailyPatrol_off"] forState:UIControlStateNormal];
            [self.mapView setMapType:MAMapTypeStandard];
        }
        
    }];
    
    [self.viewModel.command_group.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        if([x isEqualToString:@"加载成功"]){
            
            if (self.viewModel.arr_group.count > 0) {
                [self setUpDropdownMenu:self.viewModel.arr_group];
                [self.viewModel.command_detail execute:nil];
            }
        }
        
    }];
    
    [self.viewModel.command_detail.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        
        @strongify(self);
        
        if([x isEqualToString:@"加载成功"]){
            
            if (self.viewModel.arr_point.count > 0) {
                [self.mapView removeAnnotations:self.viewModel.arr_point];
                [self.viewModel.arr_point removeAllObjects];
            }
            
            for (int i = 0; i < self.viewModel.arr_detail.count; i++) {
            
                ElectronicDetailModel * model = self.viewModel.arr_detail[i];
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.lat doubleValue], [model.lng doubleValue]);
                ElectronicAnnotation * annotation = [[ElectronicAnnotation alloc] init];
                annotation.coordinate = coordinate;
                annotation.title    = [NSString stringWithFormat:@"摄像头%d",i];
                annotation.model = model;
                [self.viewModel.arr_point addObject:annotation];
                
            }
            
            if (self.viewModel.arr_point.count > 0) {
                
                [self.mapView addAnnotations:self.viewModel.arr_point];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    @strongify(self);
                    [self showsAnnotations:self.viewModel.arr_point edgePadding:UIEdgeInsetsMake(50, 50, 50, 50) andMapView:self.mapView];
                    
                });
                
                
            }
            
            
            
        }
        
    }];
    
    
}

#pragma mark - set

- (void)setUpDropdownMenu:(NSArray *)items{
    
    @weakify(self);
    
    NSMutableArray *items_t = [NSMutableArray array];
    
    for (int i = 0; i < items.count; i++) {
        ElectronicTypeModel * model = items[i];
        [items_t addObject:model.typeName];
    }
    
    if (_menuView) {
        [_menuView removeFromSuperview];
        _menuView = nil;
    }

    _menuView = [[PFNavigationDropdownMenu alloc] initWithFrame:CGRectMake(0, Height_NavBar, SCREEN_WIDTH, 44)
                                                          title:items_t.firstObject
                                                          items:items_t
                                                  containerView:self.view];
    _menuView.backgroundColor = [UIColor whiteColor];
    
    _menuView.cellHeight = 50;
    _menuView.cellBackgroundColor = [UIColor whiteColor];
    _menuView.cellSelectionColor = [UIColor whiteColor];
    _menuView.cellTextLabelColor = DefaultTextColor;
    _menuView.cellTextLabelFont = [UIFont systemFontOfSize:14.f];
    _menuView.arrowImage = [UIImage imageNamed:@"icon_dropdown_down"];
    _menuView.checkMarkImage = [UIImage imageNamed:@"icon_dropdown_selected"];
    _menuView.arrowPadding = 15;
    _menuView.animationDuration = 0.5f;
    _menuView.maskBackgroundColor = [UIColor blackColor];
    _menuView.maskBackgroundOpacity = 0.3f;
    
    _menuView.didSelectItemAtIndexHandler = ^(NSUInteger indexPath){
        NSLog(@"Did select item at index: %ld", indexPath);
        @strongify(self);
        
        ElectronicTypeModel * model = self.viewModel.arr_group[indexPath];
        [self.viewModel.command_detail execute:model.typeId];
    };
    
    [self.view addSubview:_menuView];
    [_menuView configureForAutoLayout];
    [_menuView autoSetDimension:ALDimensionHeight toSize:44];
    
    [_menuView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:Height_NavBar];
    
    [_menuView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
    [_menuView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:0];
    
    [self.mapView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@44);
    }];
    [self.view layoutIfNeeded];
    
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[ElectronicAnnotation class]]){
        
        ElectronicAnnotation *vehicle = (ElectronicAnnotation *)annotation;
        
        static NSString *customReuseIndetifier = @"ElectronicAnnotationID";
        ElectronicAnnotationView *vehicleCarView = (ElectronicAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        @weakify(self);
        if (vehicleCarView == nil)
        {
            vehicleCarView = [[ElectronicAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            vehicleCarView.block = ^(ElectronicAnnotation *carAnnotation) {
                @strongify(self);
                LxDBAnyVar(carAnnotation);
                
                ElectronicImageViewModel * viewModel = [[ElectronicImageViewModel alloc] init];
                viewModel.cameraId = carAnnotation.model.electronicId;
                ElectronicImageVC * vc = [[ElectronicImageVC alloc] initWithViewModel:viewModel];
                [self.navigationController pushViewController:vc animated:YES];
            
            };
        }
        
        //很重要的，配置关联的模型数据
        vehicleCarView.annotation = vehicle;
        
        
        return vehicleCarView;
        
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


#pragma mark - dealloc

- (void)dealloc{
    LxPrintf(@"%@-dealloc",[self class]);
}

@end
