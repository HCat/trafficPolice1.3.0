//
//  VehicleTrafficTopCell.m
//  移动采集
//
//  Created by hcat on 2018/5/30.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleTrafficTopCell.h"
#import <MAMapKit/MAMapKit.h>
#import <PureLayout.h>

@interface VehicleTrafficTopCell ()<MAMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *v_map;
@property (nonatomic, strong) MAMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *lb_roadWay;

@property (weak, nonatomic) IBOutlet UILabel *lb_transportDate;

@property (nonatomic,strong) NSMutableArray * arr_lables;
@property (nonatomic, strong) NSMutableArray *arr_point;


@property (weak, nonatomic) IBOutlet UIView *v_place;
@property (weak, nonatomic) IBOutlet UILabel *lb_placeInfo;

@property (weak, nonatomic) IBOutlet UIView *v_address;
@property (weak, nonatomic) IBOutlet UILabel *lb_addressInfo;

@property (nonatomic,strong) NSMutableArray * arr_lable_address;

@end

@implementation VehicleTrafficTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.arr_lables = [NSMutableArray array];
    self.arr_point = [NSMutableArray array];
    self.arr_lable_address = [NSMutableArray array];
    [self initMapView];
}

- (void)initMapView{
    
    self.mapView = [[MAMapView alloc] initWithFrame:_v_map.bounds];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mapView.delegate = self;
    
    [_v_map addSubview:_mapView];
    [_v_map sendSubviewToBack:_mapView];
    [_mapView configureForAutoLayout];
    [_mapView autoPinEdgesToSuperviewEdges];
    
    
    _mapView.distanceFilter = 10;
    _mapView.showsCompass= NO;
    _mapView.showsScale= NO;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
   
    
}

- (void)setModel:(VehicleRouteDetailModel *)model{

    if (_model) {
        return;
    }else{
        _model = model;
        if (_model) {
            
            _lb_transportDate.text = [NSString stringWithFormat:@"%@至%@",_model.projectStartDate,_model.projectendDate];
            _lb_roadWay.text = [ShareFun takeStringNoNull:_model.acrossRoad];
            
            [self buildWorkTime:_model];
            
            if (_model.routeDetentionList && _model.routeDetentionList.count > 0) {
                
                for (VehicleRouteAddressModel * t_model in _model.routeDetentionList) {
                    [self buildLableWithTitle:t_model];
                }
                [self addLayoutInAddressViews:_arr_lable_address];
                
            }else{
                
                [_lb_addressInfo autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-25.f];
            }
            
            if (_model.routePoints.length > 0) {
                NSArray *t_arr = [_model.routePoints componentsSeparatedByString:@";"];
                if (t_arr && t_arr.count > 0) {
                    
                    CLLocationCoordinate2D commonPolylineCoords[t_arr.count];
                    
                    for (int i = 0; i < t_arr.count; i++) {
                        
                        NSString * t_str = t_arr[i];
                        NSArray * t_point = [t_str componentsSeparatedByString:@","];
                        commonPolylineCoords[i].latitude = [(NSString *)t_point[1] doubleValue];
                        commonPolylineCoords[i].longitude = [(NSString *)t_point[0] doubleValue];
                        
                        MAPointAnnotation *positionAnnotation = [[MAPointAnnotation alloc] init];
                        positionAnnotation.coordinate = commonPolylineCoords[i];
                       
                        [_arr_point addObject:positionAnnotation];
                        
                    }

                    //构造折线对象
                    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:t_arr.count];
                    
                    //在地图上添加折线对象
                    [_mapView addOverlay: commonPolyline];
                    
                    CLLocationCoordinate2D center_coordinate = CLLocationCoordinate2DMake(commonPolylineCoords[0].latitude, commonPolylineCoords[0].longitude);
                    [self.mapView setCenterCoordinate:center_coordinate animated:YES];
                    
                    [self showsAnnotations:_arr_point edgePadding:UIEdgeInsetsMake(500, 500, 500, 500) andMapView:_mapView];
                    
                }
            }
            
        }
    }

}

#pragma mark - build

