//
//  ActionVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/20.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ActionVC.h"

#import "ActionAPI.h"

#import <PureLayout.h>
#import <MJRefresh.h>
#import "UITableView+Lr_Placeholder.h"
#import "NetWorkHelper.h"

#import "PFNavigationDropdownMenu.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ActionDetailCell.h"
#import "UserTaskDetailVC.h"
#import "SRAlertView.h"


@interface ActionVC ()

@property (weak, nonatomic) IBOutlet UITableView *tb_task;
@property (nonatomic, assign) NSInteger taskStatus; // -1 全部，1进行中，2已完成
@property (strong,nonatomic) PFNavigationDropdownMenu *menuView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *arr_tasks;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_tableView_top;


@end

@implementation ActionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arr_tasks = [NSMutableArray array];
    self.index = 0;
    self.taskStatus = -1;
    self.title = @"行动";
    self.layout_tableView_top.constant = - Height_NavBar - 44;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAction:) name:NOTIFICATION_RECEIVENOTIFICATION_ACTION object:nil];
    
    [self configTaskView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        
        SW(strongSelf, weakSelf);
        strongSelf.tb_task.isNetAvailable = NO;
        [strongSelf.tb_task.mj_header beginRefreshing];
        
    };
    
}


- (void)configTaskView{
    
    
    _tb_task.isNeedPlaceholderView = YES;
    _tb_task.firstReload = YES;
    
    [self initRefresh];
    [_tb_task.mj_header beginRefreshing];
    
    [_tb_task registerNib:[UINib nibWithNibName:@"ActionDetailCell" bundle:nil] forCellReuseIdentifier:@"ActionDetailCellID"];
    
    WS(weakSelf);
    //点击重新加载之后的处理
    [_tb_task setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_task.isNetAvailable = NO;
        [strongSelf.tb_task.mj_header beginRefreshing];
    }];
    
    [self setUpDropdownMenu];
    
}

- (void)setUpDropdownMenu{
    
    NSArray *items = @[@"全部", @"进行中", @"已完成"];
    
    _menuView = [[PFNavigationDropdownMenu alloc] initWithFrame:CGRectMake(0, Height_NavBar, SCREEN_WIDTH, 44)
                                                          title:items.firstObject
                                                          items:items
                                                  containerView:self.view];
    _menuView.backgroundColor = [UIColor whiteColor];
    
    _menuView.cellHeight = 50;
    _menuView.cellBackgroundColor = [UIColor whiteColor];
    _menuView.cellSelectionColor = [UIColor whiteColor];
    _menuView.cellTextLabelColor = DefaultTextColor;
    _menuView.cellTextLabelFont = [UIFont systemFontOfSize:14.f];
    _menuView.arrowImage = [UIImage imageNamed:@"icon_dropdown_down"];
    _menuView.checkMarkImage = [UIImage imageNamed:@"icon_dropdown_selected"];
    _menuView.arrowPadding = 15;
    _menuView.animationDuration = 0.5f;
    _menuView.maskBackgroundColor = [UIColor blackColor];
    _menuView.maskBackgroundOpacity = 0.3f;
    WS(weakSelf);
    _menuView.didSelectItemAtIndexHandler = ^(NSUInteger indexPath){
        NSLog(@"Did select item at index: %ld", indexPath);
        SW(strongSelf, weakSelf);
        if (indexPath == 0) {
            strongSelf.taskStatus = - 1;
        }else{
            strongSelf.taskStatus = indexPath;
        }
        
        [strongSelf reloadTaskData];
        
    };
    
    [self.view addSubview:_menuView];
    [_menuView configureForAutoLayout];
    [_menuView autoSetDimension:ALDimensionHeight toSize:44];
    [_menuView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:Height_NavBar];
    [_menuView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
    [_menuView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:0];
    
}


#pragma mark - 创建下拉刷新，以及上拉加载更多

- (void)initRefresh{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadTaskData)];
    [header setTitle:@"下拉查询" forState:MJRefreshStateIdle];
    [header setTitle:@"松手开始查询" forState:MJRefreshStatePulling];
    [header setTitle:@"查询中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    _tb_task.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadTaskData)];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"— 没有更多内容了 —" forState:MJRefreshStateNoMoreData];
    
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    footer.stateLabel.textColor = UIColorFromRGB(0xa6a6a6);
    _tb_task.mj_footer = footer;
    _tb_task.mj_footer.automaticallyHidden = YES;
    
}

#pragma mark - 请求任务数据

- (void)reloadTaskData{
    self.index = 0;
    [self loadTaskData];
}

- (void)loadTaskData{
    
    if (_index == 0) {
        if (_arr_tasks && _arr_tasks.count > 0) {
            [_arr_tasks removeAllObjects];
        }
    }
    
    WS(weakSelf);
    ActionGetTypeListParam *param = [[ActionGetTypeListParam alloc] init];
    param.start = _index;
    param.length = 10;
    if (self.taskStatus != -1 ) {
         param.actionStatus = @(self.taskStatus);
    }
   
    ActionGetTypeListManger *manger = [[ActionGetTypeListManger alloc] init];
    manger.param = param;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        
        [strongSelf.tb_task.mj_header endRefreshing];
        [strongSelf.tb_task.mj_footer endRefreshing];
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            [strongSelf.arr_tasks addObjectsFromArray:manger.actionReponse.list];
            if (strongSelf.arr_tasks.count == manger.actionReponse.total) {
                [strongSelf.tb_task.mj_footer endRefreshingWithNoMoreData];
            }else{
                strongSelf.index += param.length;
            }
            
            [strongSelf.tb_task reloadData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        [strongSelf.tb_task.mj_header endRefreshing];
        [strongSelf.tb_task.mj_footer endRefreshing];
        
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            if (strongSelf.arr_tasks.count > 0) {
                [strongSelf.arr_tasks removeAllObjects];
            }
            strongSelf.tb_task.isNetAvailable = YES;
            [strongSelf.tb_task reloadData];
        }
        
    }];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_tasks.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf);
    return [tableView fd_heightForCellWithIdentifier:@"ActionDetailCellID" cacheByIndexPath:indexPath configuration:^(ActionDetailCell *cell) {
        SW(strongSelf,weakSelf);
        if (strongSelf.arr_tasks && strongSelf.arr_tasks.count > 0) {
            ActionTaskListModel *t_model = strongSelf.arr_tasks[indexPath.row];
            cell.model = t_model;
            
        }
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ActionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActionDetailCellID"];
    
    if (_arr_tasks && _arr_tasks.count > 0) {
        ActionTaskListModel *t_model = _arr_tasks[indexPath.row];
        cell.model = t_model;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_arr_tasks && _arr_tasks.count > 0) {
        
        UserTaskDetailVC *t_vc = [[UserTaskDetailVC alloc] init];
        t_vc.model = _arr_tasks[indexPath.row];
        [self.navigationController pushViewController:t_vc animated:YES];
        
    }
    
}

#pragma mark - notification

- (void)receiveAction:(NSNotification *)notice{
    
    NSDictionary *aps = notice.object;
    
    if (aps) {
        WS(weakSelf);
        SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:[aps objectForKey:@"alert"]
                                                    leftActionTitle:nil
                                                   rightActionTitle:@"确定"
                                                     animationStyle:AlertViewAnimationNone
                                                       selectAction:^(AlertViewActionType actionType) {
                                                           SW(strongSelf, weakSelf);
                                                           [strongSelf reloadTaskData];
                                                           
                                                           
                                                       }];
        alertView.blurCurrentBackgroundView = NO;
        [alertView show];
        
        return;
    }
    
    [self reloadTaskData];
    
}


@end
