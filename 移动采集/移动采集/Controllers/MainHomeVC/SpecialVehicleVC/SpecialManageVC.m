//
//  SpecialManageVC.m
//  移动采集
//
//  Created by hcat on 2018/9/10.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "SpecialManageVC.h"
#import <MJRefresh.h>
#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "NetWorkHelper.h"
#import "SpecialCarAPI.h"
#import "SpecialGroupCell.h"
#import "SpecialMemberCell.h"
#import "SpecialNoticeVC.h"

#import "SpecialAddCar.h"
#import "SpecialEditGroupView.h"
#import "SpecialDeleteCar.h"

@interface SpecialManageVC ()

@property (weak, nonatomic) IBOutlet UITableView *tb_group;
@property (nonatomic,strong) NSMutableArray *arr_group;
@property (nonatomic,assign) NSInteger select_row;

@property (weak, nonatomic) IBOutlet UITableView *tb_car;
@property (nonatomic,assign) NSInteger index_car;
@property (nonatomic,strong) NSMutableArray *arr_car;

@property (nonatomic,strong) NSNumber *groupId;

@end

@implementation SpecialManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"特殊车辆管理";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(specialEditCar:) name:NOTIFICATION_SPECIAL_EDITCAR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(specialAddCar:) name:NOTIFICATION_SPECIAL_ADDCAR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(specialEditGroup:) name:NOTIFICATION_SPECIAL_EDITGROUP object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(specialAddGroup:) name:NOTIFICATION_SPECIAL_ADDGROUP object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(specialDeleteCar:) name:NOTIFICATION_SPECIAL_DELETECAR object:nil];
    
    
    self.arr_car = [NSMutableArray array];
    self.arr_group = [NSMutableArray array];
    self.select_row = -1;
    self.groupId = @(-1);
    
    [self setUpTableView];
    
    [self reloadGroupData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_car.isNetAvailable = NO;
        [strongSelf.tb_group.mj_header beginRefreshing];
        [strongSelf.tb_car.mj_header beginRefreshing];
    };
    
}


#pragma mark - 请求数据


- (void)setUpTableView{
    
    _tb_car.isNeedPlaceholderView = YES;
    _tb_car.firstReload = YES;
    [self.tb_car registerNib:[UINib nibWithNibName:@"SpecialMemberCell" bundle:nil] forCellReuseIdentifier:@"SpecialMemberCellID"];
    _tb_car.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _tb_group.isNeedPlaceholderView = NO;
    [self.tb_group registerNib:[UINib nibWithNibName:@"SpecialGroupCell" bundle:nil] forCellReuseIdentifier:@"SpecialGroupCellID"];
    _tb_group.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    
    [self initRefresh];
    
    WS(weakSelf);
    //点击重新加载之后的处理
    [_tb_car setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_car.isNetAvailable = NO;
        [strongSelf.tb_car.mj_header beginRefreshing];
        
    }];
    
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
    _tb_car.mj_header = header;
    
    
    MJRefreshNormalHeader *header_group = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadGroupData)];
    [header_group setTitle:@"下拉查询" forState:MJRefreshStateIdle];
    [header_group setTitle:@"松手开始查询" forState:MJRefreshStatePulling];
    [header_group setTitle:@"查询中..." forState:MJRefreshStateRefreshing];
    header_group.stateLabel.font = [UIFont systemFontOfSize:15];
    
    header_group.automaticallyChangeAlpha = YES;
    header_group.lastUpdatedTimeLabel.hidden = YES;
    _tb_group.mj_header = header_group;
    
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"— 没有更多内容了 —" forState:MJRefreshStateNoMoreData];
    
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    footer.stateLabel.textColor = UIColorFromRGB(0xa6a6a6);
    _tb_car.mj_footer = footer;
    _tb_car.mj_footer.automaticallyHidden = YES;
    
}


