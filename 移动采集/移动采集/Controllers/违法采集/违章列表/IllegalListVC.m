//
//  IllegalListVC.m
//  trafficPolice
//
//  Created by hcat on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalListVC.h"
#import <MJRefresh.h>

#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "IllegalParkAPI.h"
#import "IllegalThroughAPI.h"
#import "IllegalCell.h"

#import "NetWorkHelper.h"
#import "IllegalDetailVC.h"


@interface IllegalListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tb_content;

@property (nonatomic,strong) NSMutableArray *arr_content;

@property (nonatomic,assign) NSInteger index; //加载更多数据索引

@property (weak, nonatomic) IBOutlet UITextField *tf_search;

@property (weak, nonatomic) IBOutlet UIView *v_search;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_viewSearch_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_viewSearch_top;

@property (nonatomic,copy) NSString *str_search;


@end

@implementation IllegalListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.str_search = _tf_search.text;
    
    
    _tb_content.isNeedPlaceholderView = YES;
    _tb_content.firstReload = YES;
    //隐藏多余行的分割线
    _tb_content.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tb_content setSeparatorInset:UIEdgeInsetsZero];
    [_tb_content setLayoutMargins:UIEdgeInsetsZero];
    
    [_tb_content registerNib:[UINib nibWithNibName:@"IllegalCell" bundle:nil] forCellReuseIdentifier:@"IllegalCellID"];
    
    self.arr_content = [NSMutableArray array];
    
    [self initRefresh];
    
    if (_type == 1) {
        
        @weakify(self);
        [self zx_setRightBtnWithImgName:@"btn_search" clickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
            @strongify(self);
            [self handleBtnSearchClicked:nil];
        }];
        
        if (_illegalType == IllegalTypePark) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(illegalSuccess:) name:NOTIFICATION_ILLEGALPARK_SUCCESS object:nil];
        }else if (_illegalType == IllegalTypeThrough){
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(illegalSuccess:) name:NOTIFICATION_ILLEGALTHROUGH_SUCCESS object:nil];
        }
        [_tb_content.mj_header beginRefreshing];
        
        _v_search.hidden = YES;
        _layout_viewSearch_height.constant = 0;
        
        
    }else if(_type == 2){
        
        self.zx_hideBaseNavBar = YES;
        if (IS_IPHONE_X_MORE){
            _layout_viewSearch_height.constant = _layout_viewSearch_height.constant + 24 ;
            
        }
        
        _layout_viewSearch_top.constant = - Height_StatusBar;
        
        
    }
    
    WS(weakSelf);
    //点击重新加载之后的处理
    [_tb_content setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        strongSelf.index = 0;
        [strongSelf.tb_content.mj_header beginRefreshing];
    }];
    
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_type == 2) {
        self.navigationController.navigationBarHidden = YES;
    }
    
    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        strongSelf.index = 0;
        [strongSelf.tb_content.mj_header beginRefreshing];
    };
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    if (_type == 2) {
        self.navigationController.navigationBarHidden = NO;
    }
    
    [super viewWillDisappear:animated];
    
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
    
    if (_type == 2) {
        if (_str_search.length == 0) {
            [self.tb_content.mj_header endRefreshing];
            [self.tb_content.mj_footer endRefreshing];
            [self.tb_content reloadData];
            return;
            
        }
        
    }
    
    if (_illegalType == IllegalTypePark) {
        
        IllegalParkListPagingParam *param = [[IllegalParkListPagingParam alloc] init];
        param.start = _index;
        param.length = 10;
        param.type = @(_subType);
        if (_str_search.length > 0) {
            param.search = _str_search;
        }
        
        IllegalParkListPagingManger *manger = [[IllegalParkListPagingManger alloc] init];
        manger.param = param;
       
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf, weakSelf);
            [strongSelf.tb_content.mj_header endRefreshing];
            [strongSelf.tb_content.mj_footer endRefreshing];
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                
                [strongSelf.arr_content addObjectsFromArray:manger.illegalParkListPagingReponse.list];
                if (strongSelf.arr_content.count == manger.illegalParkListPagingReponse.total) {
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
        
    }else if (_illegalType == IllegalTypeThrough){
        
        IllegalThroughListPagingParam *param = [[IllegalThroughListPagingParam alloc] init];
        param.start = _index;
        param.length = 10;
        if (_str_search.length > 0) {
            param.search = _str_search;
        }
    
        IllegalThroughListPagingManger *manger = [[IllegalThroughListPagingManger alloc] init];
        manger.param = param;
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf, weakSelf);
            [strongSelf.tb_content.mj_header endRefreshing];
            [strongSelf.tb_content.mj_footer endRefreshing];
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                
                [strongSelf.arr_content addObjectsFromArray:manger.illegalThroughListPagingReponse.list];
                if (strongSelf.arr_content.count == manger.illegalThroughListPagingReponse.total) {
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
            IllegalParkListModel *t_model = strongSelf.arr_content[indexPath.row];
            cell.model = t_model;

        }
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IllegalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalCellID"];
    cell.fd_enforceFrameLayout = NO;
    if (_arr_content && _arr_content.count > 0) {
        IllegalParkListModel *t_model = _arr_content[indexPath.row];
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
    
    if (_arr_content && _arr_content.count > 0) {
        
        IllegalParkListModel *t_model = _arr_content[indexPath.row];
        IllegalDetailVC *t_vc = [[IllegalDetailVC alloc] init];
        t_vc.illegalType = _illegalType;
        t_vc.subType = _subType;
        t_vc.illegalId = t_model.illegalParkId;
        [self.navigationController pushViewController:t_vc animated:YES];
    }
    
}

#pragma mark - buttonAction

- (IBAction)handleBtnSearchClicked:(id)sender {
    
    IllegalListVC *vc = [[IllegalListVC alloc] init];
    vc.illegalType = _illegalType;
    vc.subType = _subType;
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(IBAction)handleBtnBackClicked:(id)sender{
    
    if (self.navigationController.viewControllers.count == 1) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

#pragma mark - UItextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    _str_search = textField.text;
    if (_str_search.length == 0) {
        [LRShowHUD showError:@"请输入搜索内容" duration:1.5f];
    }
    [self.tb_content.mj_header beginRefreshing];
    return YES;
}

#pragma mark - Notification

- (void)illegalSuccess:(NSNotification *)notification{
    [_tb_content.mj_header beginRefreshing];

}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    if (_illegalType == IllegalTypePark) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ILLEGALPARK_SUCCESS object:nil];
    }else if (_illegalType == IllegalTypeThrough){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ILLEGALTHROUGH_SUCCESS object:nil];
    }
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
    
    LxPrintf(@"IllegalList dealloc");
    
}
@end
