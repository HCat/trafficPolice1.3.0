//
//  AKTab.m
//
//  Created by hcat on 2017/9/22.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AKTab.h"

// 选中和未选中图标变化动画时间
static const float kAnimationDuration = 0.15;

// 内容视图与父视图间隔
static const float kPadding = 4.0;

// image视图与title视图距离
static const float kMargin = 2.0;

// 顶部视图距离
static const float kTopMargin = 2.0;

@interface AKTab (){
    BOOL isHaveTabIcon;          // 用于判断是否有图片
    BOOL isHaveTabIconSelected;  // 用于判断是否有选中图片
    
}

@end

@implementation AKTab

#pragma mark - Initialization
- (id)init
{
    self = [super init];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.backgroundColor = [UIColor clearColor];
        _isTitleHidden = NO;
        isHaveTabIcon = NO;
        isHaveTabIconSelected = NO;
    }
    return self;
}

#pragma mark - Touche handeling

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"contents"];
    animation.duration = kAnimationDuration;
    [self.layer addAnimation:animation forKey:@"contents"];
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    if (_keepFlag) {
        [super drawRect:rect];
        return;
    }
    
    if (_tab_imageName)isHaveTabIcon = YES;
    if (_tab_selectedImageName)isHaveTabIconSelected = YES;
    
    
    
    BOOL displayTabTitle = YES;
    if (!isHaveTabIcon) displayTabTitle = YES;
    if (_isTitleHidden) displayTabTitle = NO;
    
    
    
    // 容器的Rect,基于rect的中心
    CGRect container = CGRectInset(rect, kPadding, kPadding);
    container.size.height -= kTopMargin;
    container.origin.y += kTopMargin;
    
    
    UIImage *image; // 图片
    CGRect imageRect = CGRectZero; // 图片尺寸
    CGFloat ratio = 0.0; // 图片的宽高比
    
    
    
    if (isHaveTabIcon){
        
        if(self.selected){
            image = isHaveTabIconSelected ? [UIImage imageNamed:_tab_selectedImageName] : [UIImage imageNamed:_tab_imageName];
        }else{
            image = [UIImage imageNamed:_tab_imageName];
        }
        
        ratio = image.size.width / image.size.height;
        
        imageRect.size = image.size;
    }
    
    // 初始化titleLable
    UILabel *tabTitleLabel = [[UILabel alloc] init];
    tabTitleLabel.text = _tab_title;
    tabTitleLabel.font = _tab_titleFont ? _tab_titleFont : [UIFont fontWithName:@"Helvetica-Bold" size:11.0];
    tabTitleLabel.numberOfLines = 0;
    // 设置titleLable的高度
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    //原先是设置成NSLineBreakByTruncatingMiddle，这样不管字数多少都不会根据行高来计算高度
    if (isHaveTabIcon) {
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }else{
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    }
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{ NSFontAttributeName: tabTitleLabel.font,
                                  NSParagraphStyleAttributeName: paragraphStyle
                                  };
    CGSize labelSize = [tabTitleLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(rect), CGRectGetHeight(rect)) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    CGRect labelRect = CGRectZero;
    
    labelRect.size.height = (displayTabTitle) ? labelSize.height : 0;
    

    // 设置内容尺寸：(包含image和title)
    CGRect content = CGRectZero;
    
    content.size.width = CGRectGetWidth(container);
    // 我们根据图像的最长边(如果不是方形的情况)、标签的存在和容器的高度来确定高度
    content.size.height = MIN(MAX(CGRectGetWidth(imageRect), CGRectGetHeight(imageRect)) + ((displayTabTitle) ? (kMargin + CGRectGetHeight(labelRect)) : 0), CGRectGetHeight(container));
    
    // 设置内容坐标点在容器中心点
    content.origin.x = floorf(CGRectGetMidX(container) - CGRectGetWidth(content) / 2);
    content.origin.y = floorf(CGRectGetMidY(container) - CGRectGetHeight(content) / 2);
    
    
    
    
    //titleLable的宽度以及坐标点
    labelRect.size.width = CGRectGetWidth(content);
    labelRect.origin.x = CGRectGetMinX(content);
    labelRect.origin.y = CGRectGetMaxY(content) - CGRectGetHeight(labelRect);
    
    if (!displayTabTitle){
        labelRect = CGRectZero;
    }
    
    
    
    if (isHaveTabIcon){
        
        CGRect imageContainer = content;
        imageContainer.size.height = CGRectGetHeight(content) - ((displayTabTitle) ? (kMargin + CGRectGetHeight(labelRect)) : 0);
        
        // 当图像不是正方形时，我们必须确保它不会超出容器的bounds
        if (CGRectGetWidth(imageRect) >= CGRectGetHeight(imageRect)) {
            imageRect.size.width = MIN(CGRectGetHeight(imageRect), MIN(CGRectGetWidth(imageContainer), CGRectGetHeight(imageContainer)));
            imageRect.size.height = floorf(CGRectGetWidth(imageRect) / ratio);
        } else {
            imageRect.size.height = MIN(CGRectGetHeight(imageRect), MIN(CGRectGetWidth(imageContainer), CGRectGetHeight(imageContainer)));
            imageRect.size.width = floorf(CGRectGetHeight(imageRect) * ratio);
        }
        
        imageRect.origin.x = floorf(CGRectGetMidX(content) - CGRectGetWidth(imageRect) / 2);
        imageRect.origin.y = floorf(CGRectGetMidY(imageContainer) - CGRectGetHeight(imageRect) / 2);
    }
    
    
    
    
    // 添加图片视图
    if(isHaveTabIcon){
        for(UIView *view in self.subviews){
            if([view isKindOfClass:[UIImageView class]]){
                [view removeFromSuperview];
            }
        }
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:imageRect];
        imageview.image =  image;
        [self addSubview:imageview];
    }
    
    
    
    // 初始化绘制上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if (!self.selected) {
        
        if (displayTabTitle) {
            
            // 配置titleLabel的显示
            CGContextSaveGState(ctx);{
                
                UIColor *textColor = [UIColor colorWithRed:0.461 green:0.461 blue:0.461 alpha:1.0];
                CGContextSetFillColorWithColor(ctx, _tab_titleColor ? _tab_titleColor.CGColor : textColor.CGColor);
                
                UIFont *font = tabTitleLabel.font;
                NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                if (isHaveTabIcon) {
                    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingMiddle;
                }else{
                    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
                }
                paragraphStyle.alignment = NSTextAlignmentCenter;
                NSDictionary *attributes = @{ NSFontAttributeName: font,
                                              NSForegroundColorAttributeName:_tab_titleColor ? _tab_titleColor : textColor,
                                              NSParagraphStyleAttributeName: paragraphStyle };
                [tabTitleLabel.text drawInRect:labelRect withAttributes:attributes];
                
            }
            
            CGContextRestoreGState(ctx);
        }
        
    }else if (self.selected){
        
        /****************  选中背景颜色, 通过图片获取颜色和设置背景颜色获取  ***************/
        
        CGContextSaveGState(ctx);{
            if (_tab_selectedBgImageName) {
                [[UIColor colorWithPatternImage:[UIImage imageNamed:_tab_selectedBgImageName ? _tab_selectedBgImageName : @"LRTabBarController.bundle/noise-pattern"]] set];
                CGContextFillRect(ctx, rect);
            }
            
            if (_tab_selectedBgColor) {
                [_tab_selectedBgColor set];
                CGContextFillRect(ctx, rect);
            }
            
        }
        CGContextRestoreGState(ctx);
        
        // 设置渲染结束坐标
        CGFloat offsetY = rect.size.height - ((displayTabTitle) ? (kMargin + CGRectGetHeight(labelRect)) : 0) + kTopMargin;
        
        if (isHaveTabIcon && !isHaveTabIconSelected){
            
            /****************  图像上画出光泽的效果  ***************/
            CGContextSaveGState(ctx);{
                // Center of the circle + an offset to have the right angle no matter the size of the container
                CGFloat posX = CGRectGetMinX(container) - CGRectGetHeight(container);
                CGFloat posY = CGRectGetMinY(container) - CGRectGetHeight(container) * 2 - CGRectGetWidth(container);
                
                // Getting the icon center
                CGFloat dX = CGRectGetMidX(imageRect) - posX;
                CGFloat dY = CGRectGetMidY(imageRect) - posY;
                
                // Calculating the radius
                CGFloat radius = sqrtf((dX * dX) + (dY * dY));
                
                // We draw the circular path
                CGMutablePathRef glossPath = CGPathCreateMutable();
                CGPathAddArc(glossPath, NULL, posX, posY, radius, M_PI, 0, YES);
                CGPathCloseSubpath(glossPath);
                CGContextAddPath(ctx, glossPath);
                CGContextClip(ctx);
                
                // Clipping to the image path
                CGContextTranslateCTM(ctx, 0, offsetY);
                CGContextScaleCTM(ctx, 1.0, -1.0);
                CGContextClipToMask(ctx, imageRect, image.CGImage);
                
                // Drawing the clipped gradient
                size_t num_locations = 2;
                CGFloat locations[2] = {1, 0};
                CGFloat components[8] = {0.353, 0.353, 0.353, _isGlossySelected ? 1.0 : 0, // Start color
                    0.612, 0.612, 0.612, _isGlossySelected ? 1.0 : 0.0};  // End color
                
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGGradientRef gradient = CGGradientCreateWithColorComponents (colorSpace, components, locations, num_locations);
                CGContextDrawRadialGradient(ctx, gradient, CGPointMake(CGRectGetMinX(imageRect), CGRectGetMinY(imageRect)), 0, CGPointMake(CGRectGetMaxX(imageRect), CGRectGetMaxY(imageRect)), radius, kCGGradientDrawsBeforeStartLocation);
                
                CGColorSpaceRelease(colorSpace);
                CGGradientRelease(gradient);
                CGPathRelease(glossPath);
            }
            CGContextRestoreGState(ctx);
            
        }
        
        
        if (displayTabTitle) {
            /****************  配置选中的titleLabel样式 ***************/
            CGContextSaveGState(ctx);{
                
                UIColor *textColor = [UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1.0];
                CGContextSetFillColorWithColor(ctx, _tab_selectedTitleColor ? _tab_selectedTitleColor.CGColor : textColor.CGColor);
                
                UIFont *font = tabTitleLabel.font;
                NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                if (isHaveTabIcon) {
                    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingMiddle;
                }else{
                    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
                }
                paragraphStyle.alignment = NSTextAlignmentCenter;
                
                NSDictionary *attributes = @{ NSFontAttributeName: font,
                                              NSForegroundColorAttributeName: _tab_selectedTitleColor ? _tab_selectedTitleColor : textColor,
                                              NSParagraphStyleAttributeName: paragraphStyle };
                
                [tabTitleLabel.text drawInRect:labelRect withAttributes:attributes];
                
            }
            CGContextRestoreGState(ctx);
        }
        
    }
    
    /****************  设置显示标签通知 ***************/
    if (_showMark) {
        
        CGFloat center_x = content.size.width;
        CGFloat center_y = content.origin.y;
        
        UILabel *lb_number = [[UILabel alloc] initWithFrame:CGRectZero];
        NSString *str_number = nil;
        
        if (_markNumber > 99) {
            str_number = @"99+";
        }else{
            str_number = [NSString stringWithFormat:@"%ld",(long)_markNumber];
        }
        lb_number.text = str_number;
        lb_number.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1.0];
        lb_number.textAlignment = NSTextAlignmentCenter;
        lb_number.textColor = [UIColor whiteColor];
        lb_number.font = [UIFont systemFontOfSize:13.f];
        CGSize size = [lb_number.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:lb_number.font,NSFontAttributeName,nil]];
        CGFloat nameH = 16;
        CGFloat nameW = size.width + 6 < 16 ? 16 :size.width + 6;
        lb_number.frame = CGRectMake(0,0, nameW,nameH);
        if (_markNumber > 99) {
            lb_number.center = CGPointMake(self.bounds.size.width - nameW/2, center_y);
        }else{
            lb_number.center = CGPointMake(center_x, center_y);
        }
        
        lb_number.layer.cornerRadius = 8.f;
        lb_number.layer.masksToBounds = YES;
        [self addSubview:lb_number];
        
    }
    
    
}


@end

