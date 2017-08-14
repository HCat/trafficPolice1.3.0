//
//  AccidentRemarkListVC.m
//  移动采集
//
//  Created by hcat on 2017/8/14.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AccidentRemarkListVC.h"

@interface AccidentRemarkListVC ()

@end

@implementation AccidentRemarkListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"备注";
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    LxPrintf(@"AccidentRemarkListVC dealloc");

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
