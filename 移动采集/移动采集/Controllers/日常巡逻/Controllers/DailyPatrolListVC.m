//
//  DailyPatrolListVC.m
//  移动采集
//
//  Created by hcat-89 on 2020/1/8.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "DailyPatrolListVC.h"
#import "DailyPatrolListViewModel.h"
#import "DailyPatrolListCell.h"
#import <MJRefresh.h>
#import "UITableView+Lr_Placeholder.h"
#import "NetWorkHelper.h"
#import "DailyPatrolListModel.h"
#import "DailyPatrolDetailVC.h"

@interface DailyPatrolListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DailyPatrolListViewModel * viewModel;


@end

@implementation DailyPatrolListVC

- (instancetype)init{
    
    if (self = [super init]) {
        self.viewModel = [[DailyPatrolListViewModel alloc] init];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)lr_configUI{
    self.title = @"日常巡逻";
    
    @weakify(self);
    self.view.backgroundColor = UIColorFromRGB(0xF0F4F5);
    self.tableView.isNeedPlaceholderView = YES;
    self.tableView.str_placeholder = @"暂无日常巡逻";
    self.tableView.firstReload = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"DailyPatrolListCell" bundle:nil] forCellReuseIdentifier:@"DailyPatrolListCellID"];
    
    self.tableView.estimatedRowHeight = 44.0;
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
    
}

- (void)lr_bindViewModel{
    
    @weakify(self);
    
    [self.viewModel.loadCommand.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        [self.tableView.mj_header endRefreshing];
    
        if([x isEqualToString:@"加载失败"]){
            
            if (self.viewModel.arr_data.count > 0) {
                [self.viewModel.arr_data removeAllObjects];
            }
            
            Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
            NetworkStatus status = [reach currentReachabilityStatus];
            if (status == NotReachable) {
                self.tableView.isNetAvailable = YES;
                [self.tableView reloadData];
            }
            
        }
        
        [self.tableView reloadData];
    
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}


- (void)reloadData{
    [self.viewModel.loadCommand execute:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.arr_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    DailyPatrolListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DailyPatrolListCellID" forIndexPath:indexPath];
   
    DailyPatrolListModel * model = self.viewModel.arr_data[indexPath.row];
    
    cell.model = model;
    
    return cell;
    
}

#pragma - mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DailyPatrolListModel * model = self.viewModel.arr_data[indexPath.row];
    
    DailyPatrolDetailViewModel * viewModel = [[DailyPatrolDetailViewModel alloc] init];
    viewModel.type = model.type;
    viewModel.shiftId = model.shiftId;
    viewModel.partrolId = model.partrolId;
    viewModel.shiftNum = model.shiftNum;
    
    DailyPatrolDetailVC * vc = [[DailyPatrolDetailVC alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}



#pragma mark - dealloc

- (void)dealloc{
    LxPrintf(@"DailyPatrolListVC dealloc");
}

@end
