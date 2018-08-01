//
//  ActionManageVC.m
//  移动采集
//
//  Created by hcat on 2018/8/1.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "ActionManageVC.h"
#import <MJRefresh.h>
#import <PureLayout.h>
#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "NetWorkHelper.h"
#import "PFNavigationDropdownMenu.h"


@interface ActionManageVC ()

@property (weak, nonatomic) IBOutlet UIView *navbar;
@property (weak, nonatomic) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_topHeight;
@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (nonatomic,strong) NSMutableArray *arr_content;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic, assign) NSInteger statusType;
@property (strong,nonatomic) PFNavigationDropdownMenu *menuView;


@end

@implementation ActionManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IPHONE_X) {
        _layout_topHeight.constant = _layout_topHeight.constant + 24;
    }
    
   
    
    self.statusType = 0;
    self.arr_content = [NSMutableArray array];
        
    [self setUpDropdownMenu];
    [self setUpTableView];
    
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

#pragma mark - set

- (void)setUpTableView{
    
    _tb_content.isNeedPlaceholderView = YES;
    _tb_content.firstReload = YES;
    
    [self initRefresh];
    [_tb_content.mj_header beginRefreshing];
    
    [_tb_content registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:@"MessageCellID"];
    
    WS(weakSelf);
    //点击重新加载之后的处理
    [_tb_content setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        [strongSelf.tb_content.mj_header beginRefreshing];
    }];
    
}

- (void)setUpDropdownMenu{
    WS(weakSelf);
    NSArray *items = @[@"全部", @"待发布",@"已发布", @"已结束"];
    
    _menuView = [[PFNavigationDropdownMenu alloc] initWithFrame:CGRectMake(0, IS_IPHONE_X ? 88 : 64, SCREEN_WIDTH, 44)
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
    
    _menuView.didSelectItemAtIndexHandler = ^(NSUInteger indexPath){
        NSLog(@"Did select item at index: %ld", indexPath);
        SW(strongSelf, weakSelf);
        if (indexPath == 0) {
            strongSelf.statusType = 0;
        }else if (indexPath == 1){
            strongSelf.statusType = 1;
        }else if (indexPath == 2){
            strongSelf.statusType = 2;
        }else if (indexPath == 3){
            strongSelf.statusType = 3;
        }
        
        [strongSelf reloadDataUseMJRefresh];
    };
    
    [self.view addSubview:_menuView];
    [_menuView configureForAutoLayout];
    [_menuView autoSetDimension:ALDimensionHeight toSize:44];
    
    if (IS_IPHONE_X) {
        [_menuView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:88];
    }else{
        [_menuView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:64];
    }
    
    [_menuView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
    [_menuView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:0];
    [self.view layoutIfNeeded];
    
    [self.view bringSubviewToFront:_navbar];
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

- (void)reloadDataUseMJRefresh{
    [_tb_content.mj_header beginRefreshing];
}

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
    
    IdentifyMsgListWithTypeParam *param = [[IdentifyMsgListWithTypeParam alloc] init];
    param.start = _index;
    param.length = 10;
    param.type = self.messageType;
    
    IdentifyMsgListWithTypeManger *manger = [[IdentifyMsgListWithTypeManger alloc] init];
    manger.param = param;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        [strongSelf.tb_content.mj_header endRefreshing];
        [strongSelf.tb_content.mj_footer endRefreshing];
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            [strongSelf.arr_content addObjectsFromArray:manger.identifyMsgListReponse.list];
            if (strongSelf.arr_content.count == manger.identifyMsgListReponse.total) {
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
    return [tableView fd_heightForCellWithIdentifier:@"MessageCellID" cacheByIndexPath:indexPath configuration:^(MessageCell *cell) {
        SW(strongSelf,weakSelf);
        if (strongSelf.arr_content && strongSelf.arr_content.count > 0) {
            IdentifyModel *t_model = strongSelf.arr_content[indexPath.row];
            cell.model = t_model;
            
        }
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCellID"];
    
    if (_arr_content && _arr_content.count > 0) {
        IdentifyModel *t_model = _arr_content[indexPath.row];
        cell.model = t_model;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    IdentifyModel *t_model = _arr_content[indexPath.row];
    
    if ([t_model.type isEqualToNumber:@4]) {
        t_model.source = @0;
        IllegalOperatCarVC *t_vc = [[IllegalOperatCarVC alloc] init];
        t_vc.model = t_model;
        [self.navigationController pushViewController:t_vc animated:YES];
    }else{
        t_model.source = @0;
        MessageDetailVC *t_vc = [[MessageDetailVC alloc] init];
        t_vc.model = t_model;
        [self.navigationController pushViewController:t_vc animated:YES];
        
    }
    
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"ActionManageVC dealloc");
    
}


@end
