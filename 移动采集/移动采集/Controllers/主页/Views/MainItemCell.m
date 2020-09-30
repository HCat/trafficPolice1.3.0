//
//  MainItemCell.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/12.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "MainItemCell.h"

@implementation MainItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lb_box.layer.borderColor = UIColorFromRGB(0xE2E2E2).CGColor;
    self.lb_box.layer.borderWidth = 1.0f;
    
}

@end
