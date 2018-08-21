//
//  AKTab.h
//
//  Created by hcat on 2017/9/22.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface AKTab : UIButton

// 是否保持UIButton原始状态，不重新进行绘制
@property(nonatomic,assign)   BOOL keepFlag;
// 是否显示或者隐藏title
@property (nonatomic, assign) BOOL isTitleHidden;


// Tab未选中状态下的图片名称
@property (nonatomic, copy)   NSString * tab_imageName;
// Tab选中状态下的图片名称
@property (nonatomic, copy)   NSString * tab_selectedImageName;


// Tab选中状态下的背景图片名称
@property (nonatomic, copy)   NSString * tab_selectedBgImageName;
// Tab选中状态下的背景颜色
@property (nonatomic,strong)  UIColor  * tab_selectedBgColor;


// Tab未选中状态下的显示的title
@property (nonatomic, copy)   NSString * tab_title;
// Tab未选中状态下的title字体颜色
@property (nonatomic, strong) UIColor  * tab_titleColor;
// Tab选中状态下的title字体颜色
@property (nonatomic, strong) UIColor  * tab_selectedTitleColor;
// Tab未选中状态下的显示的title的font
@property (nonatomic, strong) UIFont   * tab_titleFont;

// Tab在无选中图片时候，是否显示发光效果
@property (nonatomic, assign) BOOL isGlossySelected;

// tab设置是否显示通知点
@property (nonatomic, assign) BOOL showTip;

// tab设置是否显示通知圆点
@property (nonatomic, assign) BOOL showMark;
// tab设置通知数目,当数目大于99的时候显示99+
@property (nonatomic, assign) NSInteger markNumber;

@end
