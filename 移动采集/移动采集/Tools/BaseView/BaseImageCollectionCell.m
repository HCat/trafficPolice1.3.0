//
//  BaseImageCollectionCell.m
//  移动采集
//
//  Created by hcat on 2017/7/25.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "BaseImageCollectionCell.h"
#import "UIButton+Block.h"

@interface BaseImageCollectionCell()

@property(nonatomic,strong) NSLayoutConstraint * layout_image_bottom;

@property(nonatomic,strong) CAShapeLayer *border;

@end


@implementation BaseImageCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self imageView];
//        self.layer.masksToBounds = YES;
//        self.layer.cornerRadius = 5.0f;

    }
    
    return self;
    
}

- (UIImageView *)imageView{

    if (!_imageView) {
        _imageView = [UIImageView new];
        [self.contentView addSubview:_imageView];
        [_imageView configureForAutoLayout];
        [_imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
    
    }
    
    return _imageView;
}

- (UILabel *)lb_title{

    if (!_lb_title) {
        _lb_title = [UILabel new];
        _lb_title.textAlignment = NSTextAlignmentCenter;
        _lb_title.textColor = DefaultTextColor;
        _lb_title.font = [UIFont systemFontOfSize:14.f];
        [self.contentView addSubview:_lb_title];
        [_lb_title configureForAutoLayout];
        [_lb_title autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        [_lb_title autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
        
    }

    return  _lb_title;
}


- (UIButton *)btn_delete{
    
    if (!_btn_delete) {
        
        _btn_delete = [UIButton new];
        _btn_delete.hidden = YES;
        [self.contentView addSubview:_btn_delete];
        [_btn_delete configureForAutoLayout];
        [_btn_delete autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:1.f];
        [_btn_delete autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-1.f];
        [_btn_delete autoSetDimensionsToSize:CGSizeMake(15.f, 15.f)];
        [_btn_delete setEnlargeEdgeWithTop:15.0f right:15.0f bottom:15.0f left:15.0f];
        [_btn_delete setImage:[UIImage imageNamed:@"btn_jointImageDelete"] forState:UIControlStateNormal];
    }
    
    return  _btn_delete;
}

- (void)setIsNeedTitle:(BOOL)isNeedTitle{

    _isNeedTitle = isNeedTitle;

    if (_isNeedTitle) {
        
        [self lb_title];
        
        if (!self.layout_imageWithLb) {
            self.layout_imageWithLb = [_lb_title autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_imageView];
            [_imageView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:_imageView];
            
        }
        
    }else{
        
        if (_border) {
            [_border removeFromSuperlayer];
        }
    
        if (!self.layout_image_bottom) {
            self.layout_image_bottom =  [_imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        }
       
    }

}

- (void)setMoreImageView{
    
    self.isNeedTitle = NO;
    
    self.layer.cornerRadius = 0.0f;
    
    self.border = [CAShapeLayer layer];
    
    _border.strokeColor = UIColorFromRGB(0xcccccc).CGColor;
    
    _border.fillColor = nil;
    
    _border.path = [UIBezierPath bezierPathWithRect:self.contentView.bounds].CGPath;
    
    _border.frame = self.contentView.bounds;
    
    _border.lineWidth = 1.f;
    
    _border.lineCap = @"square";
    
    _border.lineDashPattern = @[@5, @4];
    
    [_imageView.layer addSublayer:_border];
    
    _imageView.image = [UIImage imageNamed:@"icon_takePhoto.png"];
    [_imageView setContentMode:UIViewContentModeCenter];
    
}

- (void)setCommonConfig{

    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 5.f;
    self.isNeedTitle = YES;
    self.layout_imageWithLb.constant = 10.f;

}


@end
