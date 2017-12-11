//
//  UserTaskListVC.m
//  移动采集
//
//  Created by hcat on 2017/11/3.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "UserTaskListVC.h"
#import "YXGCD.h"
#import "TaskAPI.h"
#import "UserTaskCell.h"
#import "UserNullCell.h"

#import <MJRefresh.h>
#import "UITableView+FDTemplateLayoutCell.h"
#import "UITableView+Lr_Placeholder.h"
#import "UserTaskDetailVC.h"
#import "UserHomeVC.h"


@interface UserTaskListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * arr_current;
@property (nonatomic,strong) NSMutableArray * arr_history;

@property (nonatomic,assign) NSInteger index; //加载更多数据索引
@property (nonatomic,strong) TaskModel * currentTask;
@property (nonatomic,assign) BOOL isLoading;


@end

@implementation UserTaskListVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.arr_history = [NSMutableArray array];
    self.arr_current = [NSMutableArray array];
    
    self.tableView.isNeedPlaceholderView = YES;
    self.isLoading = YES;
    
    [_tableView registerNib:[UINib nibWithNibName:@"UserTaskCell" bundle:nil] forCellReuseIdentifier:@"UserTaskCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"UserNullCell" bundle:nil] forCellReuseIdentifier:@"UserNullCellID"];
    [self initRefresh];
    
    [_tableView.mj_header beginRefreshing];
    
    WS(weakSelf);
    
    //点击重新加载之后的处理
    [_tableView setReloadBlock:^{
        SW(strongSelf, weakSelf);
        
        [strongSelf.tableView.mj_header beginRefreshing];
    }];
    
    
}

#pragma mark - 数据重新加载

- (void)reloadData{

    self.isLoading = YES;
    self.tableView.isNetAvailable = NO;
    WS(weakSelf);
    GCDGroup *group = [GCDGroup new];
    [[GCDQueue globalQueue] execute:^{
        SW(strongSelf,weakSelf);
        [strongSelf requestCurrentTask];

    } inGroup:group];
    
    [[GCDQueue globalQueue] execute:^{
        SW(strongSelf,weakSelf);
        strongSelf.index = 0;
        [strongSelf requestHistoryTask];
        
    } inGroup:group];
    
    [[GCDQueue mainQueue] notify:^{
        SW(strongSelf,weakSelf);
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        self.isLoading = NO;
        [self.tableView reloadData];
    } inGroup:group];

}

- (void)loadMoreData{
    WS(weakSelf);
    GCDGroup *group = [GCDGroup new];
    
    [[GCDQueue globalQueue] execute:^{
        SW(strongSelf,weakSelf);
        [strongSelf requestHistoryTask];
        
    } inGroup:group];
    
    [[GCDQueue mainQueue] notify:^{
        SW(strongSelf,weakSelf);
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
    } inGroup:group];
    
}

#pragma mark - 数据请求

- (void)requestCurrentTask{
    
    WS(weakSelf);
    
    if (_arr_current && _arr_current.count > 0) {
        [_arr_current removeAllObjects];
    }
    
    GCDSemaphore *semaphore = [GCDSemaphore new];
    
    TaskGetCurrentListManger *manger = [[TaskGetCurrentListManger alloc] init];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            [strongSelf.arr_current addObjectsFromArray:manger.list];
            [strongSelf.tableView reloadData];
            
        }
        
        [semaphore signal];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            if (strongSelf.arr_current.count > 0) {
                [strongSelf.arr_current removeAllObjects];
            }
            strongSelf.tableView.isNetAvailable = YES;
            [strongSelf.tableView reloadData];
        }
        
        [semaphore signal];
    }];
    
    [semaphore wait];
}

- (void)requestHistoryTask{
    
    WS(weakSelf);
    if (_index == 0) {
        if (_arr_history && _arr_history.count > 0) {
            [_arr_history removeAllObjects];
        }
    }
    
    GCDSemaphore *semaphore = [GCDSemaphore new];
    
    TaskGetHistoryListParam *param = [[TaskGetHistoryListParam alloc] init];
    param.start = _index;
    param.length = 10;

    TaskGetHistoryListManger *manger = [[TaskGetHistoryListManger alloc] init];
    manger.param = param;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            [strongSelf.arr_history addObjectsFromArray:manger.taskGetHistoryListReponse.list];
            if (strongSelf.arr_history.count == manger.taskGetHistoryListReponse.total) {
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                strongSelf.index += param.length;
            }

            [strongSelf.tableView reloadData];
        }
        
        [semaphore signal];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            if (strongSelf.arr_history.count > 0) {
                [strongSelf.arr_history removeAllObjects];
            }
            strongSelf.tableView.isNetAvailable = YES;
            [strongSelf.tableView reloadData];
        }
        
        [semaphore signal];
    }];
    
    [semaphore wait];
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
    _tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"— 没有更多内容了 —" forState:MJRefreshStateNoMoreData];
    
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    footer.stateLabel.textColor = UIColorFromRGB(0xa6a6a6);
    _tableView.mj_footer = footer;
    _tableView.mj_footer.automaticallyHidden = YES;
    
}


