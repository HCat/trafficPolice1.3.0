//
//  IllegalExposureListVC.m
//  移动采集
//
//  Created by hcat on 2019/12/6.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "IllegalExposureListVC.h"
#import "ExposureCollectAPI.h"

#import <MJRefresh.h>

#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "IllegalCell.h"
#import "NetWorkHelper.h"
#import "IllegalExposureDetailVC.h"



@interface IllegalExposureListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tb_content;

@property (nonatomic,strong) NSMutableArray *arr_content;

@property (nonatomic,assign) NSInteger index; //加载更多数据索引


@end

@implementation IllegalExposureListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tb_content.isNeedPlaceholderView = YES;
    _tb_content.firstReload = YES;
    //隐藏多余行的分割线
    _tb_content.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tb_content setSeparatorInset:UIEdgeInsetsZero];
    [_tb_content setLayoutMargins:UIEdgeInsetsZero];
       
    [_tb_content registerNib:[UINib nibWithNibName:@"IllegalCell" bundle:nil] forCellReuseIdentifier:@"IllegalCellID"];
       
    self.arr_content = [NSMutableArray array];
       
    [self initRefresh];
     
    WS(weakSelf);
    //点击重新加载之后的处理
    [_tb_content setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        strongSelf.index = 0;
        [strongSelf.tb_content.mj_header beginRefreshing];
    }];
        
    [_tb_content.mj_header beginRefreshing];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        strongSelf.index = 0;
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
    self.index = 0;
    [self loadData];
}

- (void)loadData{
    
    WS(weakSelf);
    if (_index == 0) {
        if (_arr_content && _arr_content.count > 0) {
            [_arr_content removeAllObjects];
        }
    }
    
    ExposureCollectListPagingParam *param = [[ExposureCollectListPagingParam alloc] init];
     param.start = _index;
     param.length = 10;
     
     
     ExposureCollectListPagingManger *manger = [[ExposureCollectListPagingManger alloc] init];
     manger.param = param;
    
     [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
         SW(strongSelf, weakSelf);
         [strongSelf.tb_content.mj_header endRefreshing];
         [strongSelf.tb_content.mj_footer endRefreshing];
         
         if (manger.responseModel.code == CODE_SUCCESS) {
             
             [strongSelf.arr_content addObjectsFromArray:manger.exposureCollectListPagingReponse.list];
             if (strongSelf.arr_content.count == manger.exposureCollectListPagingReponse.total) {
                 [strongSelf.tb_content.mj_footer endRefreshingWithNoMoreData];
             }else{
                 strongSelf.index += param.length;
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
    return [tableView fd_heightForCellWithIdentifier:@"IllegalCellID" cacheByIndexPath:indexPath configuration:^(IllegalCell *cell) {
        SW(strongSelf, weakSelf);
        if (strongSelf.arr_content && strongSelf.arr_content.count > 0) {
            ExposureCollectListModel *t_model = strongSelf.arr_content[indexPath.row];
            cell.model_exposure = t_model;

        }
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IllegalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalCellID"];
    cell.fd_enforceFrameLayout = NO;
    if (_arr_content && _arr_content.count > 0) {
        ExposureCollectListModel *t_model = _arr_content[indexPath.row];
        cell.model_exposure = t_model;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_arr_content && _arr_content.count > 0) {
        
        ExposureCollectListModel *t_model = _arr_content[indexPath.row];
        IllegalExposureDetailVC *t_vc = [[IllegalExposureDetailVC alloc] init];
        t_vc.exposureCollectId = t_model.exposureCollectId;
        [self.navigationController pushViewController:t_vc animated:YES];
            
    }
    
}

- (void)dealloc{

    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
    
    LxPrintf(@"IllegalList dealloc");
    
}

@end
