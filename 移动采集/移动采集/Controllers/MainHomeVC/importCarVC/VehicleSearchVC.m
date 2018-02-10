//
//  VehicleSearchVC.m
//  移动采集
//
//  Created by hcat on 2017/9/8.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "VehicleSearchVC.h"
#import "UIButton+Block.h"
#import "VehicleDetailVC.h"

@interface VehicleSearchVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet UIButton *btn_back;
@property (weak, nonatomic) IBOutlet UIButton *btn_search;

@end

@implementation VehicleSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tf_search becomeFirstResponder];
    [_btn_back setEnlargeEdgeWithTop:20 right:20 bottom:10 left:20];
    [_btn_search setEnlargeEdgeWithTop:20 right:20 bottom:10 left:20];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
    
}


#pragma mark - 按钮事件

- (IBAction)handleBtnBackClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)handleBtnSearchClicked:(id)sender {
    
    if ([ShareFun validateCarNumber:_tf_search.text]) {
        
        VehicleDetailVC * t_vc = [[VehicleDetailVC alloc] init];
        t_vc.type = VehicleRequestTypeCarNumber;
        t_vc.NummberId = _tf_search.text;
        [self.navigationController pushViewController:t_vc animated:YES];
        
    }else{
        
        [LRShowHUD showError:@"请输入正确的车牌号" duration:1.5f];
    }
    
    
    
}

#pragma mark -textField

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    
    if ([ShareFun validateCarNumber:_tf_search.text]) {

        VehicleDetailVC * t_vc = [[VehicleDetailVC alloc] init];
        t_vc.type = VehicleRequestTypeCarNumber;
        t_vc.NummberId = _tf_search.text;
        [self.navigationController pushViewController:t_vc animated:YES];

    }else{

        [LRShowHUD showError:@"请输入正确的车牌号" duration:1.5f];
    }
    
    return YES;
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    LxPrintf(@"VehicleSearchVC dealloc");
    
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
