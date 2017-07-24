//
//  LRSettingSectionModel.h
//  移动采集
//
//  Created by hcat on 2017/7/24.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
@interface LRSettingSectionModel : NSObject

@property (nonatomic,copy)   NSString  *sectionHeaderName; /**< 传空表示分组无名称*/

@property (nonatomic,assign) CGFloat  sectionHeaderHeight; /**< 分组header高度*/

@property (nonatomic,strong) NSArray  * itemArray; /**< item模型数组*/

@property (nonatomic,strong) UIColor  * sectionHeaderBgColor; /**< 背景色*/

@end
