//
//  IllegalAddListVC.m
//  移动采集
//
//  Created by hcat-89 on 2020/2/19.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "IllegalAddListVC.h"
#import "IllegalAddListViewModel.h"
#import "IllegalAddListCell.h"
#import "UINavigationBar+BarItem.h"

#import <MJRefresh.h>
#import "UITableView+Lr_Placeholder.h"
#import "NetWorkHelper.h"

#import "IllegalSearchView.h"
#import "AlertView.h"
#import "IllegalAddDetailVC.h"

@interface IllegalAddListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) IllegalAddListViewModel * viewModel;

@property (weak, nonatomic) IBOutlet UIView *view_status;
@property (weak, nonatomic) IBOutlet UIView *view_status_inside;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_viewSearchStatus_height;

@property(nonatomic, strong) NSMutableArray * arr_buttons;



@end

@implementation IllegalAddListVC

- (instancetype)init{
    
    if (self = [super init]) {
        self.viewModel = [[IllegalAddListViewModel alloc] init];
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - set&&get

- (NSMutableArray *)arr_buttons{
    
    if (_arr_buttons == nil) {
        _arr_buttons = @[].mutableCopy;
    }
    return _arr_buttons;
}


#pragma mark - configUI

- (void)configUI{
    
    @weakify(self);
    self.title = @"采集列表";
    
    self.view_status.hidden = YES;
    self.layout_viewSearchStatus_height.constant = 0;
    [self.view layoutIfNeeded];
    
    [self showRightBarButtonItemWithImage:@"btn_illegalSearch" target:self action:@selector(handleBtnSearchClicked:)];
    
    self.tableView.isNeedPlaceholderView = YES;
    self.tableView.str_placeholder = @"暂无采集数据";
    self.tableView.firstReload = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"IllegalAddListCell" bundle:nil] forCellReuseIdentifier:@"IllegalAddListCellID"];
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
    
    IllegalParkListModel *itemModel = self.viewModel.arr_content[indexPath.row];
    
    IllegalAddListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalAddListCellID" forIndexPath:indexPath];
    cell.model = itemModel;
    cell.permission =self.viewModel.permission;
    return cell;
    
}

#pragma - mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IllegalParkListModel *t_model = self.viewModel.arr_content[indexPath.row];
    IllegalAddDetailViewModel * viewModel = [[IllegalAddDetailViewModel alloc] init];
    viewModel.illegalId = t_model.illegalParkId;
    IllegalAddDetailVC * vc = [[IllegalAddDetailVC alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark - buttonAction


#pragma mark - 搜索按钮点击
- (IBAction)handleBtnSearchClicked:(id)sender {
    
    @weakify(self);
    IllegalSearchView *view = [IllegalSearchView initCustomView];
    view.selectedBlock = ^(NSString * _Nonnull carNo, NSNumber * _Nonnull status) {
        @strongify(self);
        self.viewModel.search = carNo;
        self.viewModel.state = status;
        
        if (self.arr_buttons.count > 0) {
            for (UIButton * button in self.arr_buttons) {
                [button removeFromSuperview];
            }
            [self.arr_buttons removeAllObjects];
        }
        
        if (carNo && carNo.length > 0) {
            UIButton * button = [[UIButton alloc] init];
            [button setTitle:carNo forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xE4F0FC)];
           
            button.layer.cornerRadius = 5.0f;
            button.layer.borderWidth = 1.0f;
            button.layer.borderColor = UIColorFromRGB(0x3396FC).CGColor;
            button.layer.masksToBounds = YES;
            [self.view_status_inside addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@85.);
                make.height.equalTo(@31.);
                make.left.equalTo(@12.5);
                make.top.equalTo(@40);
            }];
            [self.arr_buttons addObject:button];
        }
        
        if (status) {
            UIButton * button = [[UIButton alloc] init];
            if ([status intValue] == 8) {
                [button setTitle:@"上报异常" forState:UIControlStateNormal];
            }else{
                [button setTitle:@"确认异常" forState:UIControlStateNormal];
            }
            
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xE4F0FC)];
           
            button.layer.cornerRadius = 5.0f;
            button.layer.borderWidth = 1.0f;
            button.layer.borderColor = UIColorFromRGB(0x3396FC).CGColor;
            button.layer.masksToBounds = YES;
            [self.view_status_inside addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if (carNo == nil || carNo.length == 0) {
                    make.width.equalTo(@85.);
                    make.height.equalTo(@31.);
                    make.left.equalTo(@12.5);
                    make.top.equalTo(@40);
                }else{
                    make.width.equalTo(@85.);
                    make.height.equalTo(@31.);
                    make.left.equalTo(@107);
                    make.top.equalTo(@40);
                }
                
            }];
            [self.arr_buttons addObject:button];
        }
        
        self.view_status.hidden = NO;
        self.layout_viewSearchStatus_height.constant = 106.f;
        [self.view layoutIfNeeded];
        [self.tableView.mj_header beginRefreshing];
    };
    [AlertView showWindowWithIllegalSearchViewWith:view inView:self.view];
    
}

#pragma mark - 搜索条件框隐藏按钮点击
- (IBAction)handleBtnSearchStatusClicked:(id)sender {
    self.viewModel.search = nil;
    self.viewModel.state = nil;
    self.view_status.hidden = YES;
    self.layout_viewSearchStatus_height.constant = 0;
    [self.view layoutIfNeeded];
    
    [self.tableView.mj_header beginRefreshing];
}

-(IBAction)handleBtnBackClicked:(id)sender{
    
    if (self.navigationController.viewControllers.count == 1) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    

    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
    
    LxPrintf(@"IllegalList dealloc");
    
}

@end
