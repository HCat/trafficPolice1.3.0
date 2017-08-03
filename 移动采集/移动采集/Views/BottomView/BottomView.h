//
//  BottomView.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/17.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRSingleton.h"

@interface BottomView : UIView

LRSingletonH(Default)

+ (void)showWindowWithBottomView:(UIView*)bottomView;

+ (void)dismissWindow;

@end
