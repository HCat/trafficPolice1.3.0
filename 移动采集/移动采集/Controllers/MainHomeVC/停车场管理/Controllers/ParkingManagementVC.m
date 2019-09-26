//
//  ParkingManagementVC.m
//  移动采集
//
//  Created by hcat on 2019/9/11.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingManagementVC.h"
#import "ParkingManageViewModel.h"
#import <MJRefresh.h>
#import "UITableView+Lr_Placeholder.h"
#import "NetWorkHelper.h"
#import "ParkingManageListCell.h"

@interface ParkingManagementVC ()

@property (weak, nonatomic) IBOutlet UIButton * btn_back;
@property (weak, nonatomic) IBOutlet UIButton * btn_search;
@property (weak, nonatomic) IBOutlet UIButton * btn_scan;
@property (weak, nonatomic) IBOutlet UIButton * btn_add;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_topViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_searchHeight;

@property (weak, nonatomic) IBOutlet UIView *v_search;

@property (weak, nonatomic) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UIButton *btn_type;

@property (weak, nonatomic) IBOutlet UIView *v_type;

@property (weak, nonatomic) IBOutlet UIButton *btn_carNumber;
@property (weak, nonatomic) IBOutlet UILabel *lb_carNumber;
@property (weak, nonatomic) IBOutlet UIImageView *img_carNumber;

@property (weak, nonatomic) IBOutlet UIButton *btn_forceNumber;
@property (weak, nonatomic) IBOutlet UILabel *lb_forceNumber;
@property (weak, nonatomic) IBOutlet UIImageView *img_forceNumber;

@property (weak, nonatomic) IBOutlet UIButton *btn_carframeNumber;
@property (weak, nonatomic) IBOutlet UILabel *lb_carframeNumber;
@property (weak, nonatomic) IBOutlet UIImageView *img_carframeNumber;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) ParkingManageViewModel * viewModel;


@end

@implementation ParkingManagementVC

- (instancetype)init{
    
    if (self = [super init]) {
        self.viewModel = [[ParkingManageViewModel alloc] init];
    }
    
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
   
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
    
}


#pragma mark - configUI

- (void)configUI{
    
    @weakify(self);
    
    self.v_search.hidden = YES;
    self.v_type.hidden = YES;
    
    
    if (IS_IPHONE_X_MORE){
        _layout_topViewHeight.constant = _layout_topViewHeight.constant + 24;
        _layout_searchHeight.constant = _layout_searchHeight.constant + 24;
    }
    
    //返回按钮点击
    [[_btn_back rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    //搜索按钮点击
    [[_btn_search rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.tf_search becomeFirstResponder];
        self.v_search.hidden = NO;
        
    }];
    
    //扫描按钮点击
    [[_btn_scan rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        
    }];
    
    //添加按钮点击
    [[_btn_add rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        
    }];
    
    
    //点击取消按钮
    [[self.btn_cancel rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.tf_search resignFirstResponder];
        self.viewModel.keywords = nil;
        self.viewModel.type = @0;
        
        self.v_search.hidden = YES;
        self.v_type.hidden = YES;
    }];
    
    //点击类型选项按钮
    [[self.btn_type rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.v_type.hidden = NO;
        
    }];
    
    
    //点击车牌号码选项按钮
    [[self.btn_carNumber rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.viewModel.type = @0;
        self.v_type.hidden = YES;
    }];
    
    //点击强制编号选项按钮
    [[self.btn_forceNumber rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.viewModel.type = @1;
        self.v_type.hidden = YES;
    }];
    
    //点击车架号选项按钮
    [[self.btn_carframeNumber rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.viewModel.type = @2;
        self.v_type.hidden = YES;
    }];
    
    
    self.btn_search.layer.cornerRadius = 30.f/2;
    self.tf_search.layer.cornerRadius = 30.f/2;
    
    self.tableView.isNeedPlaceholderView = YES;
    self.tableView.str_placeholder = @"暂无在库车辆";
    self.tableView.firstReload = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"ParkingManageListCell" bundle:nil] forCellReuseIdentifier:@"ParkingManageListCellID"];
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    //点击重新加载之后的处理
    [self.tableView setReloadBlock:^{
        @strongify(self);
        self.tableView.isNetAvailable = NO;
        [self.tableView.mj_header beginRefreshing];
    }];
    
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        @strongify(self);
        self.tableView.isNetAvailable = NO;
        [self.tableView.mj_header beginRefreshing];
    };
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    [header setTitle:@"下拉查询" forState:MJRefreshStateIdle];
    [header setTitle:@"松手开始查询" forState:MJRefreshStatePulling];
    [header setTitle:@"查询中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"— 没有更多内容了 —" forState:MJRefreshStateNoMoreData];
    
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    footer.stateLabel.textColor = UIColorFromRGB(0xa6a6a6);
    self.tableView.mj_footer = footer;
    self.tableView.mj_footer.automaticallyHidden = YES;
    
    
}


