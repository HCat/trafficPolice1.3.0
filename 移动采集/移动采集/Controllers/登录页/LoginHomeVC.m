//
//  LoginHomeVC.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "LoginHomeVC.h"

#import <AFNetworking.h>

#import "LoginAPI.h"
#import "CommonAPI.h"

#import "PhoneLoginVC.h"
#import "LoginDeveloperVC.h"



@interface LoginHomeVC ()

@property (weak, nonatomic) IBOutlet UIButton *btn_weixinLogin;

@property (weak, nonatomic) IBOutlet UIButton *btn_select;

@property (weak, nonatomic) IBOutlet UIButton *btn_clause;


@end

@implementation LoginHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.zx_hideBaseNavBar = YES;
    UITapGestureRecognizer*tapGesture_2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDevelopmentModel)];
    tapGesture_2.numberOfTapsRequired = 10;
    tapGesture_2.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGesture_2];
    
    @weakify(self);
    
    self.btn_select.selected = YES;
    
    [[self.btn_select rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        self.btn_select.selected = !self.btn_select.isSelected;
    
    }];
    
    [[self.btn_clause rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
    
    }];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark -

- (void)showDevelopmentModel{
    
    LoginDeveloperVC *vc = [[LoginDeveloperVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - buttonAction 


- (IBAction)weixinLoginAction:(id)sender {
    
    if (!self.btn_select.isSelected) {
        [LRShowHUD showError:@"请同意下方条款" duration:1.5f];
        return;
    }

    
    PhoneLoginVC *t_vc = [PhoneLoginVC new];
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void)dealloc{
    LxPrintf(@"LoginHomeVC dealloc");

}

@end
