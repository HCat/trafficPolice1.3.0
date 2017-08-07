//
//  ListHomeVC.m
//  移动采集
//
//  Created by hcat on 2017/7/18.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "ListHomeVC.h"
#import "UserModel.h"
#import "IllegalListVC.h"

@interface ListHomeVC ()

@property (weak, nonatomic) IBOutlet UIView *v_permission;

@property (nonatomic,strong) NSArray *arr_menus;

@end

@implementation ListHomeVC


- (instancetype)init{
    
    if (self = [super init]) {
        
        [self initPageMenu];
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"移动处理";
    
    if (self.arr_menus.count == 0) {
        self.v_permission.hidden = NO;
    
    }else{
        self.v_permission.hidden = YES;

    }
    
}

#pragma mark - initPageMenu

- (void)initPageMenu{
    
    NSMutableArray *t_arr = [NSMutableArray array];
    
    if ([UserModel isPermissionForIllegalList]) {
        IllegalListVC *t_vc = [IllegalListVC new];
        t_vc.illegalType = IllegalTypePark;
        t_vc.title = @"违停";
        [t_arr addObject:t_vc];
    
    }
    
    if ([UserModel isPermissionForThroughList]) {
        IllegalListVC *t_vc = [IllegalListVC new];
        t_vc.illegalType = IllegalTypeThrough;
        t_vc.title = @"闯禁令";
        [t_arr addObject:t_vc];
      
    }
    
    if ([UserModel isPermissionForAccidentList]) {
        UIViewController *t_vc = [UIViewController new];
        t_vc.title = @"事故";
        [t_arr addObject:t_vc];
    
    }
    
    if ([UserModel isPermissionForFastAccidentList]) {
        UIViewController *t_vc = [UIViewController new];
        t_vc.title = @"快处";
        [t_arr addObject:t_vc];
        
        
    }
    
    self.arr_menus = t_arr;
    
    if (t_arr.count == 0) {
        
        return;
    }
    
    NSArray *arr_controllers = [NSArray arrayWithArray:t_arr];
    NSDictionary *dic_options = @{LRPageMenuOptionUseMenuLikeSegmentedControl:@(YES),
                                  LRPageMenuOptionSelectedTitleColor:UIColorFromRGB(0xffffff),
                                  LRPageMenuOptionUnselectedTitleColor:UIColorFromRGB(0x444444),
                                  LRPageMenuOptionSelectionIndicatorColor:[UIColor clearColor],
                                  LRPageMenuOptionSelectionViewColor:DefaultBtnColor,
                                  LRPageMenuOptionScrollMenuBackgroundColor:[UIColor whiteColor],
                                  LRPageMenuOptionSelectionIndicatorWidth:@(80),
                                  LRPageMenuOptionBottomMenuHairlineColor:[UIColor clearColor],
                                  LRPageMenuOptionSelectedTitleFont:[UIFont systemFontOfSize:15.f],
                                  LRPageMenuOptionUnselectedTitleFont:[UIFont systemFontOfSize:14.f],
                                  LRPageMenuOptionScrollAnimationDurationOnMenuItemTap:@(0)
                                  };
    _pageMenu = [[LRPageMenu alloc] initWithViewControllers:arr_controllers frame:CGRectMake(0.0, 0.0, ScreenWidth, self.view.frame.size.height) options:dic_options];
    
    [self.view addSubview:_pageMenu.view];
    
}



#pragma mark - AKTabBar Method

- (NSString *)tabImageName{
    return @"tabbar_list_n";
}

- (NSString *)tabSelectedImageName{
    return @"tabbar_list_h";
}

- (NSString *)tabTitle{
    return NSLocalizedString(@"列表", nil);
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    LxPrintf(@"ListHomeVC dealloc");
    
}


@end
