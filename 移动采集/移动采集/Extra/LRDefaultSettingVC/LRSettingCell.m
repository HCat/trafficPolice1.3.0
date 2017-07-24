//
//  LRSettingCell.m
//  移动采集
//
//  Created by hcat on 2017/7/24.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "LRSettingCell.h"

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




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
