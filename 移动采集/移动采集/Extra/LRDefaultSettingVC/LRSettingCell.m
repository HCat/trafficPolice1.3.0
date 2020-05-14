//
//  LRSettingCell.m
//  移动采集
//
//  Created by hcat on 2017/7/24.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "LRSettingCell.h"
#import <PureLayout.h>

//功能图片到左边界的距离
#define XBFuncImgToLeftGap 21

//功能名称字体
#define XBFuncLabelFont 15

//功能名称到功能图片的距离,当功能图片funcImg不存在时,等于到左边界的距离
#define XBFuncLabelToFuncImgGap 18

//指示箭头或开关到右边界的距离
#define XBIndicatorToRightGap 20

//详情文字字体
#define XBDetailLabelFont 12

//详情到指示箭头或开关的距离
#define XBDetailViewToIndicatorGap 13

@interface LRSettingCell ()

@property (strong, nonatomic) UILabel *funcNameLabel;

@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic,strong) UIImageView *indicator;

@property (nonatomic,strong) UISwitch *aswitch;

@property (nonatomic,strong) UILabel *detailLabel;

@property (nonatomic,strong) UIImageView *detailImageView;

@end

@implementation LRSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(LRSettingItemModel *)item
{
    _item = item;
    [self updateUI];
    
}

- (void)updateUI
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //如果有图片
    if (self.item.img) {
        [self setupImgView];
    }
    //功能名称
    if (self.item.funcName) {
        [self setupFuncLabel];
    }
    
    //accessoryType
    if (self.item.accessoryType) {
        [self setupAccessoryType];
    }
    //detailView
    if (self.item.detailText) {
        [self setupDetailText];
    }
    if (self.item.detailImage) {
        [self setupDetailImage];
    }
    
}


-(void)setupDetailImage
{
    self.detailImageView = [[UIImageView alloc]initWithImage:self.item.detailImage];
    [self.contentView addSubview:self.detailImageView];
    [self.detailImageView configureForAutoLayout];
    [self.detailImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];

    switch (self.item.accessoryType) {
            
        case LRSettingAccessoryTypeNone:
            
            [self.detailImageView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:XBIndicatorToRightGap];
            
            break;
        case LRSettingAccessoryTypeDisclosureIndicator:
            
            [self.detailImageView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.indicator withOffset:-XBIndicatorToRightGap];
            
            break;
        case LRSettingAccessoryTypeSwitch:
            
            [self.detailImageView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.aswitch withOffset:-XBIndicatorToRightGap];
            
            break;
        default:
            break;
    }
    
}

- (void)setupDetailText
{
    self.detailLabel = [[UILabel alloc]init];
    self.detailLabel.text = self.item.detailText;
    self.detailLabel.textColor = RGBA(142, 142, 142, 1);
    self.detailLabel.font = [UIFont systemFontOfSize:XBDetailLabelFont];
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel configureForAutoLayout];
    [self.detailLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    switch (self.item.accessoryType) {
        case LRSettingAccessoryTypeNone:
            
             [self.detailLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:XBIndicatorToRightGap];
    
            break;
        case LRSettingAccessoryTypeDisclosureIndicator:
            
              [self.detailLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.indicator withOffset:-XBIndicatorToRightGap];
            
            break;
        case LRSettingAccessoryTypeSwitch:
           
            [self.detailLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.aswitch withOffset:-XBIndicatorToRightGap];
            
            break;
        default:
            break;
    }
    
}

- (void)setupAccessoryType
{
    switch (self.item.accessoryType) {
        case LRSettingAccessoryTypeNone:
            break;
        case LRSettingAccessoryTypeDisclosureIndicator:
            [self setupIndicator];
            break;
        case LRSettingAccessoryTypeSwitch:
            [self setupSwitch];
            break;
        default:
            break;
    }
}

- (void)setupImgView
{
    self.imgView = [[UIImageView alloc]initWithImage:self.item.img];
    [self.contentView addSubview:self.imgView];
    [self.imgView configureForAutoLayout];
    [self.imgView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.imgView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:XBFuncImgToLeftGap];

}

- (void)setupFuncLabel
{
    self.funcNameLabel = [[UILabel alloc]init];
    self.funcNameLabel.text = self.item.funcName;
    self.funcNameLabel.textColor = DefaultTextColor;
    self.funcNameLabel.font = [UIFont systemFontOfSize:XBFuncLabelFont];
    [self.contentView addSubview:self.funcNameLabel];
    [self.funcNameLabel configureForAutoLayout];
    [self.funcNameLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    if (self.imgView) {
        [self.funcNameLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.imgView withOffset:XBFuncLabelToFuncImgGap];
    }else{
        [self.funcNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:XBFuncImgToLeftGap];
    }

}


- (void)setupSwitch
{
    self.aswitch = [[UISwitch alloc]init];
    [self.contentView addSubview:self.aswitch];
    [self.aswitch configureForAutoLayout];
    [self.aswitch autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.aswitch autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:XBIndicatorToRightGap];
    [self.aswitch addTarget:self action:@selector(switchTouched:) forControlEvents:UIControlEventValueChanged];
}

- (void)setupIndicator
{
    self.indicator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_arrow"]];
    [self.contentView addSubview:self.indicator];
    [self.indicator configureForAutoLayout];
    [self.indicator autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.indicator autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:XBIndicatorToRightGap];
    
}

- (void)switchTouched:(UISwitch *)sw
{
    __weak typeof(self) weakSelf = self;
    self.item.switchValueChanged(weakSelf.aswitch.isOn);
}

#pragma mark -

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{

    LxPrintf(@"LRSettingCell dealloc");

}

@end