- (void)reloadGroupData{
    WS(weakSelf);
    
    if (_arr_group && _arr_group.count > 0) {
        [_arr_group removeAllObjects];
    }
    
    SpecialGroupListParam * param = [[SpecialGroupListParam alloc] init];
    param.start = 0;
    param.length = 1000;
    
    LxDBObjectAsJson(param);
    SpecialGroupListManger * manger = [[SpecialGroupListManger alloc] init];
    manger.param = param;
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        [strongSelf.tb_group.mj_header endRefreshing];
        [strongSelf.tb_group.mj_footer endRefreshing];
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            [strongSelf.arr_group addObjectsFromArray:manger.specialReponse.list];
            
            if (strongSelf.arr_group && strongSelf.arr_group.count > 0) {
                if ([self.groupId isEqualToNumber:@(-1)]) {
                    SpecialCarModel *model = strongSelf.arr_group[0];
                    strongSelf.groupId = model.carId;
                    strongSelf.select_row = 0;

                }
                
                [strongSelf.tb_car.mj_header beginRefreshing];
                
            }
            
            SpecialCarModel *model = [[SpecialCarModel alloc] init];
            model.carId = @(-2);
            [strongSelf.arr_group addObject:model];
        
            [strongSelf.tb_group reloadData];
        }else{
            NSString *t_errString = [NSString stringWithFormat:@"网络错误:code:%ld msg:%@",manger.responseModel.code,manger.responseModel.msg];
            [LRShowHUD showError:t_errString duration:1.5 inView:strongSelf.view config:nil];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf,weakSelf);
        [strongSelf.tb_group.mj_header endRefreshing];
        [strongSelf.tb_group.mj_footer endRefreshing];
        
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            if (strongSelf.arr_group.count > 0) {
                [strongSelf.arr_group removeAllObjects];
            }
            
            [strongSelf.tb_group reloadData];
        }
        
    }];
    
    
}

- (void)reloadData{
    self.index_car = 0;
    [self loadData];
}

