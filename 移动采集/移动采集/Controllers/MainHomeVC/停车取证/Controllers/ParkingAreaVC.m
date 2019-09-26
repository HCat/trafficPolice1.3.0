//
//  ParkingAreaVC.m
//  移动采集
//
//  Created by hcat on 2019/7/26.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingAreaVC.h"
#import "ParkingForensicsAPI.h"
#import <MJRefresh.h>
#import <PureLayout.h>
#import "UITableView+Lr_Placeholder.h"
#import "PFNavigationDropdownMenu.h"
#import "NetWorkHelper.h"
#import "ParkingAreaCell.h"
#import "ParkingAreaViewModel.h"
#import "ParkingAreaDetailVC.h"

@interface ParkingAreaVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) PFNavigationDropdownMenu *menuView;
@property(nonatomic,strong) ParkingAreaViewModel * viewModel;



@end

@implementation ParkingAreaVC

- (instancetype)init{
    
    if (self = [super init]) {
        self.viewModel = [[ParkingAreaViewModel alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parkingForensicsSuccess) name:NOTIFICATION_PARKINGFORENSICS_SUCCESS object:nil];
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel];
    
    [self.viewModel.groupCommand execute:nil];
    
    
}


- (void)configUI{
    
    @weakify(self);
    
    self.title = @"片区";
    
    self.tableView.isNeedPlaceholderView = YES;
    self.tableView.str_placeholder = @"暂无车位";
    self.tableView.firstReload = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"ParkingAreaCell" bundle:nil] forCellReuseIdentifier:@"ParkingAreaCellID"];
    self.tableView.estimatedRowHeight = 72.5f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    //点击重新加载之后的处理
    [self.tableView setReloadBlock:^{
        @strongify(self);
        self.tableView.isNetAvailable = NO;
        [self.tableView.mj_header beginRefreshing];
    }];
    
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        @strongify(self);
        self.tableView.isNetAvailable = NO;
        [self.tableView.mj_header beginRefreshing];
    };
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    [header setTitle:@"下拉查询" forState:MJRefreshStateIdle];
    [header setTitle:@"松手开始查询" forState:MJRefreshStatePulling];
    [header setTitle:@"查询中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"— 没有更多内容了 —" forState:MJRefreshStateNoMoreData];
    
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    footer.stateLabel.textColor = UIColorFromRGB(0xa6a6a6);
    self.tableView.mj_footer = footer;
    self.tableView.mj_footer.automaticallyHidden = YES;
    

}


#pragma mark - set

- (void)setUpDropdownMenu:(NSArray *)items{
    
    @weakify(self);
    
    NSMutableArray *items_t = [NSMutableArray array];
    
    for (int i = 0; i < items.count; i++) {
        
        ParkingAreaModel * model = items[i];
        [items_t addObject:model.parklotname];
        
    }
    
    if (_menuView) {
        [_menuView removeFromSuperview];
        _menuView = nil;
    }

    _menuView = [[PFNavigationDropdownMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)
                                                          title:items_t.firstObject
                                                          items:items_t
                                                  containerView:self.view];
    _menuView.backgroundColor = [UIColor whiteColor];
    
    _menuView.cellHeight = 50;
    _menuView.cellBackgroundColor = [UIColor whiteColor];
    _menuView.cellSelectionColor = [UIColor whiteColor];
    _menuView.cellTextLabelColor = DefaultTextColor;
    _menuView.cellTextLabelFont = [UIFont systemFontOfSize:14.f];
    _menuView.arrowImage = [UIImage imageNamed:@"icon_dropdown_down"];
    _menuView.checkMarkImage = [UIImage imageNamed:@"icon_dropdown_selected"];
    _menuView.arrowPadding = 15;
    _menuView.animationDuration = 0.5f;
    _menuView.maskBackgroundColor = [UIColor blackColor];
    _menuView.maskBackgroundOpacity = 0.3f;
    
    _menuView.didSelectItemAtIndexHandler = ^(NSUInteger indexPath){
        NSLog(@"Did select item at index: %ld", indexPath);
        @strongify(self);
        ParkingAreaModel * model = self.viewModel.arr_group[indexPath];
        self.viewModel.parklotid = model.pkParklotId;
        [self.tableView.mj_header beginRefreshing];
        
    };
    
    [self.view addSubview:_menuView];
    [_menuView configureForAutoLayout];
    [_menuView autoSetDimension:ALDimensionHeight toSize:44];
    
    [_menuView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    
    [_menuView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
    [_menuView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:0];
    [self.view layoutIfNeeded];
    
}

#pragma mark - 加载新数据

- (void)reloadData{
    self.viewModel.index = @1;
    [self.viewModel.requestCommand execute:nil];
    
}

- (void)loadData{
    [self.viewModel.requestCommand execute:nil];
}
#pragma mark - 绑定ViewModels

- (void)bindViewModel{
    
    @weakify(self);
    
    [self.viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([x isEqualToString:@"请求最后一条成功"]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else if([x isEqualToString:@"加载失败"]){
            
            Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
            NetworkStatus status = [reach currentReachabilityStatus];
            if (status == NotReachable) {
                if (self.viewModel.arr_content.count > 0) {
                    [self.viewModel.arr_content removeAllObjects];
                }
                self.tableView.isNetAvailable = YES;
                [self.tableView reloadData];
            }
            
            
        }
        
        [self.tableView reloadData];
        
    }];
    
    [self.viewModel.groupCommand.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        if([x isEqualToString:@"加载成功"]){
            
            [self setUpDropdownMenu:self.viewModel.arr_group];
            ParkingAreaModel * model = self.viewModel.arr_group[0];
            self.viewModel.parklotid = model.pkParklotId;
            [self.tableView.mj_header beginRefreshing];
            
        }
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.arr_content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ParkingOccPercentModel *itemModel = self.viewModel.arr_content[indexPath.row];
    
    ParkingAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkingAreaCellID" forIndexPath:indexPath];
    cell.model = itemModel;
    
    return cell;
    
}

#pragma - mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ParkingOccPercentModel *itemModel = self.viewModel.arr_content[indexPath.row];
    
    ParkingAreaDetailViewModel * viewModel = [[ParkingAreaDetailViewModel alloc] init];
    viewModel.placenum = itemModel.placenum;
    viewModel.parkplaceId = itemModel.pkParkplaceId;
    
    ParkingAreaDetailVC * vc = [[ParkingAreaDetailVC alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}


#pragma mark - notification

- (void)parkingForensicsSuccess{
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)dealloc{
    LxPrintf(@"ParkingAreaVC dealloc");
     [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_PARKINGFORENSICS_SUCCESS object:nil];
}

@end
