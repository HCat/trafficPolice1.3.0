//
//  SpecialVehicleVC.m
//  移动采集
//
//  Created by hcat on 2018/9/7.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "SpecialVehicleVC.h"
#import <MJRefresh.h>
#import <PureLayout.h>
#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "NetWorkHelper.h"
#import "PFNavigationDropdownMenu.h"
#import "SpecialVehicleCell.h"
#import "SpecialVehicleDetailVC.h"
#import "SpecialManageVC.h"
#import "SpecialCarAPI.h"

@interface SpecialVehicleVC ()

@property (weak, nonatomic) IBOutlet UIView *v_searchBar;;
@property (weak, nonatomic) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_searchHeight;
@property (nonatomic,copy) NSString *str_search;

@property (weak, nonatomic) IBOutlet UIView *v_normalBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_normalHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_tableViewTop;

@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic, assign) NSInteger statusType;
@property (strong,nonatomic) PFNavigationDropdownMenu *menuView;

@property (nonatomic,strong) NSMutableArray * arr_content;
@property (nonatomic,strong) NSMutableArray * arr_group;


@end

@implementation SpecialVehicleVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    if (_type == 1) {
        
        _v_normalBar.hidden = NO;
        _v_searchBar.hidden = YES;
        _layout_searchHeight.constant = 0;
        if (IS_IPHONE_X) {
            _layout_normalHeight.constant = _layout_normalHeight.constant + 24;
            _layout_tableViewTop.constant = _layout_tableViewTop.constant + 24;
        }
        
        
        
    }else if (_type == 2){
        
        _v_normalBar.hidden = YES;
        _v_searchBar.hidden = NO;
        _layout_normalHeight.constant = 0;
        
        _layout_tableViewTop.constant = _layout_tableViewTop.constant - 44;
        
        if (IS_IPHONE_X) {
            _layout_searchHeight.constant = _layout_searchHeight.constant + 24;
            _layout_tableViewTop.constant = _layout_tableViewTop.constant + 24;
        }
        
    }
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(specialAddGroup:) name:NOTIFICATION_SPECIAL_ADDGROUP object:nil];
    
    self.arr_content = [NSMutableArray array];
    [self setUpTableView];
    
    if (_type == 1) {
        [self loadSpecialGroupData];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        [strongSelf.tb_content.mj_header beginRefreshing];
    };
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
    
}



#pragma mark - set

- (void)setUpDropdownMenu:(NSArray *)items{
    WS(weakSelf);
    NSMutableArray *items_t = [NSMutableArray array];
    
    for (int i = 0; i < items.count; i++) {
        
        if (i ==0) {
            [items_t addObject:items[i]];
        }else{
            SpecialCarModel *model = items[i];
            [items_t addObject:model.name];
        }
        
    }
    
    
    if (_menuView) {
        [_menuView removeFromSuperview];
        _menuView = nil;
    }
    
    CGFloat height = 0;
    
    height = IS_IPHONE_X ? 88 : 64;
    
    _menuView = [[PFNavigationDropdownMenu alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, 44)
                                                          title:items_t.firstObject
                                                          items:items_t
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
        strongSelf.statusType = indexPath;
        [strongSelf.tb_content.mj_header beginRefreshing];
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
    
    [self.view bringSubviewToFront:_v_normalBar];
    
    
    
}


- (void)setUpTableView{
    
    _tb_content.isNeedPlaceholderView = YES;
    _tb_content.firstReload = NO;
    
    [self initRefresh];
    
    [_tb_content registerNib:[UINib nibWithNibName:@"SpecialVehicleCell" bundle:nil] forCellReuseIdentifier:@"SpecialVehicleCellID"];
    
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

#pragma mark - 加载新数据

- (void)loadSpecialGroupData{
    
    self.statusType = 0;
    self.arr_group = [NSMutableArray array];
    [self.arr_group addObject:@"全部"];
    
    
    WS(weakSelf);
    SpecialGroupListParam * param = [[SpecialGroupListParam alloc] init];
    param.start = 0;
    param.length = 1000;
    
    SpecialGroupListManger *manger = [[SpecialGroupListManger alloc] init];
    manger.param = param;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        [strongSelf.arr_group addObjectsFromArray:manger.specialReponse.list];
        [strongSelf setUpDropdownMenu:strongSelf.arr_group];
        [strongSelf.tb_content.mj_header beginRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        [strongSelf.tb_content.mj_header beginRefreshing];
    }];
    
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
    
    if (_type == 2) {
        if (_str_search.length == 0) {
            [self.tb_content.mj_header endRefreshing];
            [self.tb_content.mj_footer endRefreshing];
            [self.tb_content reloadData];
            return;
        }
        
    }
    
    
    SpecialRecordListParam * param = [[SpecialRecordListParam alloc] init];
    param.start = _index;
    param.length = 10;
    if (self.statusType > 0) {
        SpecialCarModel *model = self.arr_group[self.statusType];
        param.groupId = model.carId;
    }
    if (_str_search.length > 0) {
        param.carno = _tf_search.text;
    }
    
    LxDBObjectAsJson(param);
    SpecialRecordListManger *manger = [[SpecialRecordListManger alloc] init];
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

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_content.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WS(weakSelf);
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"SpecialVehicleCellID" configuration:^(SpecialVehicleCell *cell) {
        SW(strongSelf, weakSelf);
        if (strongSelf.arr_content && strongSelf.arr_content.count > 0) {
            SpecialRecordModel *t_model = strongSelf.arr_content[indexPath.row];
            cell.model = t_model;
        }
    }];
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SpecialVehicleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpecialVehicleCellID"];
    
    if (_arr_content && _arr_content.count > 0) {
        SpecialRecordModel *t_model = _arr_content[indexPath.row];
        cell.model = t_model;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SpecialVehicleDetailVC *t_vc = [[SpecialVehicleDetailVC alloc] init];
    SpecialRecordModel *model = _arr_content[indexPath.row];
    t_vc.model = model;
   
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

#pragma mark - buttonAction

- (IBAction)handleBtnSearchClicked:(id)sender {
    
    SpecialVehicleVC *vc = [[SpecialVehicleVC alloc] init];
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)handleBtnBackClicked:(id)sender {
    if (self.navigationController.viewControllers.count == 1) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (IBAction)hadleBtnManageClicked:(id)sender {
    SpecialManageVC * vc = [[SpecialManageVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
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

#pragma mark - notice

- (void)specialAddGroup:(NSNotification *)notice{
    
    if (_type == 1) {
        [self loadSpecialGroupData];
    }
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SPECIAL_ADDGROUP object:nil];
    LxPrintf(@"SpecialVehicleVC dealloc");
    
}

@end
