//
//  PoliceCommandVC.m
//  移动采集
//
//  Created by hcat on 2017/9/11.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "PoliceCommandVC.h"
#import "NSTimer+UnRetain.h"
#import "UINavigationBar+BarItem.h"
#import <MAMapKit/MAMapKit.h>
#import <PureLayout.h>

#import "VehicleAPI.h"
#import "LocationAPI.h"
#import "CommonAPI.h"
#import "IdentifyAPI.h"
#import "VehicleCarAnnotation.h"
#import "PoliceAnnotation.h"

#import "BottomView.h"
#import "BottomPickerView.h"

#import "OnePoliceView.h"
#import "GroupPoliceView.h"
#import "BoradPoliceView.h"
#import "PoliceDetailView.h"
#import "PoliceCarDetailView.h"

#import "PoliceLocationVC.h"



typedef NS_ENUM(NSUInteger, PoliceType) {
    PoliceTypeOnePolice,
    PoliceTypeGroupPolice,
    PoliceTypeLocationPolice,
    PoliceTypeUnknow,
};

@interface PoliceCommandVC ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
@property (nonatomic, strong) MAPointAnnotation *positionAnnotation; //定位的坐标点
@property (nonatomic, strong) MACircle *positionCircle;              //定位画的圆

@property (nonatomic, strong) NSTimer * loadRequestTime;            //请求时间
@property (nonatomic, strong) NSMutableArray *arr_policeCar;        //用来存储警车请求数据
@property (nonatomic, strong) NSMutableArray *arr_policeCarPoint;   //用来存储警车点数据
@property (nonatomic, strong) NSMutableArray *arr_police;           //用来存储警员请求数据
@property (nonatomic, strong) NSMutableArray *arr_policePoint;      //用来存储警员点数据


@property (weak, nonatomic) IBOutlet UIButton *btn_onePolice;       //单个警察按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_groupPolice;     //群组警察按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_locationPolice;  //定位警察按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_pushPolice;      //广播警察按钮

@property (nonatomic,strong) OnePoliceView * onePoliceView;         //单个警察弹出框
@property (nonatomic,strong) GroupPoliceView * groupPoliceView;     //警察小组弹出框
@property (nonatomic,strong) BoradPoliceView *boradPoliceView;      //广播弹出框
@property (nonatomic,strong) PoliceDetailView *policeDetailView;    //警员详情
@property (nonatomic,strong) PoliceCarDetailView *policeCarDetailView; //警车详情


@property (nonatomic,strong) NSArray <CommonGetGroupListModel *> * arr_groupList;
@property (nonatomic,strong) NSMutableArray * arr_policeIds;

@property (nonatomic,assign)PoliceType policeType;

@property (nonatomic,strong) NSNumber * latitude;
@property (nonatomic,strong) NSNumber * longitude;
@property (nonatomic,strong) NSNumber * range;

@end

@implementation PoliceCommandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"勤务指挥";
    self.arr_policeCarPoint = [NSMutableArray array];
    self.arr_policePoint = [NSMutableArray array];
    self.arr_policeIds = [NSMutableArray array];

    [self showRightBarButtonItemWithImage:@"nav_center" target:self action:@selector(makeLocationInCenter)];
    
    [self initMapView];
    
    self.policeType = PoliceTypeUnknow;
    
    WS(weakSelf);
    self.loadRequestTime = [NSTimer lr_scheduledTimerWithTimeInterval:10 repeats:YES block:^(NSTimer *timer) {
        
        SW(strongSelf, weakSelf);
        [strongSelf resetPoliceType:strongSelf.policeType];
        [strongSelf loadPoliceCarData];
        [strongSelf loadPoliceData];
        
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.loadRequestTime forMode:NSRunLoopCommonModes];
    
    
}

#pragma mark - set && get 

- (void)resetPoliceType:(PoliceType)policeType{

    self.policeType = policeType;

}

