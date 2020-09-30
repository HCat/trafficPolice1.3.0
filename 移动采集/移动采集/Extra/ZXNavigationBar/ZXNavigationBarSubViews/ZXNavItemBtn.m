//
//  ZXNavItemBtn.m
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/7.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar

#import "ZXNavItemBtn.h"
#import "ZXNavigationBarDefine.h"
#import "UIImage+ZXNavColorRender.h"
#import "NSString+ZXNavCalcSizeExtension.h"

@implementation ZXNavItemBtn

#pragma mark - Setter
- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    if(self.zx_tintColor){
        [self setTitleColor:self.zx_tintColor forState:UIControlStateNormal];
    }
    [self noticeUpdateFrame];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    if (self.isTintColor) {
        [super setImage:image forState:state];
        if(!image){
            self.imageView.image = image;
        }
        [self noticeUpdateFrame];
    }else{
        if(self.zx_tintColor){
            image = [image zx_renderingColor:self.zx_tintColor];
        }
        [super setImage:image forState:state];
        if(!image){
            self.imageView.image = image;
        }
        [self noticeUpdateFrame];
    }
    
}

- (void)setZx_imageColor:(UIColor *)zx_imageColor{
    _zx_imageColor = zx_imageColor;
    [self setImage:[self.currentImage zx_renderingColor:zx_imageColor] forState:UIControlStateNormal];
}

#pragma mark - pirvate
- (void)noticeUpdateFrame{
    if(self.zx_barItemBtnFrameUpdateBlock){
        self.zx_barItemBtnFrameUpdateBlock(self);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutImageAndTitle];
}

#pragma mark ButtonLayout
- (void)layoutImageAndTitle{
    CGFloat btnw = [[NSString stringWithFormat:@"%@",self.currentTitle] getRectWidthWithLimitH:self.frame.size.height fontSize:self.titleLabel.font.pointSize] + 5;
    if(self.imageView.image){
        
        self.imageView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame), 0, btnw, self.frame.size.height);
        
        if (self.currentTitle.length > 0) {
            self.titleLabel.frame = CGRectMake(0, 0, btnw, self.frame.size.height);
            self.imageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, self.imageView.image.size.width, self.frame.size.height);
            self.imageView.contentMode = UIViewContentModeCenter;
            
        }
    
    }else{
        self.imageView.frame = CGRectZero;
        self.titleLabel.frame = CGRectMake(0, 0, btnw, self.frame.size.height);
    }
}

@end