#pragma mark - bindViewModel

-(void)bindViewModel{
    
    @weakify(self);
    
    [self.viewModel.searchCommand.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([x isEqualToString:@"请求最后一条成功"]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else if([x isEqualToString:@"加载失败"]){
            
            if (self.viewModel.arr_data.count > 0) {
                [self.viewModel.arr_data removeAllObjects];
            }
            
            Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
            NetworkStatus status = [reach currentReachabilityStatus];
            if (status == NotReachable) {
                self.tableView.isNetAvailable = YES;
                [self.tableView reloadData];
            }
            
            
        }
        
        [self.tableView reloadData];
        

    }];
    
    
    
    
    [RACObserve(self.viewModel, type) subscribeNext:^(NSNumber *  _Nullable x) {
        
        @strongify(self);
        
        if ([x integerValue] == 0) {
            //车牌号码
            [self.btn_type setTitle:@"车牌号码" forState:UIControlStateNormal];
            self.lb_carNumber.textColor = DefaultColor;
            self.lb_forceNumber.textColor = UIColorFromRGB(0x666666);
            self.lb_carframeNumber.textColor = UIColorFromRGB(0x666666);
            self.img_carNumber.hidden = NO;
            self.img_forceNumber.hidden = YES;
            self.img_carframeNumber.hidden = YES;
            
        }else if ([x integerValue] == 1){
            //强制编号
            [self.btn_type setTitle:@"强制编号" forState:UIControlStateNormal];
            self.lb_carNumber.textColor = UIColorFromRGB(0x666666);
            self.lb_forceNumber.textColor = DefaultColor;
            self.lb_carframeNumber.textColor = UIColorFromRGB(0x666666);
            self.img_carNumber.hidden = YES;
            self.img_forceNumber.hidden = NO;
            self.img_carframeNumber.hidden = YES;
            
        }else if ([x integerValue] == 2){
            //车架号
            [self.btn_type setTitle:@"车架号" forState:UIControlStateNormal];
            self.lb_carNumber.textColor = UIColorFromRGB(0x666666);
            self.lb_forceNumber.textColor = UIColorFromRGB(0x666666);
            self.lb_carframeNumber.textColor = DefaultColor;
            self.img_carNumber.hidden = YES;
            self.img_forceNumber.hidden = YES;
            self.img_carframeNumber.hidden = NO;
            
        }
        
        if (self.viewModel.keywords.length > 0) {
            [self.tableView.mj_header beginRefreshing];
        }
        
    }];
    
    //textViewh与keywords双向绑定
    
    [RACObserve(self.viewModel, keywords) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.tf_search.text = x;
    }];
    
    [self.tf_search.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        self.viewModel.keywords = x;
    }];
    
    
    
}


#pragma mark - 加载新数据

- (void)reloadData{
    self.viewModel.index = @0;
    [self.viewModel.searchCommand execute:nil];
    
}

- (void)loadData{
    self.viewModel.index = @([self.viewModel.index intValue] + 1);
    [self.viewModel.searchCommand execute:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.arr_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ParkingManageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkingManageListCellID" forIndexPath:indexPath];
   
    ParkingManageListModel * model = self.viewModel.arr_data[indexPath.row];
    
    cell.model = model;
    
    return cell;
    
}

#pragma - mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}





#pragma mark - textFeildDelegate

-(BOOL) textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    if (textField.text.length > 0) {
        [self.tableView.mj_header beginRefreshing];
    }
    
    return YES;
    
}

#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"ParkingManagementVC dealloc");
}

@end