- (void)loadData{
    
    WS(weakSelf);
    if (_index_car == 0) {
        if (_arr_car && _arr_car.count > 0) {
            [_arr_car removeAllObjects];
        }
    }
    
    
    SpecialGroupListParam * param = [[SpecialGroupListParam alloc] init];
    param.start = 0;
    param.length = 10;
    param.parentId = _groupId;
    
    LxDBObjectAsJson(param);
    SpecialGroupListManger * manger = [[SpecialGroupListManger alloc] init];
    manger.param = param;
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        [strongSelf.tb_car.mj_header endRefreshing];
        [strongSelf.tb_car.mj_footer endRefreshing];
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            [strongSelf.arr_car addObjectsFromArray:manger.specialReponse.list];
            if (strongSelf.arr_car.count == manger.specialReponse.total) {
                [strongSelf.tb_car.mj_footer endRefreshingWithNoMoreData];
            }else{
                strongSelf.index_car += param.length;
            }
            [strongSelf.tb_car reloadData];
        }else{
            NSString *t_errString = [NSString stringWithFormat:@"网络错误:code:%ld msg:%@",manger.responseModel.code,manger.responseModel.msg];
            [LRShowHUD showError:t_errString duration:1.5 inView:strongSelf.view config:nil];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf,weakSelf);
        [strongSelf.tb_car.mj_header endRefreshing];
        [strongSelf.tb_car.mj_footer endRefreshing];
        
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            if (strongSelf.arr_car.count > 0) {
                [strongSelf.arr_car removeAllObjects];
            }
            strongSelf.tb_car.isNetAvailable = YES;
            [strongSelf.tb_car reloadData];
        }
        
        
    }];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _tb_group) {
        return _arr_group.count;
    }else{
        return _arr_car.count;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tb_group) {
        
        if (indexPath.row == _arr_group.count - 1) {
            return 53.f;
        }
        
        WS(weakSelf);
        CGFloat height = [tableView fd_heightForCellWithIdentifier:@"SpecialGroupCellID" configuration:^(SpecialGroupCell *cell) {
            SW(strongSelf, weakSelf);
            if (strongSelf.arr_group && strongSelf.arr_group.count > 0) {
                SpecialCarModel *t_model = strongSelf.arr_group[indexPath.row];
                cell.groupId = strongSelf.groupId;
                cell.model = t_model;
            }
        }];
        
        return height;
    
    }else{
        return 44;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tb_group) {
        SpecialGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpecialGroupCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        SpecialCarModel *t_model = self.arr_group[indexPath.row];
        cell.groupId = self.groupId;
        cell.model = t_model;
        
        return cell;
    }else{
        SpecialMemberCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SpecialMemberCellID"];
    
        SpecialCarModel *t_model = self.arr_car[indexPath.row];
        cell.model = t_model;
        cell.editBlock = ^(SpecialCarModel *model) {
            SpecialAddCar * car = [SpecialAddCar initCustomView];
            car.model = model;
            car.title = @"编辑车辆";
            car.isEdit = YES;
            [car show];
        };
        cell.deleteBlock = ^(SpecialCarModel *model) {
            SpecialDeleteCar * car = [SpecialDeleteCar initCustomView];
            car.model = model;
            [car show];
        };
        
        return cell;
        
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _tb_group) {
        
        if (indexPath.row == _arr_group.count - 1) {
            
            SpecialEditGroupView * view = [SpecialEditGroupView initCustomView];
            view.title = @"新建组";
            view.subTitle = @"请输入新建的组名";
            [view show];
            
        }else{
            
            if (self.select_row != indexPath.row) {
                SpecialCarModel *t_model = self.arr_group[indexPath.row];
                self.groupId = t_model.carId;
                self.select_row = indexPath.row;
                [self.tb_group reloadData];
                [self.tb_car.mj_header beginRefreshing];
            }
            
        }
       
    }else{
         SpecialCarModel *t_model = self.arr_car[indexPath.row];
        SpecialAddCar * car = [SpecialAddCar initCustomView];
        car.title = @"车辆信息";
        car.model = t_model;
        car.isEdit = NO;
        [car show];
        
    }
    

}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tb_group) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        
    }else{
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 21, 0, 0)];
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 21, 0, 0)];
    }
    
}


#pragma mark - buttonAction

- (IBAction)handleBtnEditClicked:(id)sender {
    
    if (self.select_row != -1) {
        SpecialCarModel * model = _arr_group[self.select_row];
        
        SpecialEditGroupView * view = [SpecialEditGroupView initCustomView];
        view.title = @"编辑组";
        view.subTitle = @"请输入修改后的组名";
        view.model = model;
        [view show];
    }
    
}

- (IBAction)handleBtnAddClicked:(id)sender {
    
    SpecialAddCar * car = [SpecialAddCar initCustomView];
    car.title = @"添加车辆";
    car.groupId = _groupId;
    car.isEdit = YES;
    [car show];
    
}

- (IBAction)handleBtnNoticeClicked:(id)sender {
    
    SpecialNoticeVC * vc = [[SpecialNoticeVC alloc] init];
    vc.groupId = _groupId;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


#pragma mark - notication

- (void)specialEditCar:(NSNotification *)notice{
    
    [self.tb_car reloadData];

}

- (void)specialAddCar:(NSNotification *)notice{
    
    [self.tb_car.mj_header beginRefreshing];
    
}

- (void)specialEditGroup:(NSNotification *)notice{
    
    [self.tb_group reloadData];
    
}

- (void)specialAddGroup:(NSNotification *)notice{
    
    [self.tb_group.mj_header beginRefreshing];
    
}

- (void)specialDeleteCar:(NSNotification *)notice{
    
    SpecialCarModel * model = notice.object;
    [self.arr_car removeObject:model];
    [self.tb_car reloadData];
    
    
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"SpecialManageVC dealloc");
}

@end
