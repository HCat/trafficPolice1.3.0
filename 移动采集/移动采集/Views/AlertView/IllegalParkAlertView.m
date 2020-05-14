//
//  IllegalParkAlertView.m
//  移动采集
//
//  Created by hcat on 2018/3/13.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalParkAlertView.h"
#import "AlertView.h"

@implementation IllegalParkAlertView

+ (IllegalParkAlertView *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"IllegalParkAlertView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

- (IBAction)handleBtnMakeSureClicked:(id)sender {
    
    if (self.block) {
        self.block(ParkAlertActionTypeRight);
    }
    
    AlertView * alertView = (AlertView *)self.superview;
    
    [alertView handleBtnDismissClick:nil];
    
}

- (IBAction)handleBtnCancelClicked:(id)sender {
    
    if (self.block) {
        self.block(ParkAlertActionTypeLeft);
    }

    AlertView * alertView = (AlertView *)self.superview;
    [alertView handleBtnDismissClick:nil];
    
}

@end
