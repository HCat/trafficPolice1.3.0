//
//  BaseViewController.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "BaseViewController.h"
#import "UINavigationBar+BarItem.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBGColor;
    // Do any additional setup after loading the view.
}

#pragma mark - set && get


- (void)setCanBack:(BOOL)canBack{

    _canBack = canBack;

    if (_canBack) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
        
        if (self.navigationController.viewControllers.count == 1) {
            [self showLeftBarButtonItemWithImage:@"nav_down" target:self action:@selector(handleBtnBackClicked)];
        }else{
            [self showLeftBarButtonItemWithImage:@"nav_back" target:self action:@selector(handleBtnBackClicked)];
        }
    }else{
        [self showLeftBarButtonItemWithImage:@"" target:nil action:nil];
    
    }
    
}

-(void)handleBtnBackClicked{
    
    if (self.navigationController.viewControllers.count == 1) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
   

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
