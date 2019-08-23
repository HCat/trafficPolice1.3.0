//
//  TakeOutSearchVC.m
//  移动采集
//
//  Created by hcat on 2019/5/8.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutSearchVC.h"
#import "TakeOutSearchViewModel.h"
#import <MJRefresh.h>
#import "UITableView+Lr_Placeholder.h"
#import "NetWorkHelper.h"
#import "LRSettingCell.h"
#import "TakeOutInfoVC.h"
#import "QRCodeScanVC.h"
#import "TakeOutTempVC.h"

@interface TakeOutSearchVC ()

@property (nonatomic,strong) TakeOutSearchViewModel * viewModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn_search;
@property (weak, nonatomic) IBOutlet UITextField *tf_search;

@property (weak, nonatomic) IBOutlet UIView *view_search;


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *arr_button;

@property (weak, nonatomic) IBOutlet UIButton *btn_ercode;
@property (weak, nonatomic) IBOutlet UIButton *btn_add;



@end

@implementation TakeOutSearchVC

- (instancetype)init{
    
    if (self = [super init]) {
        self.viewModel = [[TakeOutSearchViewModel alloc] init];
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
    
    self.title = @"外卖监管";
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
    
    
    RAC(self.viewModel, key) = _tf_search.rac_textSignal;
    

    [[self.btn_ercode rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
       @strongify(self);
        QRCodeScanVC *t_vc = [[QRCodeScanVC alloc] init];
        t_vc.block = ^(NSString *str_code) {
            @strongify(self);
            if (str_code) {
                NSArray * arr = [str_code componentsSeparatedByString:@"/"];
                NSString * t_str = arr.lastObject;
                self.tf_search.text = t_str;
                self.viewModel.key = t_str;
                self.viewModel.type = @5;
                
            }
            
        };
        [self.navigationController pushViewController:t_vc animated:YES];
        
    }];
    
    [[self.btn_add rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        TakeOutTempVC *t_vc = [[TakeOutTempVC alloc] init];
        [self.navigationController pushViewController:t_vc animated:YES];
        
    }];
    
}

#pragma mark - 加载新数据

- (void)reloadData{
    self.viewModel.index = @0;
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
        
        if ([self.viewModel.type isEqualToNumber:@5] && self.viewModel.arr_content.count > 0) {
            @strongify(self);
            NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];
            [self tableView:self.tableView didSelectRowAtIndexPath:index];
        }
        
    }];
    
    
    [RACObserve(self.viewModel, type) subscribeNext:^(NSNumber * _Nullable x) {
        
        @strongify(self);
       
        for (UIButton * t_button in self.arr_button) {
            if (t_button.tag == [x intValue]) {
                t_button.selected = YES;
            }else{
                t_button.selected = NO;
            }
        }
        
        if (self.viewModel.key.length > 0) {
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
    
    DeliveryCourierModel *itemModel = self.viewModel.arr_content[indexPath.row];
    
    LRSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LRSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    LRSettingItemModel * cellModel = [[LRSettingItemModel alloc] init];
    cellModel.funcName = itemModel.name;
    cellModel.accessoryType = LRSettingAccessoryTypeDisclosureIndicator;
    cell.item = cellModel;
    return cell;
    
}

#pragma - mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DeliveryCourierModel *itemModel = self.viewModel.arr_content[indexPath.row];
    
    TakeOutInfoViewModel * viewModel = [[TakeOutInfoViewModel alloc] init];
    viewModel.deliveryId = itemModel.deliveryId;
    
    TakeOutInfoVC * vc = [[TakeOutInfoVC alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}


#pragma mark - btnAction

- (IBAction)handleBtnNameClicked:(id)sender {
    self.viewModel.type = @1;
}

- (IBAction)handleBtnCodeClicked:(id)sender {
    self.viewModel.type = @2;
}


- (IBAction)handleBtnCarNoClicked:(id)sender {
    self.viewModel.type = @3;
}

- (IBAction)handleBtnCarInfoClicked:(id)sender {
    self.viewModel.type = @4;
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
    LxPrintf(@"TakeOutSearchVC dealloc");
}

@end
