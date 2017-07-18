//
//  HideTabSuperVC.m
//  HelloToy
//
//  Created by chenzf on 15/10/9.
//  Copyright © 2015年 NetDragon. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "UINavigationBar+BarItem.h"
#import "AppDelegate.h"

@interface HideTabSuperVC ()

@end

@implementation HideTabSuperVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    
    if([self canBack]){
        if (self.navigationController.viewControllers.count == 1) {
            [self showLeftBarButtonItemWithImage:@"nav_down" target:self action:@selector(handleBtnBackClicked)];
        }else{
            [self showLeftBarButtonItemWithImage:@"nav_back" target:self action:@selector(handleBtnBackClicked)];
        }
    }else {
        [self showLeftBarButtonItemWithImage:@"" target:nil action:nil];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ApplicationDelegate.vc_tabBar hideTabBarAnimated:NO];
    
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    
}

#pragma mark - Functions

-(void)handleBtnBackClicked{
    
    if (self.navigationController.viewControllers.count == 1) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

#pragma mark - Super Method

- (BOOL)canBack{
    return YES;
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    
}

@end
