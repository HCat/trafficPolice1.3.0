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
#import <PureLayout.h>
#import "NSArray+PureLayoutMore.h"
#import "DutyAPI.h"
#import "AlertView.h"

@interface UserTaskDetailVC ()<MAMapViewDelegate>

@property (nonatomic,strong) NSMutableArray *arr_taskList;
@property (nonatomic,strong) NSMutableArray *arr_view;
@property (weak, nonatomic) IBOutlet UILabel *lb_taskTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *v_detail;


@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;


@end

@implementation UserTaskDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行动详情";
    self.arr_view  = [NSMutableArray array];;
    [self showRightBarButtonItemWithImage:@"nav_center" target:self action:@selector(makeLocationInCenter)];
//    _v_detail.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
//    _v_detail.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
//    _v_detail.layer.shadowOpacity = 0.5;//不透明度
//    _v_detail.layer.shadowRadius = 10.0;//半径
    
    [self initMapView];
    [self setActionModel:_model];
    
    _scrollView.contentSize =  CGSizeMake(0, SCREEN_WIDTH - 2*16);
}
#pragma mark - init

- (void)initMapView{
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    [self.view sendSubviewToBack:_mapView];
    [_mapView configureForAutoLayout];
    
    [_mapView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
    [_mapView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_scrollView];
    
    
    
    _mapView.showsUserLocation = YES;
    _mapView.distanceFilter = 200;
    _mapView.showsCompass= NO;
    _mapView.showsScale= NO;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView setZoomLevel:14.1 animated:YES];
    
}

#pragma mark - set && get

- (void)setActionModel:(ActionTaskListModel *)model{

    _model = model;
    
    if (_model) {

        if (_model.latitude && _model.longitude) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_model.latitude doubleValue], [_model.longitude doubleValue]);
            
            MAPointAnnotation *annotation_task = [[MAPointAnnotation alloc] init];
            annotation_task.coordinate = coordinate;
            [_mapView addAnnotation:annotation_task];
            
            [_mapView setCenterCoordinate:coordinate animated:YES];
        }
        
        _lb_taskTitle.text = [ShareFun takeStringNoNull:_model.taskTitle];
        
        _arr_taskList = [NSMutableArray arrayWithArray:_model.taskShowList];
        
        if (_arr_view && _arr_view.count > 0) {
            
            for (UIView *t_view in _arr_view) {
                [t_view removeFromSuperview];
            }
            
            [_arr_view removeAllObjects];
        }
        
        
        if (_arr_taskList && _arr_taskList.count > 0) {
            
            for (int i = 0; i < _arr_taskList.count; i++) {
                ActionShowListModel *model = _arr_taskList[i];
                
                if ([model.type isEqualToNumber:@0]) {
                    [self buildTitle:model.name withType:model.type withContent:model.content];
                }else if([model.type isEqualToNumber:@1]){
                    [self buildTitle:model.name withType:model.type withContent:model.content];
                }else if([model.type isEqualToNumber:@2]){
                    [self buildTitle:model.name withArr:model.peopleArr withRow:i];
                }
                
            }
            
            if (_arr_view && _arr_view.count > 0) {
                UIView *t_view = _arr_view.lastObject;
                [t_view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.v_detail withOffset:-10.f];
            }
            
            
        }else{
            
            [_lb_taskTitle autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.v_detail withOffset:-10.f];
        }
        
        [self.scrollView setNeedsLayout];
        [self.scrollView layoutIfNeeded];
        
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


