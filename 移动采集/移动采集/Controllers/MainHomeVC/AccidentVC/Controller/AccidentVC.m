//
//  AccidentVC.m
//  移动采集
//
//  Created by hcat on 2018/10/19.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "AccidentVC.h"
#import "UpCacheSettingVC.h"
#import "AccidentManageVC.h"
#import "AccidentUpListVC.h"
#import "UINavigationBar+BarItem.h"

@interface AccidentVC ()

@property (nonatomic,strong) AccidentManageVC * accidentManage;
@property (nonatomic,strong) AccidentUpListVC * accidentUpList;
@property (strong, nonatomic) AccidentViewModel * viewModel;
@property (nonatomic,strong) UILabel  * lb_unUpCount;

@end

@implementation AccidentVC

- (instancetype)initWithViewModel:(AccidentViewModel *)viewModel{
    self = [super init];
    if (self ) {
        _viewModel = viewModel;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildTitle];
    [self showRightBarButtonItemWithImage:@"nav_upCancel_setting" target:self action:@selector(showAutoUpCacheVC)];
    
    self.accidentManage = [[AccidentManageVC alloc] init];
    self.accidentManage.accidentType = _viewModel.accidentType;
    _accidentManage.view.frame = self.view.bounds;
    [self addChildViewController:_accidentManage];
    
    self.accidentUpList = [[AccidentUpListVC alloc] initWithViewModel:_viewModel.listViewModel];
    [self addChildViewController:_accidentUpList];
    
    [self.view addSubview:_accidentManage.view];
    
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
                [strongSelf replaceFromOldViewController:strongSelf.accidentUpList toNewViewController:strongSelf.accidentManage];
                break;
            case 1:
                [strongSelf replaceFromOldViewController:strongSelf.accidentManage toNewViewController:strongSelf.accidentUpList];
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


#pragma mark - 显示自动上传设置

- (void)showAutoUpCacheVC{
    UpCacheSettingVC * vc = [[UpCacheSettingVC alloc] init];
    vc.automaicUpCacheType = _viewModel.cacheType;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)dealloc{
    LxPrintf(@"AccidentManageVC dealloc");
    
}

@end
