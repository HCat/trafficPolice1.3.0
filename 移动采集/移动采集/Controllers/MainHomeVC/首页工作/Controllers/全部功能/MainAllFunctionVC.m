//
//  MainAllFunctionVC.m
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "MainAllFunctionVC.h"
#import "LRPageMenu.h"
#import "MainFunctionListVC.h"

@interface MainAllFunctionVC ()

@property (nonatomic,strong) LRPageMenu *pageMenu;

@end

@implementation MainAllFunctionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部功能";
    [self initPageMenu];
}

- (void)initPageMenu{
    
    NSMutableArray *t_arr = [NSMutableArray array];
    
    MainFunctionListVC *illegalList = [[MainFunctionListVC alloc] init];
    illegalList.title = @"违法采集";
    illegalList.arr_content = self.arr_illegal;
    [t_arr addObject:illegalList];
    
    MainFunctionListVC *accidentList = [[MainFunctionListVC alloc] init];
    accidentList.title = @"事故纠纷";
    accidentList.arr_content = self.arr_accident;
    [t_arr addObject:accidentList];
    
    MainFunctionListVC *policeList = [[MainFunctionListVC alloc] init];
    policeList.title = @"警务管理";
    policeList.arr_content = self.arr_policeMatter;
    [t_arr addObject:policeList];
    
   
    NSArray *arr_controllers = [NSArray arrayWithArray:t_arr];
    NSDictionary *dic_options = @{LRPageMenuOptionUseMenuLikeSegmentedControl:@(YES),
                                  LRPageMenuOptionSelectedTitleColor:DefaultMenuSelectedColor,
                                  LRPageMenuOptionUnselectedTitleColor:DefaultMenuUnSelectedColor,
                                  LRPageMenuOptionSelectionIndicatorColor:DefaultMenuSelectedColor,
                                  LRPageMenuOptionScrollMenuBackgroundColor:[UIColor whiteColor],
                                  LRPageMenuOptionSelectionIndicatorWidth:@(80),
                                  LRPageMenuOptionBottomMenuHairlineColor:[UIColor clearColor],
                                  LRPageMenuOptionSelectedTitleFont:[UIFont systemFontOfSize:15.f],
                                  LRPageMenuOptionUnselectedTitleFont:[UIFont systemFontOfSize:14.f],
                                  
                                  };
    _pageMenu = [[LRPageMenu alloc] initWithViewControllers:arr_controllers frame:CGRectMake(0.0, 0.0, ScreenWidth, self.view.frame.size.height) options:dic_options];
    
    [self.view addSubview:_pageMenu.view];
    
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"MainAllFunctionVC dealloc");
    
}

@end