- (void)setPoliceType:(PoliceType)policeType{

    _policeType = policeType;
    
    switch (_policeType) {
        case PoliceTypeUnknow:{
            
            [self celearPositionRange];
            
            _latitude = @(_mapView.centerCoordinate.latitude);
            _longitude = @(_mapView.centerCoordinate.longitude);
            _range = @5;
            
            _btn_onePolice.selected = NO;
            _btn_groupPolice.selected = NO;
            _btn_locationPolice.selected = NO;
            _btn_pushPolice.enabled = NO;
            
        }break;
        case PoliceTypeOnePolice:{
            
            [self celearPositionRange];
            
            _latitude = @(_mapView.centerCoordinate.latitude);
            _longitude = @(_mapView.centerCoordinate.longitude);
            _range = @5;
            
            _btn_onePolice.selected = YES;
            _btn_groupPolice.selected = NO;
            _btn_locationPolice.selected = NO;
            _btn_pushPolice.enabled = NO;
            
        }break;
        case PoliceTypeGroupPolice:{
            
             [self celearPositionRange];
            
            _latitude = @(_mapView.centerCoordinate.latitude);
            _longitude = @(_mapView.centerCoordinate.longitude);
            _range = @5;
            
            _btn_onePolice.selected = NO;
            _btn_groupPolice.selected = YES;
            _btn_locationPolice.selected = NO;
            _btn_pushPolice.enabled = NO;

            
        }break;
        case PoliceTypeLocationPolice:{
            
            //选中时候的位置和范围在PoliceLocation的委托中已经确定不需要重新赋值
        
            [self drawPositionRange];
            _btn_onePolice.selected = NO;
            _btn_groupPolice.selected = NO;
            _btn_locationPolice.selected = YES;
            _btn_pushPolice.enabled = YES;
            
            
        }break;
            
        default:
            break;
    }
    
    
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
    manger.lat = _latitude;
    manger.lng = _longitude;
    manger.range = _range;
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
    manger.lat = _latitude;
    manger.lng = _longitude;
    manger.range = _range;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            if (strongSelf.arr_policePoint && strongSelf.arr_policePoint.count > 0) {
                [strongSelf.mapView removeAnnotations:strongSelf.arr_policePoint];
                [strongSelf.arr_policePoint removeAllObjects];
            }
            
            strongSelf.arr_police = [manger.userGpsList mutableCopy];
            
            if (strongSelf.policeType == PoliceTypeLocationPolice) {
                
                if (strongSelf.arr_policeIds && strongSelf.arr_policeIds.count > 0) {
                    [strongSelf.arr_policeIds removeAllObjects];
                }
                
                if (strongSelf.arr_police && strongSelf.arr_police.count > 0) {
                    for (UserGpsListModel *t_model in strongSelf.arr_police) {
                        [strongSelf.arr_policeIds addObject:t_model.userId];
                    }
                }
            }
            
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
        
        switch (_policeType) {
            case PoliceTypeUnknow:{
                policeView.image = [UIImage imageNamed:@"map_police"];
            }break;
            case PoliceTypeOnePolice:{
                PoliceAnnotation * t_policeAnnotation = (PoliceAnnotation *)annotation;
                LxDBAnyVar(t_policeAnnotation);
                if ([t_policeAnnotation.userModel.userName isEqualToString:_onePoliceView.name]) {
                    policeView.image = [UIImage imageNamed:@"map_police_selected"];
                }else{
                    policeView.image = [UIImage imageNamed:@"map_police"];
                }
            
            }break;
            case PoliceTypeGroupPolice:{
                PoliceAnnotation * t_policeAnnotation = (PoliceAnnotation *)annotation;
                LxDBAnyVar(t_policeAnnotation);
               
                BOOL isGroupNumber = [t_policeAnnotation.userModel.groupIds containsObject:[_groupPoliceView.groupId stringValue]];
                
                if (isGroupNumber) {
                    policeView.image = [UIImage imageNamed:@"map_police_selected"];
                }else{
                    policeView.image = [UIImage imageNamed:@"map_police"];
                }
                
            }break;
            case PoliceTypeLocationPolice:{
                policeView.image = [UIImage imageNamed:@"map_police"];
            }break;
            default:
                break;
        }
        
    
        return policeView;
    
    }else if ([annotation isKindOfClass:[MAPointAnnotation class]]){
        static NSString *customReuseIndetifier = @"positionAnnotationID";
        MAAnnotationView *positionView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (positionView == nil)
        {
            positionView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            
        }
        
        positionView.image = [UIImage imageNamed:@"map_chosePosition"];

        
        return positionView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    /* Adjust the map center in order to show the callout view completely. */
    if ([view isKindOfClass:[MAAnnotationView class]]) {
        
        if ([view.annotation isKindOfClass:[PoliceAnnotation class]]){
            
            PoliceAnnotation *policeAnnotation = (PoliceAnnotation *)view.annotation;
            LxDBAnyVar(policeAnnotation);
            
            if (_policeDetailView == nil) {
                self.policeDetailView = [PoliceDetailView initCustomView];
                [_policeDetailView configureForAutoLayout];
                
            }
            
            [self.view addSubview:_policeDetailView];
            [_policeDetailView autoPinEdgesToSuperviewEdges];
            
            _policeDetailView.policeName = policeAnnotation.userModel.userName;
            
            NSString *groupString = [policeAnnotation.userModel.groupNames componentsJoinedByString:@","];
            _policeDetailView.policeGroup = groupString;
            
        }
        
        if ([view.annotation isKindOfClass:[VehicleCarAnnotation class]])
        {
            
            VehicleCarAnnotation *policeCarAnnotation = (VehicleCarAnnotation *)view.annotation;
            LxDBAnyVar(policeCarAnnotation);
            
            if (_policeCarDetailView == nil) {
                self.policeCarDetailView = [PoliceCarDetailView initCustomView];
                [_policeCarDetailView configureForAutoLayout];
                
            }
            
            [self.view addSubview:_policeCarDetailView];
            [_policeCarDetailView autoPinEdgesToSuperviewEdges];
            
            _policeCarDetailView.policeCarName = policeCarAnnotation.vehicleCar.plateNo;
            

        }
        
    }
}


- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        
        LxPrintf(@"*************** 添加定位图标 ******************");
        [self resetPoliceType:_policeType];
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

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth   = 1.f;
        circleRenderer.strokeColor = [UIColor clearColor];
        circleRenderer.fillColor   = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        return circleRenderer;
    }
    
    return nil;
}


#pragma mark - 单个警察点击按钮
- (IBAction)handleBtnOnePoliceClicked:(id)sender {
    
    if (_onePoliceView == nil) {
        self.onePoliceView = [OnePoliceView initCustomView];
        [self.onePoliceView configureForAutoLayout];
        WS(weakSelf);
        
        self.onePoliceView.block = ^(NSString *name) {
            
            SW(strongSelf, weakSelf);
            
            strongSelf.policeType = PoliceTypeOnePolice;
            [strongSelf reloadPoint];

        };
    }

    [self.view addSubview:self.onePoliceView];
    [self.onePoliceView autoPinEdgesToSuperviewEdges];


    
}

#pragma mark - 群组警察点击按钮
- (IBAction)handleBtnGroupPoliceClicked:(id)sender {

    WS(weakSelf);
    if (_arr_groupList == nil) {
        
        CommonGetGroupListManger *t_manger = [[CommonGetGroupListManger alloc] init];
        [t_manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            SW(strongSelf, weakSelf);
            strongSelf.arr_groupList = t_manger.commonGetGroupListResponse;
            
            if (strongSelf.groupPoliceView == nil) {
                
                strongSelf.groupPoliceView = [GroupPoliceView initCustomView];
                [strongSelf.groupPoliceView configureForAutoLayout];
            }
            
            
            
            strongSelf.groupPoliceView.selectedBlock = ^(GroupPoliceView *view) {
                
                SW(strongSelf, weakSelf);
                
                BottomPickerView *t_view = [BottomPickerView initCustomView];
                [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 207)];
                t_view.pickerTitle = @"警队小组";
                t_view.items = strongSelf.arr_groupList;
                t_view.selectedBtnBlock = ^(NSArray *items, NSInteger index) {
                    CommonGetGroupListModel * groupListModel = items[index];
                    view.tf_groupName.text = groupListModel.getGroupName;
                    view.groupName = groupListModel.getGroupName;
                    view.groupId = groupListModel.getGroupId;
                    [BottomView dismissWindow];
                };
                
                [BottomView showWindowWithBottomView:t_view];
                
                
            };
            
            strongSelf.groupPoliceView.makeSureBlock = ^(NSString *groupName, NSNumber *groupId) {
                
                SW(strongSelf, weakSelf);
                strongSelf.policeType = PoliceTypeGroupPolice;
                [strongSelf reloadPoint];
                
            };
            
            [strongSelf.view addSubview:strongSelf.groupPoliceView];
            [strongSelf.groupPoliceView autoPinEdgesToSuperviewEdges];
            
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
        
        
    }else{
        
        if (_groupPoliceView == nil) {
            
            self.groupPoliceView = [GroupPoliceView initCustomView];
            [_groupPoliceView configureForAutoLayout];
        }
        
        _groupPoliceView.selectedBlock = ^(GroupPoliceView *view) {
            
            SW(strongSelf, weakSelf);
            
            BottomPickerView *t_view = [BottomPickerView initCustomView];
            [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 207)];
            t_view.pickerTitle = @"警队小组";
            t_view.items = strongSelf.arr_groupList;
            t_view.selectedBtnBlock = ^(NSArray *items, NSInteger index) {
                CommonGetGroupListModel * groupListModel = items[index];
                view.tf_groupName.text = groupListModel.getGroupName;
                view.groupName = groupListModel.getGroupName;
                view.groupId = groupListModel.getGroupId;
                [BottomView dismissWindow];
            };
            
            [BottomView showWindowWithBottomView:t_view];
            
            
        };
        
        _groupPoliceView.makeSureBlock = ^(NSString *groupName, NSNumber *groupId) {
            
            SW(strongSelf, weakSelf);
            strongSelf.policeType = PoliceTypeGroupPolice;
            [strongSelf reloadPoint];
            
        };
        
        [self.view addSubview:_groupPoliceView];
        [_groupPoliceView autoPinEdgesToSuperviewEdges];
        
    }

}


