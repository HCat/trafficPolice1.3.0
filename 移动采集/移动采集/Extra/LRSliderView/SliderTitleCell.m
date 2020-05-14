//
//  SliderTitleCell.m
//  LRSliderViewDemo
//
//  Created by hcat on 2018/7/13.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "SliderTitleCell.h"
#import <Masonry.h>
#import "LRSliderViewConfig.h"





@implementation SliderTitleCell


- (void)bindStyleButton:(UIButton *)btn status:(BOOL)isSelected{
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    UIButton * titleButton = btn;
    titleButton.userInteractionEnabled = NO;
    [titleButton setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    if (isSelected) {
        titleButton.transform = CGAffineTransformMakeScale([LRSliderViewConfig sharedConfig].scaleSize, [LRSliderViewConfig sharedConfig].scaleSize);
    }
    
    [titleButton setTitleColor:isSelected ?  [LRSliderViewConfig sharedConfig].selectedColor : [LRSliderViewConfig sharedConfig].titleColor forState:UIControlStateNormal];
    [self addSubview:titleButton];
    [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1.00];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.trailing.mas_equalTo(0);
    }];
    

}


@end
