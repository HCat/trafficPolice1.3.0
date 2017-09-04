//
//  PersistentBackgroundLabel.h
//  移动采集
//
//  Created by hcat on 2017/8/31.
//  Copyright © 2017年 Hcat. All rights reserved.
//

/********************
 用于防止UITableView点击的时候出现有背景颜色的UILabel颜色变成透明
*********************/
 
 
#import <UIKit/UIKit.h>

@interface PersistentBackgroundLabel : UILabel

- (void)setPersistentBackgroundColor:(UIColor*)color;

@end