#pragma mark - tableViewDelegate

#pragma mark - 数据源方法

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 55.0f;
    
}

/**
 *  设置分组
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.tableView.isNetAvailable == YES) {
        return 0;
    }else{
        return 2;
        
    }
    
}

// 返回行数
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        if (self.arr_current && self.arr_current.count >0) {
            return self.arr_current.count;
        }else{
            if (self.isLoading) {
                return 0;
            }else{
                return 1;
            }
        }
        
    }else{
        
        if (self.arr_history && self.arr_history.count >0) {
            return self.arr_history.count;
        }else{
            if (self.isLoading) {
                return 0;
            }else{
                return 1;
            }
        }
    }
}

// 设置cell
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (self.arr_current && self.arr_current.count > 0) {
            
            UserTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserTaskCellID"];
            cell.fd_enforceFrameLayout = NO;
            cell.currentTask = self.arr_current[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else{
            UserNullCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserNullCellID"];
            cell.lb_tip.text = @"当前无任务";
            return cell;
        }
        
    }else{
        
        if (_arr_history && _arr_history.count > 0) {
            UserTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserTaskCellID"];
            cell.fd_enforceFrameLayout = NO;
            cell.currentTask = _arr_history[indexPath.row];
            return cell;
        }else{
            
            UserNullCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserNullCellID"];
            cell.lb_tip.text = @"历史无任务";
            return cell;
            
        }
    
    }
    
}

#pragma mark - 代理方法

/**
 *  设置行高
 */
- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    WS(weakSelf);
    if (indexPath.section == 0) {
        if (self.arr_current && self.arr_current.count > 0) {
            SW(strongSelf, weakSelf);
            return [tableView fd_heightForCellWithIdentifier:@"UserTaskCellID" cacheByIndexPath:indexPath configuration:^(UserTaskCell *cell) {
                cell.currentTask = strongSelf.arr_current[indexPath.row];
            }];
            
        }else{
            return 255.f;
        }
    
    }else{
        if (_arr_history && _arr_history.count > 0) {
            
            SW(strongSelf, weakSelf);
            return [tableView fd_heightForCellWithIdentifier:@"UserTaskCellID" cacheByIndexPath:indexPath configuration:^(UserTaskCell *cell) {
                cell.currentTask = strongSelf.arr_history[indexPath.row];
            }];

        }else{
            return 255.f;
        }
        
    }

}

// 添加每组的组头
- (UIView *)tableView:(nonnull UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 30)];
    label.textColor = UIColorFromRGB(0x787878);
    if (section == 0) {
        label.text = @"当前任务";
    }else{
        label.text = @"历史任务";
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:label];
    [headerView.layer setBackgroundColor:[UIColor clearColor].CGColor];

    return headerView;
    
}


// 选中某行cell时会调用
- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSLog(@"选中didSelectRowAtIndexPath row = %ld", indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
        if (self.arr_current && self.arr_current.count > 0) {
            
            UserTaskDetailVC *t_vc = [[UserTaskDetailVC alloc] init];
            t_vc.task = _arr_current[indexPath.row];
            UIViewController * vc_target = (UserHomeVC *)[ShareFun findViewController:self.view withClass:[UserHomeVC class]];
            [vc_target.navigationController pushViewController:t_vc animated:YES];
            
        }
        
    }else{
        
        if (_arr_history && _arr_history.count > 0) {
            
            UserTaskDetailVC *t_vc = [[UserTaskDetailVC alloc] init];
            t_vc.task = _arr_history[indexPath.row];
            UIViewController * vc_target = (UserHomeVC *)[ShareFun findViewController:self.view withClass:[UserHomeVC class]];
            [vc_target.navigationController pushViewController:t_vc animated:YES];
            
        }
        
    }
    
    
}

// 取消选中某行cell会调用 (当我选中第0行的时候，如果现在要改为选中第1行 - 》会先取消选中第0行，然后调用选中第1行的操作)
- (void)tableView:(nonnull UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSLog(@"取消选中 didDeselectRowAtIndexPath row = %ld ", indexPath.row);
    
    
}

#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 55;
    
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0 ) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"UserTaskListVC dealloc");
    
}

@end
