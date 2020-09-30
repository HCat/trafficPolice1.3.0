//
//  ParkingCarDetailVC.m
//  移动采集
//
//  Created by hcat on 2019/9/23.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingCarDetailVC.h"
#import "LRPageMenu.h"
#import "ParkingCarImageVC.h"
#import "ParkingCarInfoVC.h"
#import "ParkingCarOperationVC.h"


@interface ParkingCarDetailVC ()

@property (nonatomic,strong) LRPageMenu *pageMenu;
@property (nonatomic,strong) ParkingCarDetailViewModel * viewModel;

@end

@implementation ParkingCarDetailVC

- (instancetype)initWithViewModel:(ParkingCarDetailViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
        
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    @weakify(self);
    
    [self.viewModel.command_detail.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
         [self initPageMenu];
        
        
        
    }];
    
    
}

#pragma mark - configUI

- (void)initPageMenu{
    
    if (_pageMenu) {
        [_pageMenu.view removeFromSuperview];
    }
    
    NSMutableArray *t_arr = [NSMutableArray array];
    
    ParkingCarImageVC * parkingCarImageVC = [[ParkingCarImageVC alloc] init];
    parkingCarImageVC.title = @"车辆照片";
    [t_arr addObject:parkingCarImageVC];
    
    ParkingCarInfoVC * parkingCarInfoVC = [[ParkingCarInfoVC alloc] init];
    parkingCarInfoVC.title = @"入库信息";
    [t_arr addObject:parkingCarInfoVC];
    
    ParkingCarOperationVC * parkingCarOperationVC = [[ParkingCarOperationVC alloc] init];
    parkingCarOperationVC.title = @"操作记录";
    [t_arr addObject:parkingCarOperationVC];
    
    if (t_arr.count == 0) {
        
        return;
    }
    
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

#pragma mark - bindViewModel



#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"ParkingCarDetailVC dealloc");
}


@end