#pragma mark - 定位警察点击按钮
- (IBAction)handleBtnLocationPoliceClicked:(id)sender {
    
    PoliceLocationVC *t_vc = [[PoliceLocationVC alloc] init];
    WS(weakSelf);
    t_vc.block = ^(NSNumber *lat, NSNumber *lon, NSNumber *range) {
        SW(strongSelf, weakSelf);
        strongSelf.latitude = lat;
        strongSelf.longitude = lon;
        strongSelf.range = range;
        strongSelf.policeType = PoliceTypeLocationPolice;
        [strongSelf loadPoliceData];
        [strongSelf loadPoliceCarData];
    
    };
    
    [self.navigationController pushViewController:t_vc animated:YES];
    
}


#pragma mark - 广播警察点击按钮
- (IBAction)handleBtnPushPoliceClicked:(id)sender {
    
    if (_boradPoliceView == nil) {
        self.boradPoliceView = [BoradPoliceView initCustomView];
        [_boradPoliceView configureForAutoLayout];
        WS(weakSelf);
        _boradPoliceView.block = ^(NSString *content) {
            
            SW(strongSelf, weakSelf);
            if (!strongSelf.arr_policeIds || strongSelf.arr_policeIds.count == 0) {
                [LRShowHUD showError:@"当前无人员可以通知" duration:1.5];
                [strongSelf.boradPoliceView dismiss];
                return ;
            }
            
            IdentifyNoticeParam *param = [[IdentifyNoticeParam alloc] init];
            param.message = content;
            param.msgType = @"1";
            param.idArr = [strongSelf.arr_policeIds  componentsJoinedByString:@","];
            IdentifyNoticeManger *manger = [[IdentifyNoticeManger alloc] init];
            manger.param = param;
            [manger configLoadingTitle:@"发送"];
            [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                
                if (manger.responseModel.code == CODE_SUCCESS) {
                    [strongSelf.boradPoliceView dismiss];
                }
                
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                
            }];
            
        };
        
    }
    
    [self.view addSubview:_boradPoliceView];
    [_boradPoliceView autoPinEdgesToSuperviewEdges];
    _boradPoliceView.tv_content.text = nil;
    
}

#pragma mark - 让地图的中心点为定位坐标按钮

- (void)makeLocationInCenter{
    
    [_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];


}

#pragma mark  - 重新刷新坐标点

- (void)reloadPoint{

    if (_arr_policePoint && _arr_policePoint.count > 0) {
        [_mapView removeAnnotations:_arr_policePoint];
        [_arr_policePoint removeAllObjects];
    }
    
    for (UserGpsListModel *model in _arr_police) {
        PoliceAnnotation *annotation = [[PoliceAnnotation alloc] init];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
        annotation.coordinate = coordinate;
        annotation.title    = model.userId;
        annotation.subtitle = model.userName;
        annotation.userModel = model;
        
        [_arr_policePoint addObject:annotation];
    }
    
    if (_arr_policePoint && _arr_policePoint.count > 0) {
        [_mapView addAnnotations:_arr_policePoint];
    }


}

#pragma mark - 画定位的圆形还有坐标

- (void) drawPositionRange{
    
    if (self.positionAnnotation) {
        [_mapView removeAnnotation:self.positionAnnotation];
        self.positionAnnotation = nil;
    }

    self.positionAnnotation = [[MAPointAnnotation alloc] init];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue]);
    _positionAnnotation.coordinate = coordinate;
    _positionAnnotation.title    = @"定位的点";
    _positionAnnotation.subtitle = @"定位的点";
    
    [_mapView addAnnotation:_positionAnnotation];
    
    if (self.positionCircle) {
        [_mapView removeOverlay:self.positionCircle];
        self.positionCircle = nil;
    }
    
    self.positionCircle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue]) radius:[_range intValue] * 1000];
    [self.mapView addOverlay:_positionCircle];
    
}

- (void)celearPositionRange{
    
    if (self.positionAnnotation) {
        [_mapView removeAnnotation:self.positionAnnotation];
        self.positionAnnotation = nil;
    }
    
    if (self.positionCircle) {
        [_mapView removeOverlay:self.positionCircle];
        self.positionCircle = nil;
    }
    
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
