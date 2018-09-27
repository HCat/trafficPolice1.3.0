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
#import <ReactiveObjC.h>
#import <RACEXTScope.h>


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
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    self.illegalParkUpList = [[IllegalParkUpListVC alloc] init];
    _illegalParkUpList.view.frame = self.view.bounds;
    [self addChildViewController:_illegalParkUpList];
    
    [self.view addSubview:_firstVC.view];
    
    [self buildTitle];
    
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
    
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 64)];
    titleView.backgroundColor = [UIColor yellowColor];
    
    
    
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
    
    self.lb_unUpCount = [[UILabel alloc] initWithFrame:CGRectMake(10,100,15,15)];
    _lb_unUpCount.backgroundColor = UIColorFromRGB(0xFF1E1E);
    _lb_unUpCount.center = CGPointMake(CGRectGetMaxX(segment.frame), CGRectGetMinY(segment.frame));
    [titleView addSubview:_lb_unUpCount];
   
    @weakify(self);
    
    [RACObserve(self.viewModel, illegalCount) subscribeNext:^(NSNumber * x) {
        @strongify(self);
        if (x) {
            if ([x integerValue] == 0) {
                self.lb_unUpCount.hidden = YES;
            }else{
                self.lb_unUpCount.hidden = NO;
                self.lb_unUpCount.text = [x stringValue];
                [self.lb_unUpCount sizeToFit];
                
            }
        }
        
    }];

    self.navigationItem.titleView = titleView;
    
}


#pragma mark - 切换Controller

- (void)replaceFromOldViewController:(UIViewController *)oldVc toNewViewController:(UIViewController *)newVc{
    
    [self addChildViewController:newVc];
    [self transitionFromViewController:oldVc toViewController:newVc duration:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newVc didMoveToParentViewController:self];
            [oldVc willMoveToParentViewController:nil];
            [oldVc removeFromParentViewController];
        }
    }];
    
    
}

#pragma mark - dealloc

- (void)dealloc{
    
    NSLog(@"IllegalParkManageVC dealloc");
}

@end
