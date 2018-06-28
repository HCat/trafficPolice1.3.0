//
//  SurePlaceholderView.m
//  AppPlaceholder
//
//  Created by 刘硕 on 2016/11/30.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import "LRPlaceholderView.h"

@interface LRPlaceholderView ()
@property (nonatomic, strong) UIButton *reloadButton;
@end

@implementation LRPlaceholderView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self createUI];
}

- (void)createUI {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.reloadButton];
}

- (UIButton*)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (self.isNetvailable) {
            
            CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _img_netVailable.size.height + 30);
            _reloadButton.frame = frame;
            _reloadButton.center = self.center;
            [_reloadButton setImage:_img_netVailable forState:UIControlStateNormal];
            [_reloadButton setTitle:@"网络异常，点击重试!" forState:UIControlStateNormal];
            [_reloadButton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
            [_reloadButton addTarget:self action:@selector(reloadClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            
            CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, _img_dataNull.size.height + 30);
            _reloadButton.frame = frame;
            _reloadButton.center = self.center;
            [_reloadButton setImage:_img_dataNull forState:UIControlStateNormal];
            if (_str_placeholder) {
                [_reloadButton setTitle:_str_placeholder forState:UIControlStateNormal];
            }else{
                [_reloadButton setTitle:@"暂无内容" forState:UIControlStateNormal];
            }
            [_reloadButton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
            
        }
       
        [_reloadButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        self.reloadButton.titleEdgeInsets = UIEdgeInsetsMake(self.reloadButton.imageView.frame.size.height+10, -self.reloadButton.imageView.frame.size.width, 0, 0);
        self.reloadButton.imageEdgeInsets = UIEdgeInsetsMake(-self.reloadButton.titleLabel.bounds.size.height-10, 0, 0, -self.reloadButton.titleLabel.bounds.size.width);
        CGRect rect = _reloadButton.frame;
        rect.origin.y -= 50;
        _reloadButton.frame = rect;
    }
    return _reloadButton;
}

- (void)reloadClick:(UIButton*)button {
    if (self.reloadClickBlock) {
        self.reloadClickBlock();
    }
}

@end
