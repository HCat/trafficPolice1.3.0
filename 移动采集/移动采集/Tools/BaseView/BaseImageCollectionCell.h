//
//  BaseImageCollectionCell.h
//  移动采集
//
//  Created by hcat on 2017/7/25.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PureLayout.h>

@interface BaseImageCollectionCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *lb_title;
@property (nonatomic,strong) UIButton *btn_delete;
@property (nonatomic,assign) BOOL isNeedTitle;

@property(nonatomic,strong) NSLayoutConstraint * layout_imageWithLb;


- (void)setMoreImageView;
- (void)setCommonConfig;

@end
