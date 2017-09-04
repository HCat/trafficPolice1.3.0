//
//  BorderLabel.h
//  移动采集
//
//  Created by hcat on 2017/9/4.
//  Copyright © 2017年 Hcat. All rights reserved.
//

/********************
 自定义UILabel字体与边框的间距
 调用：
 showLabel.edgeInsets = UIEdgeInsetsMake(8, 8+2, 8, 8+2);//设置内边距
 [showLabel sizeToFit];//重新计算尺寸，会执行Label内重写的方法
 
 *********************/


#import <UIKit/UIKit.h>

@interface BorderLabel : UILabel

@property(nonatomic, assign) UIEdgeInsets edgeInsets;

@end
