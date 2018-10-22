//
//  IllegalParkManageVC.m
//  移动采集
//
//  Created by hcat on 2018/9/25.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalParkManageVC.h"
#import "IllegalParkVC.h"
#import "CarInfoAddVC.h"
#import "IllegalParkUpListVC.h"
#import "UpCacheSettingVC.h"
#import "UpCacheHelper.h"
#import "UINavigationBar+BarItem.h"


@interface IllegalParkManageVC ()

@property (nonatomic,strong) UIViewController * firstVC;
@property (nonatomic,strong) IllegalParkUpListVC * illegalParkUpList;
@property (strong, nonatomic) IllegalParkManageViewModel * viewModel;
@property (nonatomic,strong) UILabel  * lb_unUpCount;

@end

@implementation IllegalParkManageVC

- (instancetype)initWithViewModel:(IllegalParkManageViewModel *)viewModel{
    self = [super init];
    if (self ) {
        _viewModel = viewModel;
        [[UpCacheHelper sharedDefault] stopAll];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildTitle];
    [self showRightBarButtonItemWithImage:@"nav_upCancel_setting" target:self action:@selector(showAutoUpCacheVC)];
    
    if ([_viewModel.arr_item[0] isEqualToString:@"车辆录入"]) {
        CarInfoAddVC * vc = [[CarInfoAddVC alloc] init];
        self.firstVC = vc;
    }else{
        IllegalParkVC * vc = [[IllegalParkVC alloc] init];
        vc.illegalType = _viewModel.illegalType;
        vc.subType = _viewModel.subType;
        self.firstVC = vc;
    }
   
    _firstVC.view.frame = self.view.bounds;
    [self addChildViewController:_firstVC];
    
    self.illegalParkUpList = [[IllegalParkUpListVC alloc] initWithViewModel:_viewModel.listViewModel];
    [self addChildViewController:_illegalParkUpList];
    
    [self.view addSubview:_firstVC.view];
    
}


#pragma mark - 初始化segmentControl

- (UISegmentedControl *)setupSegment{
    
    NSArray *items = _viewModel.arr_item;
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:items];
    segment.tintColor = [UIColor whiteColor];
    NSDictionary *dic = @{
                          //1.设置字体样式:例如黑体,和字体大小
                          NSFontAttributeName:[UIFont systemFontOfSize:14],
                          //2.字体颜色
                          NSForegroundColorAttributeName:[UIColor whiteColor]
                          };
    
    [segment setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    if (IS_IPHONE_5) {
        [segment setWidth:60 forSegmentAtIndex:0];
        [segment setWidth:60 forSegmentAtIndex:1];
        NSDictionary *dic = @{
                              //1.设置字体样式:例如黑体,和字体大小
                              NSFontAttributeName:[UIFont systemFontOfSize:11]};
        [segment setTitleTextAttributes:dic forState:UIControlStateNormal];
    }else {
        [segment setWidth:100 forSegmentAtIndex:0];
        [segment setWidth:100 forSegmentAtIndex:1];
    }

    segment.selectedSegmentIndex = 0;
    
    return segment;
}

#pragma mark - 初始化navigationItem.titleView

- (void)buildTitle{
    
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, Height_NavBar-Height_StatusBar)];

    UISegmentedControl *segment  = [self setupSegment];
    
    WS(weakSelf);
    
    [[segment rac_newSelectedSegmentIndexChannelWithNilValue:@0] subscribeNext:^(NSNumber * _Nullable x) {
        SW(strongSelf, weakSelf);
        
        switch ([x intValue]) {
            case 0:
                [strongSelf replaceFromOldViewController:strongSelf.illegalParkUpList toNewViewController:strongSelf.firstVC];
                break;
            case 1:
                [strongSelf replaceFromOldViewController:strongSelf.firstVC toNewViewController:strongSelf.illegalParkUpList];
                break;
            default:
                break;
        }
        
    }];
    
    segment.center = CGPointMake(titleView.frame.size.width/2, titleView.frame.size.height/2);
    
    [titleView addSubview:segment];
    
    
    self.lb_unUpCount = [[UILabel alloc] initWithFrame:CGRectMake(10,100,15,15)];
    _lb_unUpCount.backgroundColor = UIColorFromRGB(0xFF1E1E);
    _lb_unUpCount.textAlignment = NSTextAlignmentCenter;
    _lb_unUpCount.font = [UIFont systemFontOfSize:12.f];
    _lb_unUpCount.textColor = [UIColor whiteColor];
    _lb_unUpCount.layer.cornerRadius = 7.5f;
    _lb_unUpCount.layer.masksToBounds = YES;
    
    [titleView addSubview:_lb_unUpCount];
    _lb_unUpCount.hidden = YES;
   
    [RACObserve(self.viewModel, illegalCount) subscribeNext:^(NSNumber * x) {
        SW(strongSelf, weakSelf);
        if (x) {
            if ([x integerValue] == 0) {
                strongSelf.lb_unUpCount.hidden = YES;
            }else{
                strongSelf.lb_unUpCount.hidden = NO;
                strongSelf.lb_unUpCount.text = [x stringValue];
                [strongSelf.lb_unUpCount sizeToFit];
                CGRect frame = strongSelf.lb_unUpCount.frame;
                frame.size.width = frame.size.width + 10;
                frame.size.height = 15.f;
                strongSelf.lb_unUpCount.frame = frame;
                strongSelf.lb_unUpCount.center = CGPointMake(CGRectGetMaxX(segment.frame), CGRectGetMinY(segment.frame));
                
            }
        }
        
    }];

    self.navigationItem.titleView = titleView;
    
}


#pragma mark - 切换Controller

- (void)replaceFromOldViewController:(UIViewController *)oldVc toNewViewController:(UIViewController *)newVc{
    
    [self addChildViewController:newVc];
    newVc.view.frame = self.view.bounds;
    [self transitionFromViewController:oldVc toViewController:newVc duration:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newVc didMoveToParentViewController:self];
            [oldVc willMoveToParentViewController:nil];
            [oldVc removeFromParentViewController];
        }
    }];

}

- (void)showAutoUpCacheVC{
    UpCacheSettingVC * vc = [[UpCacheSettingVC alloc] init];
    vc.automaicUpCacheType = _viewModel.cacheType;
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - dealloc

- (void)dealloc{
    [[UpCacheHelper sharedDefault] startWithAll];
    LxPrintf(@"IllegalParkManageVC dealloc");
}

@end
