//
//  UIImage+Category.h
//  SlagCar
//
//  Created by hcat on 2018/11/22.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum  {
    topToBottom = 0,//从上到小
    leftToRight = 1,//从左到右
    upleftTolowRight = 2,//左上到右下
    uprightTolowLeft = 3,//右上到左下
}GradientType;

@interface UIImage(Category)
//获取具有颜色的图片
+ (UIImage *)imageWithColor:(UIColor *)color;
//获取渐变色的图片
+ (UIImage *)imageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType;

@end

NS_ASSUME_NONNULL_END