- (void) buildTitle:(NSString *)title withType:(NSNumber *)type withContent:(NSString *)content{
    
    UIView * t_top = nil;
    
    if (_arr_view && _arr_view.count > 0) {
        t_top = _arr_view.lastObject;
    }else{
        t_top = _lb_taskTitle;
    }
    
    UIView *t_view = [UIView newAutoLayoutView];
    [t_view setBackgroundColor:[UIColor whiteColor]];
    [self.v_detail addSubview:t_view];
    
    
    UILabel *lb_title = [UILabel newAutoLayoutView];
    lb_title.font = [UIFont systemFontOfSize:13];
    lb_title.textColor = UIColorFromRGB(0x999999);
    NSString *t_title = [NSString stringWithFormat:@"%@:",title];
    lb_title.text = t_title;
    [t_view addSubview:lb_title];
    [lb_title setContentCompressionResistancePriority:752 forAxis:UILayoutConstraintAxisHorizontal];
    [lb_title autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [lb_title autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    
    UILabel *lb_content = [UILabel newAutoLayoutView];
    lb_content.font = [UIFont systemFontOfSize:13];
    lb_content.textColor = UIColorFromRGB(0x666666);
    lb_content.numberOfLines = 0;
    
    if ([type isEqualToNumber:@1]) {
        NSNumber *time = @([content floatValue]);
        lb_content.text = [ShareFun timeWithTimeInterval:time];
    }else{
        lb_content.text = [ShareFun takeStringNoNull:content];;
    }
    
    [t_view addSubview:lb_content];
    
    [lb_content autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [lb_content autoPinEdge:ALEdgeLeft  toEdge:ALEdgeRight ofView:lb_title withOffset:9.f];
    [lb_content autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    
    
    [t_view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:t_top withOffset:12.f];
    [t_view autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:t_top];
    [t_view autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:t_top];
    [t_view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:lb_content];
    
    
    [self.arr_view addObject:t_view];
    
}

- (void)buildTitle:(NSString *)title withArr:(NSArray *)peopleList withRow:(NSInteger)row{
    
    UIView * t_top = nil;
    
    if (_arr_view && _arr_view.count > 0) {
        t_top = _arr_view.lastObject;
    }else{
        t_top = _lb_taskTitle;
    }
    
    UIView *t_view = [UIView newAutoLayoutView];
    [t_view setBackgroundColor:[UIColor whiteColor]];
    [self.v_detail addSubview:t_view];
    
    
    UILabel *lb_title = [UILabel newAutoLayoutView];
    lb_title.font = [UIFont systemFontOfSize:13];
    lb_title.textColor = UIColorFromRGB(0x999999);
    NSString *t_title = [NSString stringWithFormat:@"%@:",title];
    lb_title.text = t_title;
    [t_view addSubview:lb_title];
    [lb_title setContentCompressionResistancePriority:752 forAxis:UILayoutConstraintAxisHorizontal];
    [lb_title autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [lb_title autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    
    if (!peopleList || peopleList.count == 0) {
        
        [t_view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:t_top withOffset:12.f];
        [t_view autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:t_top];
        [t_view autoPinEdge:ALEdgeTrailing  toEdge:ALEdgeTrailing ofView:self.scrollView withOffset:-20.f];
        [t_view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:lb_title];
        
        [self.arr_view addObject:t_view];
        
        return;
        
    }
    
    UIView *btn_View = [UIView newAutoLayoutView];
    [t_view addSubview:btn_View];
    [btn_View setBackgroundColor:[UIColor whiteColor]];
    [btn_View autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [btn_View autoPinEdge:ALEdgeLeft  toEdge:ALEdgeRight ofView:lb_title withOffset:9.f];
    [btn_View autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    
    NSMutableArray *arr_all = [NSMutableArray new];
    NSMutableArray *arr_v = [NSMutableArray new];
    
    for (int i = 0;i < [peopleList count]; i++) {
        ActionPeopleModel *t_model = peopleList[i];
        UIButton *t_button = [UIButton newAutoLayoutView];
        [t_button setTitle:t_model.userName forState:UIControlStateNormal];
        t_button.titleLabel.font = [UIFont systemFontOfSize:15];
        [t_button setTitleColor:DefaultColor forState:UIControlStateNormal];
        [t_button setBackgroundColor:[UIColor whiteColor]];
        t_button.layer.borderColor = DefaultColor.CGColor;
        t_button.layer.borderWidth = 1.f;
        t_button.layer.masksToBounds = YES;
        t_button.tag = row * 1000 + i;
        
        [t_button addTarget:self action:@selector(btnTagAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn_View addSubview:t_button];
        [arr_all addObject:t_button];
        
        if ( i % 3 == 0) {
            
            if (arr_v && [arr_v count] > 0) {
                [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:3.0 withFixedLeading: 0 withFixedTrailing:0 matchedSizes:YES];
                [arr_v removeAllObjects];
            }
            
            if ( i ==  0){
                [t_button autoPinEdgeToSuperviewEdge:ALEdgeTop];
            }else{
                UIButton *btn_before = arr_all[i - 3];
                [t_button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:btn_before withOffset:7.0];
                
            }
            
        }
        
        [arr_v addObject:t_button];
        
    }
    
    
    if ([arr_v count] == 1) {
        
        UIButton *btn_before = arr_v[0];
        [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 20 - 60 - 2*3)/3];
        [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
        
    }else if ([arr_v count] == 2){
        
        UIButton *btn_before = arr_v[0];
        UIButton *btn_after = arr_v[1];
        [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 20 - 60 - 2*3)/3];
        [btn_after autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 20 - 60 - 2*3)/3];
        
        [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
        [btn_after autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:btn_before withOffset:3.0];
        
        [arr_v autoAlignViewsToAxis:ALAxisHorizontal];
        
    }else if ([arr_v count] == 3 ){
        
        [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:3.0 withFixedLeading:0 withFixedTrailing:0 matchedSizes:YES];
        
    }
    
    [arr_v removeAllObjects];
    
    for (int i = 0;i < [arr_all count]; i++) {
        UIButton *t_button  = arr_all[i];
        [t_button autoSetDimension:ALDimensionHeight toSize:21.f];
        if (i == arr_all.count - 1) {
            [btn_View autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:t_button];
        }
    }
    
    [t_view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:t_top withOffset:12.f];
    [t_view autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:t_top];
    [t_view autoPinEdge:ALEdgeTrailing  toEdge:ALEdgeTrailing ofView:t_top];
    [t_view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:btn_View];
    
    [self.arr_view addObject:t_view];
}

- (IBAction)btnTagAction:(id)sender{
    
    UIButton *t_btn = (UIButton *)sender;
    NSInteger  tag = t_btn.tag;
    
    NSInteger row  = tag/1000;
    NSInteger line = tag%1000;
    
    if (_arr_taskList.count > 0) {
        ActionShowListModel *model  = _arr_taskList[row];
        if (model) {
            NSArray * peoplelist = model.peopleArr;
            if (peoplelist.count > 0) {
                ActionPeopleModel *model = peoplelist[line];
                
                DutyPeopleModel *t_model = [[DutyPeopleModel alloc] init];
                t_model.realName = model.userName;
                t_model.telNum = model.userPhone;
                t_model.name = model.userName;
                [AlertView showWindowWithMakePhoneViewWith:t_model];
            }
        }
        
        
    }
    
}




#pragma mark - 让地图的中心点为定位坐标按钮

- (void)makeLocationInCenter{
    
    if (_model.latitude && _model.longitude) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_model.latitude doubleValue], [_model.longitude doubleValue]);
        [_mapView setCenterCoordinate:coordinate animated:YES];
    }
    
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
