//
//  DataStatisticsListVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/12/16.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "DataStatisticsListVC.h"


@interface DataStatisticsListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) DataStatisticsListViewModel * viewModel;

@property (weak, nonatomic) IBOutlet LRBaseTableView *tableView;


@end

@implementation DataStatisticsListVC


- (instancetype)initWithViewModel:(DataStatisticsListViewModel *)viewModel{
    
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
    
    self.tableView.autoNetworkNotice = YES;
    self.tableView.isHavePlaceholder = YES;
    
    
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
    self.viewModel.index= 0;
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
        cell.accidentType = AccidentTypeAccident;
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
        t_vc.accidentType = AccidentTypeAccident;
        t_vc.accidentId = t_model.accidentId;
        t_vc.state = t_model;
        [self.navigationController pushViewController:t_vc animated:YES];
        
    }
}


- (void)dealloc{
    
    LxPrintf(@"DataStatisticsListVC dealloc");
    
}



@end
