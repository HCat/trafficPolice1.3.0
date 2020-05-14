//
//  SpecialNoticeVC.m
//  移动采集
//
//  Created by hcat on 2018/9/10.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "SpecialNoticeVC.h"
#import "SpecialNoticeCell.h"
#import <MJRefresh.h>
#import "UITableView+Lr_Placeholder.h"
#import "NetWorkHelper.h"
#import "SpecialCarAPI.h"
#import "UserModel.h"


@interface SpecialNoticeVC ()

@property (nonatomic,assign) NSInteger index;
@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (nonatomic,strong) NSMutableArray *arr_content;

@end

@implementation SpecialNoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择要通知的人员分组";
    
    self.arr_content = [NSMutableArray array];
    [self setUpTableView];
    
    [self.tb_content.mj_header beginRefreshing];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        [strongSelf.tb_content.mj_header beginRefreshing];
    };
    
}


- (void)setUpTableView{
    
    _tb_content.isNeedPlaceholderView = YES;
    _tb_content.firstReload = YES;
    _tb_content.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self initRefresh];
    
    WS(weakSelf);
    //点击重新加载之后的处理
    [_tb_content setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        [strongSelf.tb_content.mj_header beginRefreshing];
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

#pragma mark - 请求数据

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
    

    SpecialNoticeParam * param = [[SpecialNoticeParam alloc] init];
    param.start = _index;
    param.length = 10;
    param.groupId = _groupId;
    param.userId = @([[UserModel getUserModel].userId longLongValue]);
    
    LxDBObjectAsJson(param);
    SpecialNoticeManger *manger = [[SpecialNoticeManger alloc] init];
    manger.param = param;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        [strongSelf.tb_content.mj_header endRefreshing];
        [strongSelf.tb_content.mj_footer endRefreshing];
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            [strongSelf.arr_content addObjectsFromArray:manger.specialReponse.list];
            if (strongSelf.arr_content.count == manger.specialReponse.total) {
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



- (void)updateNoticeData:(NSString *)data{
    WS(weakSelf);
    SpecialSaveNoticeManger * manger = [[SpecialSaveNoticeManger alloc] init];
    manger.groupId = _groupId;
    manger.ids = data;
    [manger configLoadingTitle:@"提交"];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        [strongSelf.navigationController popViewControllerAnimated:YES];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}

#pragma mark - buttonAction

- (IBAction)handleBtnCommitClicked:(id)sender{
    
    NSMutableArray *arr_data = [NSMutableArray array];
    for (int i = 0; i < _arr_content.count; i++) {
        
        SpecialNoticeModel * model = _arr_content[i];
        if (model.flag == 0) {
            [arr_data addObject:model.noticeId];
        }
    
    }
    
    NSString * data = [arr_data componentsJoinedByString:@","];
    [self updateNoticeData:data];
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_content.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 52;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SpecialNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpecialNoticeCellID"];
    
    if (!cell) {
        [self.tb_content registerNib:[UINib nibWithNibName:@"SpecialNoticeCell" bundle:nil] forCellReuseIdentifier:@"SpecialNoticeCellID"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"SpecialNoticeCellID"];
        
    }
    
    SpecialNoticeModel *model = _arr_content[indexPath.row];
    cell.model = model;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SpecialNoticeModel *model = _arr_content[indexPath.row];
    if (model.flag == 1) {
        model.flag = 0;
    }else{
        model.flag = 1;
    }

    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    

}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 53, 0, 0)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 53, 0, 0)];
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"SpecialNoticeVC dealloc");
}

@end
