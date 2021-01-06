//
//  AccidentHistoryListVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/11/13.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "AccidentHistoryListVC.h"
#import "AccidentMoreAPIs.h"
#import "LRBaseTableView.h"
#import "AccidentCell.h"
#import "AccidentCompleteVC.h"

@interface AccidentHistoryListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) AccidentHistoricalListViewmodel * viewModel;

@property (weak, nonatomic) IBOutlet LRBaseTableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_top;

@end

@implementation AccidentHistoryListVC

- (instancetype)initWithViewModel:(AccidentHistoricalListViewmodel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return  self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)lr_configUI{
    
    @weakify(self);
    self.title = @"历史记录";
    self.tableView.autoNetworkNotice = YES;
    self.tableView.isHavePlaceholder = YES;
    self.layout_top.constant = - Height_NavBar;
    
    self.tableView.tableViewPlaceholderBlock = ^{
        @strongify(self);
        
        if (self.viewModel.arr_content.count > 0) {
            [self.viewModel.arr_content removeAllObjects];
            [self.tableView reloadData];
        }
        
        self.tableView.lr_handler.state = LRDataLoadStateLoading;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              @strongify(self);
              [self reloadData];
        });
    };
    
    self.tableView.tableViewHeaderRefresh = ^{
        @strongify(self);
        [self reloadData];
        
    };
    
    self.tableView.tableViewFooterLoadMore = ^{
        @strongify(self);
        [self loadData];
        
    };
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AccidentCell" bundle:nil] forCellReuseIdentifier:@"AccidentCellID"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 148.5f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)lr_bindViewModel{
    
    
    @weakify(self);
    

    [self.viewModel.command_list.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        [self.tableView endingRefresh];
        [self.tableView endingLoadMore];
        
        if ([x isEqualToString:@"请求最后一条成功"]) {
            [self.tableView endingNoMoreData];
            if (self.viewModel.arr_content.count == 0) {
                self.tableView.lr_handler.state = LRDataLoadStateEmpty;
            }
        }else if([x isEqualToString:@"加载成功"]){
            if (self.viewModel.arr_content.count == 0) {
                self.tableView.lr_handler.state = LRDataLoadStateEmpty;
            }else{
                self.tableView.lr_handler.state = LRDataLoadStateIdle;
            }
            
        }else if([x isEqualToString:@"加载失败"]){
        
            if (self.viewModel.arr_content.count == 0) {
                self.tableView.lr_handler.state = LRDataLoadStateFailed;
            }
        }
        
        [self.tableView reloadData];
        
    }];
    
    [self loadDataForStart];
    
}

#pragma mark - 开始加载数据

- (void)loadDataForStart{
    @weakify(self);
    if (self.viewModel.arr_content.count > 0) {
        [self.viewModel.arr_content removeAllObjects];
        [self.tableView reloadData];
    }
    self.tableView.enableRefresh = YES;
    self.tableView.enableLoadMore = YES;
    [self.tableView resetNoMoreData];
    self.tableView.lr_handler.state = LRDataLoadStateLoading;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self reloadData];
    });
    
}


#pragma mark - 加载新数据

- (void)reloadData{
    self.viewModel.param.start = 0;
    [self.tableView resetNoMoreData];
    [self.viewModel.command_list execute:nil];
}

- (void)loadData{
    [self.viewModel.command_list execute:nil];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.arr_content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AccidentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentCellID"];
    
    if (self.viewModel.arr_content && self.viewModel.arr_content.count > 0) {
        
        AccidentListModel *t_model = self.viewModel.arr_content[indexPath.row];
        if ([self.viewModel.param.accidentType isEqualToString:@"1"]) {
            cell.accidentType = AccidentTypeAccident;
        }else if ([self.viewModel.param.accidentType isEqualToString:@"2"]){
            cell.accidentType = AccidentTypeFastAccident;
        }
        cell.model = t_model;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.viewModel.arr_content && self.viewModel.arr_content.count > 0) {
        
        AccidentListModel *t_model = self.viewModel.arr_content[indexPath.row];
    
        AccidentCompleteVC *t_vc = [[AccidentCompleteVC alloc] init];
        
        if ([self.viewModel.param.accidentType isEqualToString:@"1"]) {
            t_vc.accidentType = AccidentTypeAccident;
        }else if ([self.viewModel.param.accidentType isEqualToString:@"2"]){
            t_vc.accidentType = AccidentTypeFastAccident;
        }
        
        t_vc.accidentId = t_model.accidentId;
        t_vc.state = t_model;
        [self.navigationController pushViewController:t_vc animated:YES];
        
    }
}

- (void)dealloc{
    
    LxPrintf(@"AccidentHistoryListVC dealloc");
    
}


@end
