//
//  PoliceReleaseRadioVC.m
//  移动采集
//
//  Created by hcat on 2018/11/21.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "PoliceReleaseRadioVC.h"
#import "FSTextView.h"

@interface PoliceReleaseRadioVC ()

@property (weak, nonatomic) IBOutlet FSTextView *tv_radio;

@end

@implementation PoliceReleaseRadioVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"广播内容";
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
}

#pragma mark - button methods

- (IBAction)handleBtnReleaceClicked:(id)sender {
    
    
    
}



#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"PoliceReleaseRadioVC dealloc");
}


@end
