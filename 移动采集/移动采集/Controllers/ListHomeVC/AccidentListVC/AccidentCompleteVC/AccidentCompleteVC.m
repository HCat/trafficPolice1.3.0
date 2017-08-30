//
//  AccidentCompleteVC.m
//  移动采集
//
//  Created by hcat on 2017/8/29.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AccidentCompleteVC.h"
#import "LRPageMenu.h"
#import "AccidentDetailVC.h"
#import "AccidentRemarkListVC.h"
#import "AccidentProcessResultVC.h"

@interface AccidentCompleteVC ()

@property (nonatomic,strong) LRPageMenu *pageMenu;
@property (nonatomic,strong) NSArray *arr_menus;

@end

@implementation AccidentCompleteVC


- (instancetype)init{
    
    if (self = [super init]) {
        
        
    }
    
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (_accidentType == AccidentTypeAccident) {
        self.title = @"事故详情";
    }else if(_accidentType == AccidentTypeFastAccident){
        self.title = @"快处详情";
    }
    
    [self initPageMenu];
    
}


#pragma mark - initPageMenu

- (void)initPageMenu{
    
    NSMutableArray *t_arr = [NSMutableArray array];
    
    AccidentDetailVC *accidentDetailVC = [[AccidentDetailVC alloc] init];
    accidentDetailVC.accidentType = _accidentType;
    accidentDetailVC.accidentId = _accidentId;
    [t_arr addObject:accidentDetailVC];
    
    AccidentProcessResultVC *accidentProcessResultVC = [[AccidentProcessResultVC alloc] init];
    accidentProcessResultVC.title = @"处理结果";
    accidentProcessResultVC.accidentType = _accidentType;
    accidentProcessResultVC.accidentId = _accidentId;
    [t_arr addObject:accidentProcessResultVC];
    
    
    AccidentRemarkListVC *accidentRemarkListVC =[[AccidentRemarkListVC alloc] init];
    accidentRemarkListVC.accidentId = _accidentId;
    accidentRemarkListVC.isHandle = YES;
    accidentRemarkListVC.title = @"备注信息";
    [t_arr addObject:accidentRemarkListVC];
    
    
    self.arr_menus = t_arr;
    
    if (t_arr.count == 0) {
        
        return;
    }
    
    NSArray *arr_controllers = [NSArray arrayWithArray:t_arr];
    NSDictionary *dic_options = @{LRPageMenuOptionUseMenuLikeSegmentedControl:@(YES),
                                  LRPageMenuOptionAddBottomMenuHairline:@(YES),
                                  LRPageMenuOptionSelectedTitleColor:UIColorFromRGB(0x253254),
                                  LRPageMenuOptionUnselectedTitleColor:UIColorFromRGB(0xb5bdd2),
                                  LRPageMenuOptionSelectionIndicatorColor:DefaultBtnColor,
                                  LRPageMenuOptionScrollMenuBackgroundColor:[UIColor whiteColor],
                                  LRPageMenuOptionSelectionIndicatorWidth:@(80),
                                  LRPageMenuOptionBottomMenuHairlineColor:UIColorFromRGB(0xb5bdd2),
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

    LxPrintf(@"AccidentCompleteVC dealloc");

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
