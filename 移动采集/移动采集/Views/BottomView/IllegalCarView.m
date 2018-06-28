//
//  IllegalCarView.m
//  移动采集
//
//  Created by hcat on 2018/6/25.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalCarView.h"

@implementation IllegalCarView

+ (IllegalCarView *)initCustomView{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"IllegalCarView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

- (IBAction)handleBtnSuperviseClick:(id)sender {
    if (self.superviseBlock) {
        self.superviseBlock();
    }
    
}

- (IBAction)handleBtnExemptCarClick:(id)sender {
    if (self.exemptCarBlock) {
        self.exemptCarBlock();
    }
    
}

@end
