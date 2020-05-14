//
//  TaskFlowsContainerVC.m
//  移动采集
//
//  Created by hcat-89 on 2020/3/3.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "TaskFlowsContainerVC.h"
#import "LRPageMenu.h"
#import "TaskFlowsListVC.h"


@interface TaskFlowsContainerVC ()

@property (nonatomic,strong) LRPageMenu *pageMenu;

@end

@implementation TaskFlowsContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPageMenu];
    
}


#pragma mark - configUI

- (void)initPageMenu{
    
    if (_pageMenu) {
        [_pageMenu.view removeFromSuperview];
    }
    
    NSMutableArray *t_arr = [NSMutableArray array];
    
    TaskFlowsListViewModels * viewModel_1 = [[TaskFlowsListViewModels alloc] init];
    viewModel_1.type = @1;
    TaskFlowsListVC * parkingCarImageVC = [[TaskFlowsListVC alloc] initWithViewModel:viewModel_1];
    parkingCarImageVC.title = @"指派给我的";
    [t_arr addObject:parkingCarImageVC];
    
    TaskFlowsListViewModels * viewModel_2 = [[TaskFlowsListViewModels alloc] init];
    viewModel_2.type = @2;
    TaskFlowsListVC * parkingCarInfoVC = [[TaskFlowsListVC alloc] initWithViewModel:viewModel_2];
    parkingCarInfoVC.title = @"我创建的";
    [t_arr addObject:parkingCarInfoVC];
    
    NSArray *arr_controllers = [NSArray arrayWithArray:t_arr];
    NSDictionary *dic_options = @{LRPageMenuOptionUseMenuLikeSegmentedControl:@(YES),
                                  LRPageMenuOptionAddBottomMenuHairline:@(YES),
                                  LRPageMenuOptionSelectedTitleColor:DefaultMenuSelectedColor,
                                  LRPageMenuOptionUnselectedTitleColor:DefaultMenuUnSelectedColor,
                                  LRPageMenuOptionSelectionIndicatorColor:DefaultMenuSelectedColor,
                                  LRPageMenuOptionScrollMenuBackgroundColor:[UIColor whiteColor],
                                  LRPageMenuOptionSelectionIndicatorWidth:@(80),
                                  LRPageMenuOptionBottomMenuHairlineColor:UIColorFromRGB(0xb5bdd2),
                                  LRPageMenuOptionSelectedTitleFont:[UIFont systemFontOfSize:15.f],
                                  LRPageMenuOptionUnselectedTitleFont:[UIFont systemFontOfSize:14.f],
                                  
                                  };
    _pageMenu = [[LRPageMenu alloc] initWithViewControllers:arr_controllers frame:CGRectMake(0.0, 0.0, ScreenWidth, self.view.frame.size.height) options:dic_options];
    
    [self.view addSubview:_pageMenu.view];
    
    
}   


- (void)dealloc{
    LxPrintf(@"TaskFlowsContainerVC dealloc");
}

@end
