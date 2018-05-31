//
//  VehicleTrafficPlaceCell.m
//  移动采集
//
//  Created by hcat on 2018/5/31.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleTrafficPlaceCell.h"
#import <PureLayout.h>

@interface VehicleTrafficPlaceCell()

@property (weak, nonatomic) IBOutlet UIView *v_place;
@property (weak, nonatomic) IBOutlet UILabel *lb_placeInfo;

@property (weak, nonatomic) IBOutlet UIView *v_address;

@property (weak, nonatomic) IBOutlet UILabel *lb_addressInfo;

@property (nonatomic,strong) NSMutableArray * arr_lables;

@end


@implementation VehicleTrafficPlaceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.arr_lables = [NSMutableArray array];
    
}

- (void)setModel:(VehicleRouteDetailModel *)model{
    
    if (_model) {
        return;
    }else{
        _model = model;
        if (_model) {
            
            if (_model.routeDetentionList && _model.routeDetentionList.count > 0) {
                
                for (VehicleRouteAddressModel * t_model in _model.routeDetentionList) {
                    [self buildLableWithTitle:t_model];
                }
                [self addLayoutInViews:_arr_lables];
            
            }
 
        }
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
    
    [_arr_lables addObject:t_content];
    
}


- (void)addLayoutInViews:(NSMutableArray *)arr{
    
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - dealloc

- (void)dealloc{
    
    LxPrintf(@"VehicleTrafficPlaceCell dealloc");
}

@end
