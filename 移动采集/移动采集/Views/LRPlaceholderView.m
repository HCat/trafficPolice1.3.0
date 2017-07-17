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
        _reloadButton.frame = CGRectMake(0, 0, 150, 150);
        _reloadButton.center = self.center;
        if (self.isNetvailable) {
            
            [_reloadButton setImage:[UIImage imageNamed:@"icon_tablePlaceholder_error"] forState:UIControlStateNormal];
            [_reloadButton setTitle:@"网络异常，点击重试!" forState:UIControlStateNormal];
            [_reloadButton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
            [_reloadButton addTarget:self action:@selector(reloadClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            
            [_reloadButton setImage:[UIImage imageNamed:@"icon_tablePlaceholder_null"] forState:UIControlStateNormal];
            if (_str_placeholder) {
                [_reloadButton setTitle:_str_placeholder forState:UIControlStateNormal];
            }else{
                [_reloadButton setTitle:@"暂时没有任何内容" forState:UIControlStateNormal];
            }
            [_reloadButton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
            
        }
       
        [_reloadButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        CGSize buttonSize = self.reloadButton.bounds.size;
        CGSize titleSize = self.reloadButton.titleLabel.bounds.size;
        CGSize imageSize = self.reloadButton.imageView.bounds.size;
        self.reloadButton.imageEdgeInsets = UIEdgeInsetsMake((buttonSize.height-imageSize.height)/2, (buttonSize.width-imageSize.width)/2, imageSize.height/2, (buttonSize.width-imageSize.width)/2);
        self.reloadButton.titleEdgeInsets = UIEdgeInsetsMake(self.reloadButton.bounds.size.height, -imageSize.width/2-100, -titleSize.height/2, imageSize.width/2-100);
        
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
