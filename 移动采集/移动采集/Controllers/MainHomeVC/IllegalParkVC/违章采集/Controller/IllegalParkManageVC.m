//
//  IllegalParkManageVC.m
//  移动采集
//
//  Created by hcat on 2018/9/25.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalParkManageVC.h"
#import "IllegalParkVC.h"
#import "IllegalParkUpListVC.h"

@interface IllegalParkManageVC ()

@property (nonatomic,strong) IllegalParkVC * illegalPark;
@property (nonatomic,strong) IllegalParkUpListVC * illegalParkUpList;

@end

@implementation IllegalParkManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.illegalPark = [[IllegalParkVC alloc] init];
    
    
}

- (void)dealloc{
    
    NSLog(@"IllegalParkManageVC dealloc");
}

@end