- (void)buildWorkTime:(VehicleRouteDetailModel *)model{
    
    if (_model.projectWorkTime1.length > 0) {
        NSString *temp = [_model.projectWorkTime1 stringByReplacingOccurrencesOfString:@"," withString:@"-"];
        [self buildLableWithTitle:@"作业时段1:" AndText:temp WithArr:_arr_lables inView:self.contentView];
       
    }
    
    if (_model.projectWorkTime2.length > 0) {
        NSString *temp = [_model.projectWorkTime2 stringByReplacingOccurrencesOfString:@"," withString:@"-"];
        [self buildLableWithTitle:@"作业时段2:" AndText:temp WithArr:_arr_lables inView:self.contentView];
        
    }
    
    if (_model.projectWorkTime3.length > 0) {
        NSString *temp = [_model.projectWorkTime3 stringByReplacingOccurrencesOfString:@"," withString:@"-"];
        [self buildLableWithTitle:@"作业时段3:" AndText:temp WithArr:_arr_lables inView:self.contentView];
        
    }
    
    if (_model.projectWorkTime4.length > 0) {
        NSString *temp = [_model.projectWorkTime4 stringByReplacingOccurrencesOfString:@"," withString:@"-"];
        [self buildLableWithTitle:@"作业时段4:" AndText:temp WithArr:_arr_lables inView:self.contentView];
        
    }
    
    if (_arr_lables.count > 0) {
        
        [self addLayoutInViews:_arr_lables];
        
    }else{
        
        [self.lb_transportDate autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_lb_roadWay withOffset:15.f];
        
    }
    
}

- (void)buildLableWithTitle:(NSString *)title AndText:(NSString *)text WithArr:(NSMutableArray *)arr inView:(UIView *)view{
    
    UILabel * t_title = [UILabel newAutoLayoutView];
    t_title.font = [UIFont systemFontOfSize:14.f];
    t_title.textColor = UIColorFromRGB(0x999999);
    t_title.text = title;
    t_title.numberOfLines = 0;
    [view addSubview:t_title];
    [t_title autoSetDimension:ALDimensionWidth toSize:70.f];
    [t_title autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:_v_map];
    
    UILabel * t_content = [UILabel newAutoLayoutView];
    t_content.font = [UIFont systemFontOfSize:14.f];
    t_content.textColor = [UIColor blackColor];
    t_content.numberOfLines = 0;
    t_content.text = text;
    [view addSubview:t_content];
    
    
    [t_content autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:t_title withOffset:0.f];
    [t_content autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:t_title withOffset:5.f];
    
    [t_content autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:view withOffset:18.f];
    [arr addObject:t_content];
}

- (void)addLayoutInViews:(NSMutableArray *)arr{
    
    if (arr && arr.count > 0) {
        
        
        [[arr firstObject] autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_lb_roadWay withOffset:15.f];
        UIView * previousView = nil;
        for (UIView *view in arr) {
            if (previousView) {
                [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousView withOffset:15.f];
            }
            previousView = view;
        }
        
        [[arr lastObject] autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_lb_transportDate withOffset:-15.f];
    }
}


- (void)buildLableWithTitle:(VehicleRouteAddressModel *)address{
    
    UILabel * t_place = [UILabel newAutoLayoutView];
    t_place.font = [UIFont systemFontOfSize:14.f];
    t_place.numberOfLines = 0;
    t_place.textColor = [UIColor blackColor];
    t_place.text = address.name;
    [self.contentView addSubview:t_place];
    [t_place autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.lb_placeInfo withOffset:0];
    [t_place autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.v_place withOffset:-8];
    
    UILabel * t_content = [UILabel newAutoLayoutView];
    t_content.font = [UIFont systemFontOfSize:14.f];
    t_content.textColor = [UIColor blackColor];
    t_content.numberOfLines = 0;
    t_content.text = address.address;
    [self.contentView addSubview:t_content];
    [t_content autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.lb_addressInfo withOffset:0];
    [t_content autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.v_address withOffset:-8];
    
    [t_content autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:t_place withOffset:0.f];
    [t_content autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:t_place];
    
    UILabel * t_line = [UILabel newAutoLayoutView];
    t_line.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [self.contentView addSubview:t_line];
    [t_line autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.lb_placeInfo withOffset:0];
    [t_line autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.v_address withOffset:-8];
    [t_line autoSetDimension:ALDimensionHeight toSize:1.f];
    [t_line autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:t_content withOffset:15.f];
    
    [_arr_lable_address addObject:t_content];
    
}


- (void)addLayoutInAddressViews:(NSMutableArray *)arr{
    
    if (arr && arr.count > 0) {
        
        [[arr firstObject] autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_lb_addressInfo withOffset:15.f];
        UIView * previousView = nil;
        for (UIView *view in arr) {
            if (previousView) {
                [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousView withOffset:26.f];
            }
            previousView = view;
        }
        
        [[arr lastObject] autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-25.f];
    }
}



- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeColor  = UIColorFromRGB(0x4281E8);
        polylineRenderer.lineJoin = kCGLineJoinRound;
        polylineRenderer.lineCap  = kCGLineCapRound;
        
        return polylineRenderer;
    }
    return nil;
}

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
    
    LxPrintf(@"VehicleTrafficTopCell dealloc");
}

@end
