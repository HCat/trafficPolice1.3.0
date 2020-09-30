//
//  VehicleExpireAlarmCell.m
//  移动采集
//
//  Created by hcat on 2018/5/21.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleExpireAlarmCell.h"
#import "TTGTextTagCollectionView.h"

@interface VehicleExpireAlarmCell()

@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *v_tag;

@end



@implementation VehicleExpireAlarmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _v_tag.alignment = TTGTagCollectionAlignmentCenter;
    _v_tag.manualCalculateHeight = YES;
     _v_tag.preferredMaxLayoutWidth = SCREEN_WIDTH - 50;
    _v_tag.enableTagSelection = NO;
    TTGTextTagConfig *config = [TTGTextTagConfig new];
    config.tagTextFont = [UIFont systemFontOfSize:13];
    
    config.tagTextColor = UIColorFromRGB(0x999999);
    config.tagBackgroundColor = UIColorFromRGB(0xE5E5E5);
    config.tagSelectedTextColor = UIColorFromRGB(0x4281E8);
    config.tagSelectedBackgroundColor = UIColorFromRGB(0xFFFFFF);
    config.tagCornerRadius = 2.f;
    config.tagSelectedCornerRadius = 2.f;
    config.tagBorderWidth = 0.0f;
    config.tagSelectedBorderWidth = 1.0f;
    config.tagSelectedBorderColor = UIColorFromRGB(0x4281E8);
    config.tagBorderColor = [UIColor clearColor];
    
    config.tagShadowColor = [UIColor clearColor];
    
    _v_tag.defaultConfig = config;
    
    NSArray <NSString *> * tags = @[@"年检到期",@"强制险到期",@"商业险到期",@"挂靠协议到期"];
    [_v_tag addTags:tags];
    
    
    
}

- (void)setExpireAlarmModel:(VehicleExpireAlarmModel *)expireAlarmModel{
    _expireAlarmModel = expireAlarmModel;
    
    if (_expireAlarmModel) {
        if ([_expireAlarmModel.inspectTimeEnd isEqualToNumber:@1]) {
            [_v_tag setTagAtIndex:0 selected:YES];
        }else{
            [_v_tag setTagAtIndex:0 selected:NO];
        }
        
        if ([_expireAlarmModel.compInsuranceTimeEnd isEqualToNumber:@1]) {
            [_v_tag setTagAtIndex:1 selected:YES];
        }else{
            [_v_tag setTagAtIndex:1 selected:NO];
        }
        
        if ([_expireAlarmModel.bussInsuranceTimeEnd isEqualToNumber:@1]) {
            [_v_tag setTagAtIndex:2 selected:YES];
        }else{
            [_v_tag setTagAtIndex:2 selected:NO];
        }
        
        if ([_expireAlarmModel.affiliatdTimeEnd isEqualToNumber:@1]) {
            [_v_tag setTagAtIndex:3 selected:YES];
        }else{
            [_v_tag setTagAtIndex:3 selected:NO];
        }
        
    }
    
    
}



#pragma mark - dealloc

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
