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


- (void)viewDidLoad {
    [super viewDidLoad];
    

    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ApplicationDelegate.vc_tabBar showTabBarAnimated:NO];
    

}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    
}

@end
