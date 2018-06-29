//
//  VehicleSpeedAlarmListVC.m
//  移动采集
//
//  Created by hcat on 2018/5/23.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleSpeedAlarmListVC.h"

#import <MJRefresh.h>
#import "UITableView+Lr_Placeholder.h"
#import "VehicleSpeedAlarmCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "NetWorkHelper.h"

#import "SearchImportCarVC.h"

#import "VehicleAPI.h"


@interface VehicleSpeedAlarmListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tb_content;

@property (nonatomic,strong) NSMutableArray *arr_content;

@property (nonatomic,assign) NSInteger index; //加载更多数据索引

@end

@implementation VehicleSpeedAlarmListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([_alarmType isEqualToString:@"1"]) {
        self.title = @"区域超速";
    }else if ([_alarmType isEqualToString:@"111"]){
        self.title = @"路口超速";
    }
    
    
    
    _tb_content.isNeedPlaceholderView = YES;
    _tb_content.firstReload = YES;
    //隐藏多余行的分割线
   
    [_tb_content registerNib:[UINib nibWithNibName:@"VehicleSpeedAlarmCell" bundle:nil] forCellReuseIdentifier:@"VehicleSpeedAlarmCellID"];
    
    self.arr_content = [NSMutableArray array];
    
    [self initRefresh];
    
    [_tb_content.mj_header beginRefreshing];
    
    WS(weakSelf);
    //点击重新加载之后的处理
    [_tb_content setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        strongSelf.index = 1;
        [strongSelf.tb_content.mj_header beginRefreshing];
    }];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    WS(weakSelf);
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        strongSelf.index = 1;
        [strongSelf.tb_content.mj_header beginRefreshing];
    };
    
}

#pragma mark - 创建下拉刷新，以及上拉加载更多

- (void)initRefresh{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    [header setTitle:@"下拉查询" forState:MJRefreshStateIdle];
    [header setTitle:@"松手开始查询" forState:MJRefreshStatePulling];
    [header setTitle:@"查询中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    _tb_content.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"— 没有更多内容了 —" forState:MJRefreshStateNoMoreData];
    
    
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    footer.stateLabel.textColor = UIColorFromRGB(0xa6a6a6);
    _tb_content.mj_footer = footer;
    _tb_content.mj_footer.automaticallyHidden = YES;
    
}

#pragma mark - 加载新数据

- (void)reloadData{
    self.index = 1;
    [self loadData];
}

- (void)loadData{
    
    WS(weakSelf);
    if (_index == 1) {
        if (_arr_content && _arr_content.count > 0) {
            [_arr_content removeAllObjects];
        }
    }
    
    VehicleSpeedAlarmListParam *param = [[VehicleSpeedAlarmListParam alloc] init];
    param.start = _index;
    param.length = 10;
    param.alarmType = _alarmType;
    param.vehicleid = _vehicleid;
    
    VehicleSpeedAlarmListManger *manger = [[VehicleSpeedAlarmListManger alloc] init];
    manger.param = param;
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        [strongSelf.tb_content.mj_header endRefreshing];
        [strongSelf.tb_content.mj_footer endRefreshing];
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            [strongSelf.arr_content addObjectsFromArray:manger.speedAlarmListReponse.list];
            if (strongSelf.arr_content.count == manger.speedAlarmListReponse.total) {
                [strongSelf.tb_content.mj_footer endRefreshingWithNoMoreData];
            }else{
                strongSelf.index += 1;
            }
            [strongSelf.tb_content reloadData];
        }else{
            NSString *t_errString = [NSString stringWithFormat:@"网络错误:code:%ld msg:%@",manger.responseModel.code,manger.responseModel.msg];
            [LRShowHUD showError:t_errString duration:1.5 inView:strongSelf.view config:nil];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf,weakSelf);
        [strongSelf.tb_content.mj_header endRefreshing];
        [strongSelf.tb_content.mj_footer endRefreshing];
        
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            if (strongSelf.arr_content.count > 0) {
                [strongSelf.arr_content removeAllObjects];
            }
            strongSelf.tb_content.isNetAvailable = YES;
            [strongSelf.tb_content reloadData];
        }
    }];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_content.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf);
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"VehicleSpeedAlarmCellID" cacheByIndexPath:indexPath configuration:^(VehicleSpeedAlarmCell *cell) {
        SW(strongSelf, weakSelf);
        if (strongSelf.arr_content && strongSelf.arr_content.count > 0) {
            VehicleSpeedAlarmModel *t_model = strongSelf.arr_content[indexPath.row];
            cell.speedAlarmModel = t_model;
            
        }
    }];
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VehicleSpeedAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleSpeedAlarmCellID"];
    
    if (_arr_content && _arr_content.count > 0) {
        WS(weakSelf);
        VehicleSpeedAlarmModel *t_model = _arr_content[indexPath.row];
        cell.speedAlarmModel = t_model;
        cell.block = ^{
            SW(strongSelf, weakSelf);
            VehicleGPSModel *gps_model = [VehicleGPSModel new];
            gps_model.latitude = t_model.latitude;
            gps_model.longitude = t_model.longitude;
            SearchImportCarVC *t_vc = [[SearchImportCarVC alloc ] init];
            t_vc.type = 1;
            t_vc.search_vehicleModel = gps_model;
            [strongSelf.navigationController pushViewController:t_vc animated:YES];
        };
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
    LxPrintf(@"VehicleSpeedAlarmListVC dealloc");
    
}

@end
