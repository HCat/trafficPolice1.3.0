//
//  VehicleUpInfoVC.m
//  移动采集
//
//  Created by hcat on 2018/5/14.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleUpInfoVC.h"
#import <MJRefresh.h>

#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "NetWorkHelper.h"

#import "VehicleUpCell.h"
#import "VehicleAPI.h"
#import "VehicleUpCarDetailVC.h"
#import "VehicleCarMoreVC.h"

@interface VehicleUpInfoVC ()

@property (weak, nonatomic) IBOutlet UITableView *tb_content;

@property (nonatomic,strong) NSMutableArray *arr_content;

@property (nonatomic,assign) NSInteger index; //加载更多数据索引


@end

@implementation VehicleUpInfoVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _tb_content.isNeedPlaceholderView = YES;
    _tb_content.str_placeholder = @"暂无上报记录";
    _tb_content.firstReload = YES;
    [_tb_content registerNib:[UINib nibWithNibName:@"VehicleUpCell" bundle:nil] forCellReuseIdentifier:@"VehicleUpCellID"];
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
    
    VehicleUpCarListParam *param = [[VehicleUpCarListParam alloc] init];
    param.start = _index;
    param.length = 10;
    param.plateNo = _plateNo;
    
    if (_vehicleId != nil) {
        param.carId = _vehicleId;
    }
    
    VehicleUpCarListManger *manger = [[VehicleUpCarListManger alloc] init];
    manger.param = param;
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        [strongSelf.tb_content.mj_header endRefreshing];
        [strongSelf.tb_content.mj_footer endRefreshing];
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            [strongSelf.arr_content addObjectsFromArray:manger.upCarListReponse.list];
            if (strongSelf.arr_content.count == manger.upCarListReponse.total) {
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
    return [tableView fd_heightForCellWithIdentifier:@"VehicleUpCellID" cacheByIndexPath:indexPath configuration:^(VehicleUpCell *cell) {
        SW(strongSelf, weakSelf);
        if (strongSelf.arr_content && strongSelf.arr_content.count > 0) {
            
            VehicleUpDetailModel *model = strongSelf.arr_content[indexPath.row];
            cell.model = model;
            
        }
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VehicleUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleUpCellID"];
    cell.fd_enforceFrameLayout = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_arr_content && _arr_content.count > 0) {
        VehicleUpDetailModel *model = _arr_content[indexPath.row];
        cell.model = model;
    }
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    VehicleCarMoreVC *vc_target = (VehicleCarMoreVC *)[ShareFun findViewController:self.view withClass:[VehicleCarMoreVC class]];
    
    if (_arr_content && _arr_content.count > 0) {
        VehicleUpDetailModel *model = _arr_content[indexPath.row];
        VehicleUpCarDetailVC *t_vc = [[VehicleUpCarDetailVC alloc] init];
        t_vc.vehicleId = model.upId;
        [vc_target.navigationController pushViewController:t_vc animated:YES];
    }
    
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
    LxPrintf(@"VehicleUpInfoVC dealloc");
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
