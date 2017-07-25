//
//  BaseImageCollectionCell.m
//  移动采集
//
//  Created by hcat on 2017/7/25.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "BaseImageCollectionCell.h"

@interface BaseImageCollectionCell()

@property(nonatomic,strong) NSLayoutConstraint * layout_image_bottom;
@property(nonatomic,strong) NSLayoutConstraint * layout_imageWithLb;

@end


@implementation BaseImageCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self imageView];
        

    }
    
    return self;
    
}

- (UIImageView *)imageView{

    if (!_imageView) {
        _imageView = [UIImageView new];
        [self.contentView addSubview:_imageView];
        [_imageView configureForAutoLayout];
        [_imageView autoPinEdgesToSuperviewMarginsExcludingEdge:ALEdgeBottom];
    
    }
    
    return _imageView;
}

- (UILabel *)lb_title{

    if (!_lb_title) {
        _lb_title = [UILabel new];
        [self.contentView addSubview:_lb_title];
        [_lb_title configureForAutoLayout];
        [_lb_title autoPinEdgesToSuperviewMarginsExcludingEdge:ALEdgeTop];
        
    }

    return  _lb_title;
}

- (void)setIsNeedTitle:(BOOL)isNeedTitle{

    _isNeedTitle = isNeedTitle;

    if (_isNeedTitle) {
        
        [self lb_title];
        
        if (!self.layout_imageWithLb) {
            self.layout_imageWithLb = [_lb_title autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_imageView];
        }
        
    }else{
        
        if (!self.layout_image_bottom) {
            self.layout_image_bottom =  [_imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        }
       
    }

}


@end
