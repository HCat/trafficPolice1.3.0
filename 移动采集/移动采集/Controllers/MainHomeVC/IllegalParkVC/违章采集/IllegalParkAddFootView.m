//
//  IllegalParkAddFootView.m
//  trafficPolice
//
//  Created by hcat on 2017/5/31.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalParkAddFootView.h"

@implementation IllegalParkAddFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    _btn_commit.enabled = NO;
    [_btn_commit setBackgroundColor:DefaultBtnNuableColor];

    // Initialization code
}

#pragma mark - buttonMethods 

- (IBAction)handleBtnCommitClicked:(id)sender {

    if (self.delegate && [self.delegate respondsToSelector:@selector(handleCommitClicked)]) {
        [self.delegate handleCommitClicked];
    }

}

#pragma mark - dealloc

- (void)dealloc{

    LxPrintf(@"IllegalParkAddFootView dealloc");

}

@end
