//
//  ShowTabSuperVC.m
//  HelloToy
//
//  Created by chenzf on 15/10/9.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "ShowTabSuperVC.h"
#import "AppDelegate.h"
#import "UIButton+Block.h"

@interface ShowTabSuperVC ()


@end

@implementation ShowTabSuperVC

- (instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [ApplicationDelegate.vc_tabBar showTabBarAnimated:NO];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
    
}




#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)dealloc{

}

@end
