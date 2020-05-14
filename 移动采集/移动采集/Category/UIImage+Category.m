//
//  UIImage+Category.m
//  SlagCar
//
//  Created by hcat on 2018/11/22.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "UIImage+Category.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>




@implementation UIImage(Category)

+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return image;
}


+ (UIImage *)imageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    
    CGFloat height = Height_NavBar;
    CGSize size = CGSizeMake(SCREEN_WIDTH, height);
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, 0.0);
            break;
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, size.height);
            break;
        case 3:
            start = CGPointMake(size.width, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;

}


- (UIImage *)imageChangeColor:(UIColor *)color{
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(context, 0, self.size.height);

    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextSetBlendMode(context, kCGBlendModeNormal);

    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);

    CGContextClipToMask(context, rect, self.CGImage);

    [color setFill];

    CGContextFillRect(context, rect);

    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return newImage;

}


- (UIImage *)imageRotateIndegree:(float)degree{
    //1 image -> Context
    size_t width = (size_t)(self.size.width * self.scale);
    size_t height = (size_t)(self.size.height * self.scale);
    
    size_t bytesPerRow = width * 4;//每行像素的比特数
    CGImageAlphaInfo alphaInfo = kCGImageAlphaPremultipliedFirst;//alpha
    //配置上下文参数
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrderDefault | alphaInfo);    //2的8次方255种颜色，颜色的深度

    if (!bmContext) {
        return nil;
    }
    CGContextDrawImage(bmContext, CGRectMake(0, 0, width, height), self.CGImage);
    //2 旋转
    
    //参数1 旋转源
    //参数2 旋转之后的图片
    //参数3 忽略
    //参数4 旋转的角度
    //参数5 背景颜色
    //参数6 填充颜色
    
    UInt8 *data = (UInt8 *)CGBitmapContextGetData(bmContext);
    vImage_Buffer src = {data, height, width,bytesPerRow};
    vImage_Buffer dest = {data, height, width,bytesPerRow};
    Pixel_8888 bgColor = {0,0,0,0};
    vImageRotate_ARGB8888(&src, &dest, NULL, degree, bgColor, kvImageBackgroundColorFill);
    //3 Content -> UIImage
    CGImageRef rotateImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage *rotateImage = [UIImage imageWithCGImage:rotateImageRef scale:self.scale orientation:self.imageOrientation];
    return rotateImage;
}


@end
