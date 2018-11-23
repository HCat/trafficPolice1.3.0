//
//  PoliceDetailDisAnnotationView.m
//  移动采集
//
//  Created by hcat on 2018/11/19.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "PoliceDetailDisAnnotationView.h"

@implementation PoliceDetailDisAnnotationView

+ (PoliceDetailDisAnnotationView *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PoliceDetailDisAnnotationView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

- (IBAction)handleBtnPhoneCallClicked:(id)sender {
    
    
    
    
}




@end
