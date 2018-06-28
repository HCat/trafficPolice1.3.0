//
//  MakePhoneView.h
//  移动采集
//
//  Created by hcat on 2018/6/28.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DutyAPI.h"

@interface MakePhoneView : UIView

@property(nonatomic,strong) DutyPeopleModel * people;

+ (MakePhoneView *)initCustomView;

@end
