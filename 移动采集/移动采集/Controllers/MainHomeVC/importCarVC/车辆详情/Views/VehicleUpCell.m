//
//  VehicleUpCell.m
//  移动采集
//
//  Created by hcat on 2018/5/21.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleUpCell.h"
#import "TTGTextTagCollectionView.h"

@interface VehicleUpCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_road;

@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;


@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *v_tag;

@end


@implementation VehicleUpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _v_tag.alignment = TTGTagCollectionAlignmentLeft;
    _v_tag.manualCalculateHeight = YES;
    _v_tag.preferredMaxLayoutWidth = SCREEN_WIDTH - 95;
    TTGTextTagConfig *config = [TTGTextTagConfig new];
    config.tagTextFont = [UIFont systemFontOfSize:13];
    config.tagTextColor = UIColorFromRGB(0x4281E8);
    config.tagBackgroundColor = UIColorFromRGB(0xFFFFFF);
    config.tagSelectedTextColor = UIColorFromRGB(0x4281E8);
    config.tagSelectedBackgroundColor = UIColorFromRGB(0xFFFFFF);
    config.tagCornerRadius = 2.f;
    config.tagSelectedCornerRadius = 2.f;
    config.tagBorderWidth = 1.0f;
    config.tagSelectedBorderWidth = 1.0f;
    config.tagBorderColor = UIColorFromRGB(0x4281E8);
    config.tagSelectedBorderColor = UIColorFromRGB(0x4281E8);
    
    config.tagShadowColor = [UIColor clearColor];
    
    _v_tag.defaultConfig = config;
}

- (void)setModel:(VehicleUpDetailModel *)model{

    _model = model;
    _lb_time.text = [ShareFun timeWithTimeInterval:_model.entryDate dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _lb_road.text = model.road;
    _lb_address.text = model.position;
    [_v_tag removeAllTags];
    NSArray  *tags = [model.illegalType componentsSeparatedByString:@","];
   
    [_v_tag addTags:tags ];
   
}


#pragma mark -

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
