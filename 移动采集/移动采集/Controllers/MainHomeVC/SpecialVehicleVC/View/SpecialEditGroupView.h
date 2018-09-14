//
//  SpecialEditGroupView.h
//  移动采集
//
//  Created by hcat on 2018/9/11.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialCarAPI.h"

@interface SpecialEditGroupView : UIView

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subTitle;
@property (nonatomic,strong) SpecialCarModel * model;


+ (SpecialEditGroupView *)initCustomView;

- (void)show;

- (void)hide;



@end
