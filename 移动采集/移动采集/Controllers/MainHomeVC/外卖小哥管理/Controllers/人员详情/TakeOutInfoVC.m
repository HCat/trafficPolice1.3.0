//
//  TakeOutInfoVC.m
//  移动采集
//
//  Created by hcat on 2019/5/9.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutInfoVC.h"
#import "TakeOutInfoCell.h"
#import "TakeOutAddVC.h"
#import <MJRefresh.h>

@interface TakeOutInfoVC ()

@property(nonatomic, strong) TakeOutInfoViewModel * viewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btn_add;

@end

@implementation TakeOutInfoVC

- (instancetype)initWithViewModel:(TakeOutInfoViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    @weakify(self);
    [self.viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (x) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }
    }];
    

    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - 配置UI界面

- (void)configUI{
    
    self.title =@"人员详情";
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"TakeOutInfoCell" bundle:nil] forCellReuseIdentifier:@"TakeOutInfoCellID"];
 
    @weakify(self);
    [[self.btn_add rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        TakeOutAddViewModel * t_viewModel = [[TakeOutAddViewModel alloc] init];
        t_viewModel.deliveryId = self.viewModel.deliveryId;
        TakeOutAddVC * vc = [[TakeOutAddVC alloc] initWithViewModel:t_viewModel];
        vc.block = ^{
            @strongify(self);
            [self.tableView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    [header setTitle:@"下拉查询" forState:MJRefreshStateIdle];
    [header setTitle:@"松手开始查询" forState:MJRefreshStatePulling];
    [header setTitle:@"查询中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    
}

- (void)reloadData{
    [self.viewModel.requestCommand execute:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TakeOutInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TakeOutInfoCellID" forIndexPath:indexPath];
    
    cell.model = self.viewModel.model;
    
    return cell;
    
}

#pragma - mark UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)dealloc{
    LxPrintf(@"TakeOutInfoVC dealloc");
    
}


@end
