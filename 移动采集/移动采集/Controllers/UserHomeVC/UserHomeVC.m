//
//  UserHomeVC.m
//  移动采集
//
//  Created by hcat on 2017/7/18.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "UserHomeVC.h"
#import "UINavigationBar+BarItem.h"

#import "UserSetVC.h"
#import "UserModel.h"

#import "UserRecordVC.h"
#import "UserWatchVC.h"
#import "UserTaskListVC.h"


@interface UserHomeVC ()

@property (nonatomic,strong) NSArray *arr_menus;

@end

@implementation UserHomeVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isNeedShowLocation = NO;
        [self initPageMenu];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self showRightBarButtonItemWithImage:@"btn_setting" target:self action:@selector(handleBtnSettingClicked:)];
}


#pragma mark - initPageMenu

- (void)initPageMenu{
    
    NSMutableArray *t_arr = [NSMutableArray array];
    
    UserWatchVC *t_watchvc = [UserWatchVC new];
    t_watchvc.title = @"值班";
    [t_arr addObject:t_watchvc];
    
    UserTaskListVC *t_missionvc = [UserTaskListVC new];
    t_missionvc.title = @"任务";
    [t_arr addObject:t_missionvc];
    
    UserRecordVC *t_recordvc = [UserRecordVC new];
    t_recordvc.title = @"记录";
    [t_arr addObject:t_recordvc];
    
    self.arr_menus = t_arr;
    
    if (t_arr.count == 0) {
        
        return;
    }
    
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

#pragma mark - buttonMethods

- (IBAction)handleBtnSettingClicked:(id)sender {
    UserSetVC *userVC = [[UserSetVC alloc] init];
    [self.navigationController pushViewController:userVC animated:YES];
    
}

#pragma mark - AKTabBar Method

- (NSString *)tabImageName{
    return @"tabbar_user_n";
}

- (NSString *)tabSelectedImageName{
    return @"tabbar_user_h";
}

- (NSString *)tabTitle{
    return NSLocalizedString(@"我的", nil);
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    LxPrintf(@"UserHomeVC dealloc");
    
}

@end
