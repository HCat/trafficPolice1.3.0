//
//  AccidentHandleVC.m
//  移动采集
//
//  Created by hcat on 2017/8/10.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AccidentHandleVC.h"

@interface AccidentHandleVC ()

@property (weak, nonatomic) IBOutlet UIButton *btn_change;
@property (weak, nonatomic) IBOutlet UIButton *btn_tip;
@property (weak, nonatomic) IBOutlet UIButton *btn_handle;



@end

@implementation AccidentHandleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConfigButtons];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    

}

#pragma mark - 配置按钮高亮背景色

- (void)setupConfigButtons{
    UIImage *image = [ShareFun imageWithColor:UIColorFromRGB(0xe7edf9) size:CGSizeMake(SCREEN_WIDTH/3, 44)];
    [_btn_change setBackgroundImage:image forState:UIControlStateHighlighted];
    [_btn_tip setBackgroundImage:image forState:UIControlStateHighlighted];
    [_btn_handle setBackgroundImage:image forState:UIControlStateHighlighted];
}

#pragma mark - 配置事故详情页面

- (void)setupAccidentDetailView{



}


#pragma mark - 按钮事件

#pragma mark - 修改按钮事件
- (IBAction)handleBtnChangeClicked:(id)sender {
    
    
}

#pragma mark - 备注按钮事件
- (IBAction)handleBtnTipClicked:(id)sender {
    
    
    
    
    
}

#pragma mark - 处理按钮事件
- (IBAction)handleBtnHandleClicked:(id)sender {
    
    
    
    
    
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    LxPrintf(@"AccidentHandleVC dealloc");

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
