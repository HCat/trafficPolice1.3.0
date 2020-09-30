//
//  PersonLocationVC.m
//  移动采集
//
//  Created by hcat on 2017/10/31.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "PersonLocationVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <PureLayout.h>

#import "UITableView+Lr_Placeholder.h"
#import "PoliceLocationCell.h"

@interface PersonLocationVC ()<MAMapViewDelegate,AMapSearchDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapSearchAPI *geosearch;
@property (weak, nonatomic) IBOutlet UIImageView *img_certenLocation;

@property (nonatomic,strong) LocationStorageModel *model;

@property (nonatomic,strong) NSMutableArray *arr_content;

@end

@implementation PersonLocationVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"获取位置";
    self.arr_content = [NSMutableArray array];
    self.model = [[LocationStorageModel alloc] init];
    [self initMapView];
    
    @weakify(self);
    [self zx_setRightBtnWithImgName:@"nav_center" clickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
        @strongify(self);
        [self makeLocationInCenter];
    }];
    
    _tableView.isNeedPlaceholderView = YES;
    _tableView.str_placeholder = @"暂无搜索内容";
    _tableView.firstReload = YES;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark -

- (void)initMapView{
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
//    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];

    [_mapView configureForAutoLayout];
    [_mapView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(Height_NavBar, 0, 0, 0) excludingEdge:ALEdgeBottom];
    [_mapView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_tableView];
    
    [_img_certenLocation autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.view bringSubviewToFront:_img_certenLocation];
    [_img_certenLocation autoConstrainAttribute:(ALAttribute)ALAxisHorizontal toAttribute:(ALAttribute)ALAxisHorizontal ofView:_mapView withOffset:-18];
    
    
    _mapView.showsUserLocation = YES;
    _mapView.distanceFilter = 10;
    _mapView.showsCompass= NO;
    _mapView.showsScale= NO;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView setZoomLevel:16.1 animated:YES];
}

#pragma mark - buttonAction

#pragma mark - 让地图的中心点为定位坐标按钮

- (void)makeLocationInCenter{
    
    [_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];
    
    
}


#pragma mark - 请求周边

- (void)requestAroundPoi{
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location            = [AMapGeoPoint locationWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
    request.keywords            = @"路";
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.types               = @"道路名";
    request.requireExtension    = YES;
    
    [self.search AMapPOIAroundSearch:request];
    
}

/**
 *  逆向地理编码
 *
 *  @param latitude  逆向地理编码搜索需要的latitude
 *  @param longitude 逆向地理编码搜索需要的longitude
 */
- (void)setGeosearchWithLatitude:(float)latitude longitude:(float)longitude{
   
    //初始化检索对象
    self.geosearch = [[AMapSearchAPI alloc] init];
    self.geosearch.delegate = self;
    
    //构造AMapWeatherSearchRequest对象，配置查询参数
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    //发起行政区划查询
    [self.geosearch AMapReGoecodeSearch:request];
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        dispatch_queue_t queue = dispatch_queue_create("net.gcd.testQueue", DISPATCH_QUEUE_CONCURRENT);
        //任务1
        dispatch_async(queue, ^{
            [self requestAroundPoi];
        
        });
        
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
//        [UIView animateWithDuration:0.1 animations:^{
//
//            double degree = userLocation.heading.trueHeading;
//            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
//
//        }];
    }
}


- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    
    [self requestAroundPoi];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_content.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellIdentifier = @"PoliceLocationCellID";
    PoliceLocationCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        [_tableView registerNib:[UINib nibWithNibName:@"PoliceLocationCell" bundle:nil] forCellReuseIdentifier:@"PoliceLocationCellID"];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }

    
    if (indexPath.row == 0) {
        [cell.imgV_location setImage:[UIImage imageNamed:@"icon_policeLocation_blue"]];
        cell.lb_name.textColor = UIColorFromRGB(0x4281e8);
    }else{
        [cell.imgV_location setImage:[UIImage imageNamed:@"icon_policeLocation"]];
        cell.lb_name.textColor = UIColorFromRGB(0x444444);
    }
    
    AMapPOI *poi = _arr_content[indexPath.row];
    
    cell.poi = poi;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AMapPOI *poi = _arr_content[indexPath.row];
    LxDBObjectAsJson(poi);
    
    self.model.latitude = @(self.mapView.centerCoordinate.latitude);
    self.model.longitude = @(self.mapView.centerCoordinate.longitude);
    self.model.streetName = poi.name;
    
    [self setGeosearchWithLatitude:poi.location.latitude longitude:poi.location.longitude];

}

#pragma mark - AMapSearchDelegate

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    self.arr_content = [NSMutableArray array];
    [self.tableView reloadData];
    [LRShowHUD showError:@"搜索请求失败" duration:1.5f];
    
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    
    self.arr_content = [response.pois mutableCopy];
    [self.tableView reloadData];
    
}


/**
 *  逆向地理编码回调方法
 *
 *  @param request  request 搜索请求
 *  @param response response 搜索返回
 */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    if (response.regeocode != nil) {
        AMapReGeocode *regeocode = response.regeocode;
        LxDBObjectAsJson(regeocode);
        AMapAddressComponent *addressComponent = regeocode.addressComponent;
        LxDBObjectAsJson(addressComponent);
        LxDBObjectAsJson(addressComponent.streetNumber);
        self.model.address = regeocode.formattedAddress;
        
        if (self.block) {
            self.block(self.model);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    }
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"PersonLocationVC dealloc");
    
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
