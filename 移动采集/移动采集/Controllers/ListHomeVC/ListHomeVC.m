//
//  ListHomeVC.m
//  移动采集
//
//  Created by hcat on 2017/7/18.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "ListHomeVC.h"

@interface ListHomeVC ()

@end

@implementation ListHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - AKTabBar Method

- (NSString *)tabImageName{
    return @"tabbar_list_n";
}

- (NSString *)tabSelectedImageName{
    return @"tabbar_list_h";
}

- (NSString *)tabTitle{
    return NSLocalizedString(@"列表", nil);
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    LxPrintf(@"ListHomeVC dealloc");
    
}


@end
