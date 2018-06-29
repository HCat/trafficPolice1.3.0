//
//  AccidentRemarkListVC.m
//  移动采集
//
//  Created by hcat on 2017/8/14.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AccidentRemarkListVC.h"
#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "AccidentAPI.h"
#import "AccidentRemarkListCell.h"
#import <MJRefresh.h>
#import "NetWorkHelper.h"


@interface AccidentRemarkListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *arr_remarks;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_tableViewBottom;

@property (weak, nonatomic) IBOutlet UIButton *btn_addRemark;



@end

@implementation AccidentRemarkListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"备注";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewRemark:) name:NOTIFICATION_ADDREMARK_SUCCESS object:nil];
    
    self.arr_remarks = [NSArray new];
    _tableView.isNeedPlaceholderView = YES;
    _tableView.firstReload = YES;
    
    [_tableView registerNib:[UINib nibWithNibName:@"AccidentRemarkListCell" bundle:nil] forCellReuseIdentifier:@"AccidentRemarkListCellID"];
    
    [self initRefresh];
    
    WS(weakSelf);
    [_tableView setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tableView.isNetAvailable = NO;
        [strongSelf.tableView.mj_header beginRefreshing];
    }];
    
    [_tableView.mj_header beginRefreshing];
    
    if (_isHandle) {
        self.view.backgroundColor = [UIColor clearColor];
        _layout_tableViewBottom.constant = 0.f;
        [self.view layoutIfNeeded];
        _btn_addRemark.hidden = YES;
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.tableView.isNetAvailable = NO;
        [strongSelf.tableView.mj_header beginRefreshing];
    };

}


#pragma mark - 备注列表请求

- (void)loadingRemarksListRequest{

    WS(weakSelf);
    AccidentRemarkListManger *manger  = [AccidentRemarkListManger new];
    manger.accidentId = _accidentId;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        [strongSelf.tableView.mj_header endRefreshing];
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.arr_remarks = manger.list.copy;
            [strongSelf.tableView reloadData];
            
        }
    
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf,weakSelf);
        [strongSelf.tableView.mj_header endRefreshing];
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            strongSelf.arr_remarks = nil;
            strongSelf.tableView.isNetAvailable = YES;
            [strongSelf.tableView reloadData];
        }
        
    }];
}


- (void)initRefresh{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadingRemarksListRequest)];
    [header setTitle:@"下拉加载" forState:MJRefreshStateIdle];
    [header setTitle:@"松手开始加载" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
    
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_arr_remarks){
        
        return self.arr_remarks.count;
        
    }else{
        
        return 0;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"AccidentRemarkListCellID" cacheByIndexPath:indexPath configuration:^(AccidentRemarkListCell *cell) {
        
        if (_arr_remarks && _arr_remarks.count > 0) {
            RemarkModel *t_model = _arr_remarks[indexPath.row];
            cell.remarkModel = t_model;
            
        }
    }];
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AccidentRemarkListCell *cell = (AccidentRemarkListCell *)[tableView dequeueReusableCellWithIdentifier:@"AccidentRemarkListCellID"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (_arr_remarks && _arr_remarks.count > 0) {
        RemarkModel *t_model = _arr_remarks[indexPath.row];
        cell.remarkModel = t_model;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - 添加备注按钮事件

- (IBAction)handleBtnAddRemarkClicked:(id)sender {
    
}

#pragma mark - 通知事件

- (void)receiveNewRemark:(NSNotification *)notification{
    
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    LxPrintf(@"AccidentRemarkListVC dealloc");
    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
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
