//
//  MainAllVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/11.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "MainAllVC.h"
#import "MainAllViewModel.h"
#import <JXCategoryView/JXCategoryView.h>
#import "JXCategoryTitleBackgroundView.h"
#import "MainAllListView.h"
#import "MainAllListView.h"

@interface MainAllVC ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) JXCategoryTitleBackgroundView *categoryView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UIScrollView *currentListView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;


@property (nonatomic, strong) MainAllViewModel * viewModel;


@end

@implementation MainAllVC


- (instancetype)init{
    
    if (self = [super init]) {
        self.viewModel = [[MainAllViewModel alloc] init];
    }
    
    return self;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self lr_configUI];
    [self lr_bindViewModel];
}

- (void)lr_configUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.categoryView = [[JXCategoryTitleBackgroundView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54)];
    self.categoryView.titles = @[@""];
    self.categoryView.delegate = self;
    self.categoryView.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    self.categoryView.titleSelectedColor = UIColorFromRGB(0xffffff);
    self.categoryView.titleColor = UIColorFromRGB(0x4495FF);
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@54);
    }];
    
    
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
    [self.view addSubview:self.listContainerView];
    self.contentScrollView = self.listContainerView.scrollView;

    self.categoryView.listContainer = self.listContainerView;
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(54);
    }];
    
}


- (void)lr_bindViewModel{
    
    @weakify(self);
    

    [self.viewModel.command_menu.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
    
        if([x isEqualToString:@"加载成功"]){
            
            if (self.viewModel.arr_menu.count > 0) {
                NSMutableArray * t_arr =@[].mutableCopy;
                
                for (MenuTypeModel * model in self.viewModel.arr_menu) {
                    [t_arr addObject:model.name];
                }
                
                self.categoryView.titles = t_arr;
                self.categoryView.defaultSelectedIndex = 0;
                [self.categoryView reloadData];
            
            }
            
        }else if([x isEqualToString:@"加载失败"]){
            self.categoryView.titles = @[];
            self.categoryView.defaultSelectedIndex = 0;
            [self.categoryView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.viewModel.command_menu execute:nil];
            });
            
        }
        
    }];
    
    [self.viewModel.command_menu execute:nil];
    
}


#pragma  mark - JXPagerViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.currentListView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listScrollViewWillResetContentOffset {
    //当前的listScrollView需要重置的时候，就把所有列表的contentOffset都重置了
    for (MainAllListView *list in self.listContainerView.validListDict.allValues) {
        list.collectionView.contentOffset = CGPointZero;
    }
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //根据选中的下标，实时更新currentListView
    MainAllListView *list = (MainAllListView *)self.listContainerView.validListDict[@(index)];
    self.currentListView = list.collectionView;
}

#pragma mark - JXCategoryListContainerViewDelegate

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    if (self.viewModel.arr_menu.count == 0) {
        return 1;
    }else{
        return self.viewModel.arr_menu.count;
    }
    
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    if (self.viewModel.arr_menu.count == 0) {
        MenuTypeModel * t_model = [[MenuTypeModel alloc] init];
        MainAllListViewModel * viewModel = [[MainAllListViewModel alloc] init];
        viewModel.menuType = t_model.type;
        MainAllListView * view = [[MainAllListView alloc] initWithViewModel:viewModel];
        view.scrollCallback = ^(UIScrollView *scrollView) {
            weakSelf.scrollCallback(scrollView);
        };
        self.currentListView = view.collectionView;
        return view;
    }
    MenuTypeModel * t_model = self.viewModel.arr_menu[index];
    MainAllListViewModel * viewModel = [[MainAllListViewModel alloc] init];
    viewModel.menuType = t_model.type;
    MainAllListView * view = [[MainAllListView alloc] initWithViewModel:viewModel];
    view.scrollCallback = ^(UIScrollView *scrollView) {
        weakSelf.scrollCallback(scrollView);
    };
    self.currentListView = view.collectionView;
    return view;

}


@end
