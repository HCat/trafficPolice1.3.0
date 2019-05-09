//
//  TakeOutIllegalListVC.m
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutIllegalListVC.h"

#import <MJRefresh.h>
#import "UITableView+Lr_Placeholder.h"
#import "NetWorkHelper.h"
#import "TakeOutIllegalCell.h"
#import "TakeOutIllegalDetailVC.h"

@interface TakeOutIllegalListVC ()

@property(nonatomic,strong) TakeOutIllegalListViewModel * viewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TakeOutIllegalListVC

- (instancetype)initWithViewModel:(TakeOutIllegalListViewModel *)viewModel{
    
    if (self = [super init]) {
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

#pragma mark - 配置UI界面

- (void)configUI{
    
    self.title = @"扣分记录";
  
    self.tableView.isNeedPlaceholderView = YES;
    self.tableView.str_placeholder = @"暂无扣分记录";
    self.tableView.firstReload = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"TakeOutIllegalCell" bundle:nil] forCellReuseIdentifier:@"TakeOutIllegalCellID"];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    @weakify(self);
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

#pragma mark - 加载新数据

- (void)reloadData{
    [self.viewModel.requestCommand execute:nil];
}



#pragma mark - 绑定ViewModels

- (void)bindViewModel{
    
    @weakify(self);
    
    [self.viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        [self.tableView.mj_header endRefreshing];
        
        if([x isEqualToString:@"加载失败"]){
            
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
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.arr_content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DeliveryIllegalModel *itemModel = self.viewModel.arr_content[indexPath.row];
    
    TakeOutIllegalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TakeOutIllegalCellID" forIndexPath:indexPath];
    cell.model = itemModel;
    return cell;
    
}

#pragma - mark UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    DeliveryIllegalModel *itemModel = self.viewModel.arr_content[indexPath.row];
    TakeOutIllegalDetailViewModel * viewModel = [[TakeOutIllegalDetailViewModel alloc] init];
    viewModel.reportId = itemModel.reportId;
    TakeOutIllegalDetailVC * vc = [[TakeOutIllegalDetailVC alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

- (void)dealloc{
    LxPrintf(@"TakeOutIllegalListVC dealloc");
}


@end
