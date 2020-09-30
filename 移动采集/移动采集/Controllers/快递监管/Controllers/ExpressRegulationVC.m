//
//  ExpressRegulationVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/29.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ExpressRegulationVC.h"
#import "ExpressRegulationViewModel.h"
#import <MJRefresh.h>
#import "UITableView+Lr_Placeholder.h"
#import "NetWorkHelper.h"
#import "LRSettingCell.h"
#import "ExpressRegulationDetailVC.h"

@interface ExpressRegulationVC ()

@property (nonatomic,strong) ExpressRegulationViewModel * viewModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn_search;
@property (weak, nonatomic) IBOutlet UITextField *tf_search;

@property (weak, nonatomic) IBOutlet UIView *view_search;


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *arr_button;

@end

@implementation ExpressRegulationVC

- (instancetype)init{
    
    if (self = [super init]) {
        self.viewModel = [[ExpressRegulationViewModel alloc] init];
    }

    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel];
}


#pragma mark - 配置UI界面

- (void)configUI{
    
    self.btn_search.layer.cornerRadius = 5.f;
    self.view_search.layer.cornerRadius = 5.f;
    
    self.tableView.isNeedPlaceholderView = YES;
    self.tableView.str_placeholder = @"暂无搜索内容";
    self.tableView.firstReload = YES;
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
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"— 没有更多内容了 —" forState:MJRefreshStateNoMoreData];
    
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    footer.stateLabel.textColor = UIColorFromRGB(0xa6a6a6);
    self.tableView.mj_footer = footer;
    self.tableView.mj_footer.automaticallyHidden = YES;
    
    
    RAC(self.viewModel, searchName) = _tf_search.rac_textSignal;
    
}

#pragma mark - 加载新数据

- (void)reloadData{
    self.viewModel.start = @0;
    if (self.tableView.mj_footer&&self.tableView.mj_footer.state == MJRefreshStateNoMoreData){
        [self.tableView.mj_footer resetNoMoreData];
        
    }
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
            if (self.viewModel.arr_content.count == 0) {
                [self.tableView.mj_footer resetNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            
            
        }else if([x isEqualToString:@"加载失败"]){
            
            if (self.viewModel.arr_content.count > 0) {
                [self.viewModel.arr_content removeAllObjects];
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
    
    
    [RACObserve(self.viewModel, searchType) subscribeNext:^(NSNumber * _Nullable x) {
        
        @strongify(self);
       
        for (UIButton * t_button in self.arr_button) {
            if (t_button.tag == [x intValue]) {
                t_button.selected = YES;
            }else{
                t_button.selected = NO;
            }
        }
        
        if (self.viewModel.searchName.length > 0) {
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
    
    static NSString *identifier = @"setting";
    
    ExpressRegulationListItem *itemModel = self.viewModel.arr_content[indexPath.row];
    
    LRSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LRSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    LRSettingItemModel * cellModel = [[LRSettingItemModel alloc] init];
    cellModel.funcName = [NSString stringWithFormat:@"%@%@",itemModel.frameNo,itemModel.courierName];
    cellModel.accessoryType = LRSettingAccessoryTypeDisclosureIndicator;
    cell.item = cellModel;
    return cell;
    
}

#pragma - mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ExpressRegulationListItem *itemModel = self.viewModel.arr_content[indexPath.row];
    
    ExpressRegulationDetailViewModel * viewModel = [[ExpressRegulationDetailViewModel alloc] init];
    viewModel.vehicleId = itemModel.expressRegulationId;

    ExpressRegulationDetailVC * vc = [[ExpressRegulationDetailVC alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}


#pragma mark - btnAction

- (IBAction)handleBtnNameClicked:(id)sender {
    self.viewModel.searchType = @0;
}

- (IBAction)handleBtnCodeClicked:(id)sender {
    self.viewModel.searchType = @1;
}


- (IBAction)handleBtnCarNoClicked:(id)sender {
    self.viewModel.searchType = @2;
}

- (IBAction)handleBtnCarInfoClicked:(id)sender {
    self.viewModel.searchType = @3;
}

- (IBAction)handleBtnSearchClicked:(id)sender {
    [_tf_search resignFirstResponder];
    
    if (_tf_search.text.length > 0) {
        [self.tableView.mj_header beginRefreshing];
    }else{
        [LRShowHUD showError:@"请输入搜索内容" duration:1.5f];
    }
    
    
}

- (void)dealloc{
    LxPrintf(@"ExpressRegulationVC dealloc");
}


@end
