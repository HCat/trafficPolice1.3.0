//
//  MessageHomeVC.m
//  移动采集
//
//  Created by hcat on 2017/7/18.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "MessageHomeVC.h"

@interface MessageHomeVC ()

@end

@implementation MessageHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - AKTabBar Method

- (NSString *)tabImageName{
    return @"tabbar_message_n";
}

- (NSString *)tabSelectedImageName{
    return @"tabbar_message_h";
}

- (NSString *)tabTitle{
    return NSLocalizedString(@"消息", nil);
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    LxPrintf(@"MessageHomeVC dealloc");
    
}

@end
