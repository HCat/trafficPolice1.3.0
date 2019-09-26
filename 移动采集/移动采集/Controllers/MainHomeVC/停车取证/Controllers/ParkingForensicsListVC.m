//
//  ParkingForensicsListVC.m
//  移动采集
//
//  Created by hcat on 2019/7/24.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingForensicsListVC.h"

#import "ParkingForensicsListCell.h"
#import <MJRefresh.h>
#import "UITableView+Lr_Placeholder.h"
#import "NetWorkHelper.h"
#import "ParkingAreaVC.h"
#import "ParkingAreaDetailVC.h"

@interface ParkingForensicsListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn_checkArea;


@property(nonatomic,strong) ParkingForensicsListViewModel * viewModel;

@end

@implementation ParkingForensicsListVC

- (instancetype)initWithViewModel:(ParkingForensicsListViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
        //添加对定位的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChange) name:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parkingForensicsSuccess) name:NOTIFICATION_PARKINGFORENSICS_SUCCESS object:nil];
    }
    
    return self;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel];
    
    [[LocationHelper sharedDefault] startLocation];
    
}

#pragma mark - 配置UI界面

- (void)configUI{
    
    @weakify(self);
    
    self.title = @"停车取证";
    
    self.btn_checkArea.layer.cornerRadius = 5.f;
    
    self.tableView.isNeedPlaceholderView = YES;
    self.tableView.str_placeholder = @"暂无取证工单";
    self.tableView.firstReload = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"ParkingForensicsListCell" bundle:nil] forCellReuseIdentifier:@"ParkingForensicsListCellID"];
    self.tableView.estimatedRowHeight = 105.0;
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
    
    [[self.btn_checkArea rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ParkingAreaVC * vc = [[ParkingAreaVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    
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
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.arr_content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ParkingForensicsModel *itemModel = self.viewModel.arr_content[indexPath.row];
    
    ParkingForensicsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkingForensicsListCellID" forIndexPath:indexPath];
    cell.model = itemModel;
    return cell;
    
}

#pragma - mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   ParkingForensicsModel *itemModel = self.viewModel.arr_content[indexPath.row];
    
    ParkingAreaDetailViewModel * viewModel = [[ParkingAreaDetailViewModel alloc] init];
    viewModel.placenum = itemModel.placenum;
    viewModel.parkplaceId = itemModel.pkParkplaceId;
    
    ParkingAreaDetailVC * vc = [[ParkingAreaDetailVC alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
    

}

#pragma mark - 重新定位之后的通知

-(void)locationChange{
    
    self.viewModel.latitude =  @([LocationHelper sharedDefault].latitude);
    self.viewModel.longitude = @([LocationHelper sharedDefault].longitude);
    
    [self.tableView.mj_header beginRefreshing];

}

#pragma mark - notification

- (void)parkingForensicsSuccess{
    [self.tableView.mj_header beginRefreshing];
    
}


#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"ParkingForensicsListVC dealloc");
     [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_PARKINGFORENSICS_SUCCESS object:nil];
}

@end
