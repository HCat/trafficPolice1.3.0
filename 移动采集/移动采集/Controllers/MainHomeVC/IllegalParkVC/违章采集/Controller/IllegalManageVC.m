//
//  IllegalManageVC.m
//  移动采集
//
//  Created by hcat on 2018/9/21.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalManageVC.h"

@interface IllegalManageVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation IllegalManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"IllegalManageVC dealloc");
    
}

@end
