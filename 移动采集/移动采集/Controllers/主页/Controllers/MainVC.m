//
//  MainVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/10.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "MainVC.h"
#import <JXCategoryView.h>
#import "JXPagerListRefreshView.h"
#import "MainHeaderView.h"
#import "MainViewModel.h"

#import "MainCommonVC.h"
#import "MainAllVC.h"
#import "UserCenterVC.h"
#import "UserModel.h"
#import "AddressBookHomeVC.h"
#import "SignInVC.h"
#import "schedulVC.h"
#import "MessageHomeVC.h"
#import <UIImageView+WebCache.h>


@interface MainVC () <JXCategoryViewDelegate, JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, strong) JXCategoryTitleView * categoryView;
@property (nonatomic, strong) MainHeaderView * headerView;
@property (nonatomic, strong) MainViewModel * viewModel;
@property (nonatomic, strong) JXPagerListRefreshView *pagerView;

@property (weak, nonatomic) IBOutlet UIButton *btn_contact;
@property (weak, nonatomic) IBOutlet UIButton *btn_message;
@property (weak, nonatomic) IBOutlet UIButton *btn_schedul;
@property (weak, nonatomic) IBOutlet UIButton *btn_Sign;


@property (weak, nonatomic) IBOutlet UILabel *lb_schedul;

@property (weak, nonatomic) IBOutlet UIView *v_bottom;



@end

@implementation MainVC

- (instancetype)init{
    
    if (self = [super init]) {
        self.viewModel = [[MainViewModel alloc] init];
    }
    
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [ShareValue sharedDefault].makeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    // Do any additional setup after loading the view from its nib.
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)lr_configUI{
    
    @weakify(self);
    
    self.zx_hideBaseNavBar = YES;
    self.lb_message.layer.masksToBounds = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[ShareValue sharedDefault] roadModels];
    
    self.viewModel.titles = @[@"常用功能",@"全部应用"];
    
    self.headerView   = [MainHeaderView initCustomView];
    [[self.headerView.btn_userInfo rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        UserCenterVC * vc = [[UserCenterVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    }];
    
    self.headerView.lb_name.text = [UserModel getUserModel].realName;
    self.headerView.lb_phone.text =  [UserModel getUserModel].phone;
    self.headerView.lb_zhongdui.text = [NSString stringWithFormat:@"%@%@",[UserModel getUserModel].orgName,[UserModel getUserModel].departmentName];
    
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 54, SCREEN_WIDTH-80, 54)];
    _categoryView.titles = self.viewModel.titles;
    
    self.categoryView.titles = self.viewModel.titles;
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.averageCellSpacingEnabled = NO;
    self.categoryView.delegate = self;
    self.categoryView.cellSpacing = 35;
    self.categoryView.contentEdgeInsetLeft = 25;
    self.categoryView.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    
    self.categoryView.titleSelectedColor = UIColorFromRGB(0x333333);
    self.categoryView.titleColor = UIColorFromRGB(0x999999);
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.titleLabelZoomScale = 1.3;

    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = UIColorFromRGB(0x4495FF);
    lineView.indicatorCornerRadius = 0;
    lineView.indicatorWidth = 30;
    lineView.indicatorHeight = 4;
    self.categoryView.indicators = @[lineView];
    
    UIView * line =  [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xEEEEEE);
    [self.categoryView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.categoryView);
        make.height.equalTo(@1.0);
    }];
    
    [self.categoryView bringSubviewToFront:line];

    //如果不想要下拉刷新的效果，改用JXPagerView类即可
    self.pagerView = [[JXPagerListRefreshView alloc] initWithDelegate:self];
    self.pagerView.pinSectionHeaderVerticalOffset = Height_NavBar+20;
    self.pagerView.mainTableView.gestureDelegate = self;
    [self.view addSubview:self.pagerView];
    
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.v_bottom.mas_top);
        
    }];

    
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
    
    [[self.btn_contact rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        AddressBookHomeVC *t_vc_addressBook = [AddressBookHomeVC new];
        [self.navigationController pushViewController:t_vc_addressBook animated:YES];

    }];
    
    
    [[self.btn_schedul rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        schedulVC *t_vc = [schedulVC new];
        [self.navigationController pushViewController:t_vc animated:YES];

    }];
    
    [[self.btn_message rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        [ShareValue sharedDefault].makeNumber = 0;
        
        MessageHomeVC * vc = [[MessageHomeVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    }];
    
    [[self.btn_Sign rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
           
        SignInVC *t_vc = [[SignInVC alloc] init];
        [self.navigationController pushViewController:t_vc animated:YES];

    }];
    
    
}

- (void)lr_bindViewModel{
    
    
    //@weakify(self);
    
    
    if ([[UserModel getUserModel].photoUrl isKindOfClass:[NSNull class]]) {
        [self.headerView.imageV_user setImage:[UIImage imageNamed:@"main_image_user"]];
    }else{
        [self.headerView.imageV_user sd_setImageWithURL:[NSURL URLWithString:self.viewModel.photoUrl] placeholderImage:[UIImage imageNamed:@"main_image_user"]];
    }

//    [self.viewModel.command_userIcon.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
//        @strongify(self);
//
//        if([x isEqualToString:@"加载成功"]){
//
//
//
//        }
//
//    }];
    
    //[self.viewModel.command_userIcon execute:nil];
    
}


#pragma mark - JXPagerViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headerView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    
    if (IS_IPHONE_X_MORE) {
        return 160+24;
    }else{
        return 160;
    }
    
    
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 54;

}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.viewModel.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    
    if (index == 0) {
        MainCommonVC *list = [[MainCommonVC alloc] init];
        return list;
    }else{
        MainAllVC * list = [[MainAllVC alloc] init];
        return list;
    }
    
}

- (void)pagerView:(JXPagerView *)pagerView mainTableViewDidScroll:(UIScrollView *)scrollView {
    [self.headerView scrollViewDidScroll:scrollView.contentOffset.y];
}

- (void)pagerView:(JXPagerView *)pagerView mainTableViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.headerView scrollViewWillBeginDragging:scrollView.contentOffset.y];
    
}


#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
   
}

-(void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {

}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {

}

#pragma mark - JXPagerMainTableViewGestureDelegate

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([self checkIsNestContentScrollView:(UIScrollView *)gestureRecognizer.view] || [self checkIsNestContentScrollView:(UIScrollView *)otherGestureRecognizer.view] || otherGestureRecognizer == self.categoryView.collectionView.panGestureRecognizer) {
        //如果交互的是嵌套的contentScrollView，证明在左右滑动，就不允许同时响应
        return NO;
    }
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (BOOL)checkIsNestContentScrollView:(UIScrollView *)scrollView {
    for (MainAllVC *list in self.pagerView.validListDict.allValues) {
        if (list.contentScrollView == scrollView) {
            return YES;
        }
    }
    return NO;
}



@end
