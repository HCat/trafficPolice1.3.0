//
//  AlertView.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/17.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIView

+ (void)showWindowWithTitle:(NSString*)title
         contents:(NSString *)content;

+ (void)showWindowWithContentView:(UIView*)contentView;


@end
