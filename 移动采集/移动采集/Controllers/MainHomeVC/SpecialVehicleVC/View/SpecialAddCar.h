//
//  SpecialAddCar.h
//  移动采集
//
//  Created by hcat on 2018/9/11.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialCarAPI.h"


@interface SpecialAddCar : UIView

@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSNumber * groupId;
@property (nonatomic,strong) SpecialCarModel *model;
@property (nonatomic,assign) BOOL isEdit;


+ (SpecialAddCar *)initCustomView;

- (void)show;

- (void)hide;


@end
