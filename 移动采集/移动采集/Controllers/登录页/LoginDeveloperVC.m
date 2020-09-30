//
//  LoginDeveloperVC.m
//  移动采集
//
//  Created by hcat on 2018/8/21.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "LoginDeveloperVC.h"
#import "CommonAPI.h"
#import "LoginDevelopListVC.h"

@interface LoginDeveloperVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf_password;
@property (weak, nonatomic) IBOutlet UIView *v_password;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image_top;

@property (nonatomic,strong) NSArray <PoliceOrgModel *> *arr_model;
@property (nonatomic,copy) NSString *passwords;

@end

@implementation LoginDeveloperVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"模式选择";
    self.zx_navBar.backgroundColor = [UIColor clearColor];
    self.image_top.constant = 0;
    
    _v_password.hidden = YES;
    [self requestDevelop];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - requestMethods

- (void)requestDevelop{
    WS(weakSelf);
    CommonPoliceOrgManger * manger = [[CommonPoliceOrgManger alloc] init];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        strongSelf.arr_model  = manger.commonReponse;
        
        if (strongSelf.arr_model && strongSelf.arr_model.count > 0) {
            strongSelf.passwords = [(PoliceOrgModel *)strongSelf.arr_model[0] password];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}


#pragma mark - buttonActions

- (IBAction)handleBtnNextClicked:(id)sender {
    
    if (self.passwords && [self.passwords isEqualToString:self.tf_password.text]) {
        
        LoginDevelopListVC * vc = [[LoginDevelopListVC alloc] init];
        vc.arr_data = _arr_model;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        [LRShowHUD showError:@"密码错误" duration:1.5f];
        
    }
    
    
}

- (IBAction)handleBtnDevelopClicked:(id)sender {
    
    _v_password.hidden = NO;
    
}

- (IBAction)handleBtnDevelopHideClicked:(id)sender {
    
    _v_password.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dealloc

- (void)dealloc{
    LxPrintf(@"LoginDeveloperVC dealloc");
    
}

@end
