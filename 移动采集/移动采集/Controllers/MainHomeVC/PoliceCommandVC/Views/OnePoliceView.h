//
//  OnePoliceView.h
//  移动采集
//
//  Created by hcat on 2017/9/12.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OnePoliceViewBlock)(NSString *name);

@interface OnePoliceView : UIView

@property (nonatomic,copy,readonly) NSString * name;
@property (nonatomic,copy) OnePoliceViewBlock block;

+ (OnePoliceView *)initCustomView;

- (void)dismiss;

@end
