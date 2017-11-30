//
//  JointEnforceVC.m
//  移动采集
//
//  Created by hcat on 2017/11/29.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "JointEnforceVC.h"

@interface JointEnforceVC ()

@property(nonatomic,weak) IBOutlet UIView *v_bottom;
@property (weak, nonatomic) IBOutlet UIButton *btn_bottom;
@property(nonatomic,weak) IBOutlet UITableView *tableView;

@end

@implementation JointEnforceVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _v_bottom.layer.shadowColor = UIColorFromRGB(0x444444).CGColor;//shadowColor阴影颜色
    _v_bottom.layer.shadowOffset = CGSizeMake(0,-2);
    _v_bottom.layer.shadowOpacity = 0.1;
    _v_bottom.layer.shadowRadius = 2;
    
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"JointEnforceVC dealloc");
}

@end
