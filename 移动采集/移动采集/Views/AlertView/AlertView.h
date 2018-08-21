//
//  AlertView.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/17.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IllegalParkAlertView.h"
#import "DriverChooseView.h"
#import "VehicleAPI.h"
#import "MakePhoneView.h"
#import "IllegalListView.h"

@interface AlertView : UIView

+ (void)showWindowWithTitle:(NSString*)title
         contents:(NSString *)content;

+ (void)showWindowWithContentView:(UIView*)contentView;


+ (void)showWindowWithIllegalParkAlertViewSelectAction:(ParkDidSelectAction)selectAction;

+ (void)showWindowWithDriverChooseViewWith:(NSArray *)drivers complete:(DriverChooseViewBlock)complete;

+ (void)showWindowWithMakePhoneViewWith:(DutyPeopleModel *)people;

+ (void)showWindowWithIllegalListViewWith:(IllegalListView *)view inView:(UIView *)contentView;

- (void)handleBtnDismissClick:(id)sender;

@end
