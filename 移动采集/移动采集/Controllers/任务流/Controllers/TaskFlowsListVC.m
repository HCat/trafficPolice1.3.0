//
//  TaskFlowsListVC.m
//  移动采集
//
//  Created by hcat-89 on 2020/3/3.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "TaskFlowsListVC.h"
#import <MJRefresh.h>
#import "UITableView+Lr_Placeholder.h"
#import "NetWorkHelper.h"

#import "TaskFlowsListCell.h"
#import "TaskFlowsDetailVC.h"
#import "TaskFlowsAddVC.h"
#import "TaskFlowsContainerVC.h"

@interface TaskFlowsListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) TaskFlowsListViewModels * viewModel;

@end

@implementation TaskFlowsListVC

- (instancetype)initWithViewModel:(TaskFlowsListViewModels *)viewModel{
    
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskFlowsChange) name:@"任务流处理成功" object:nil];
        self.viewModel = viewModel;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel];
    [self.tableView.mj_header beginRefreshing];
}

- (void)configUI{
    
    @weakify(self);
    
    self.view.backgroundColor = UIColorFromRGB(0xF0F4F5);
    
    self.tableView.isNeedPlaceholderView = YES;
    self.tableView.str_placeholder = @"暂无任务";
    self.tableView.firstReload = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskFlowsListCell" bundle:nil] forCellReuseIdentifier:@"TaskFlowsListCellID"];
    self.tableView.estimatedRowHeight = 110.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
      
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

#pragma mark - bindViewModel
- (void)bindViewModel{
    
    @weakify(self);
    
    [self.viewModel.command_loadList.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
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
    
    
    [RACObserve(self.viewModel, type) subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if ([x isEqualToNumber:@2]) {
            UIButton *t_button = [[UIButton alloc] init];
            [t_button setImage:[UIImage imageNamed:@"taskFlows_addAction"] forState:UIControlStateNormal];
            [[t_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                
                TaskFlowsAddVC * vc = [[TaskFlowsAddVC alloc] init];
                TaskFlowsContainerVC * t_vc = (TaskFlowsContainerVC *)[ShareFun findViewController:self.view withClass:[TaskFlowsContainerVC class]];
                [t_vc.navigationController pushViewController:vc animated:YES];
                
            }];
            [self.view addSubview:t_button];
            
            [t_button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@-15);
                make.bottom.equalTo(@-48);
            }];
        }
        
    }];
    
}

#pragma mark - 加载新数据

- (void)reloadData{
    self.viewModel.start = @0;
    [self.viewModel.command_loadList execute:nil];
    
}

- (void)loadData{
    [self.viewModel.command_loadList execute:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.arr_content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskFlowsListModel *itemModel = self.viewModel.arr_content[indexPath.row];
    
    TaskFlowsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskFlowsListCellID" forIndexPath:indexPath];
    cell.viewModel = itemModel;
    
    return cell;
    
}

#pragma - mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TaskFlowsListModel *itemModel = self.viewModel.arr_content[indexPath.row];
    
    TaskFlowsDetailViewModel * viewModel = [[TaskFlowsDetailViewModel alloc] init];
    viewModel.taskFlowsType = self.viewModel.type;
    viewModel.taskFlowsStatus = itemModel.status;
    viewModel.taskFlowsId = itemModel.taskFlowsId;
    TaskFlowsDetailVC * vc = [[TaskFlowsDetailVC alloc] initWithViewModel:viewModel];
    
    
    TaskFlowsContainerVC * t_vc = (TaskFlowsContainerVC *)[ShareFun findViewController:self.view withClass:[TaskFlowsContainerVC class]];
    [t_vc.navigationController pushViewController:vc animated:YES];
}

- (void)taskFlowsChange{
    
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - dealloc

- (void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"任务流处理成功" object:nil];
    LxPrintf(@"TaskFlowsListVC dealloc");
}
@end
