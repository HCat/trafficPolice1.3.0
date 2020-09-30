//
//  ThroughManageListVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/27.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ThroughManageListVC.h"
#import "LRBaseTableView.h"
#import "IllegalCollectListCell.h"
#import "UserModel.h"
#import "ThroughManageVC.h"
#import "IllegalDetailVC.h"


@interface ThroughManageListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ThroughManageListViewModel * viewModel;

@property (weak, nonatomic) IBOutlet LRBaseTableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *tf_search;

@property (weak, nonatomic) IBOutlet UIView *v_search;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_viewSearch_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_viewSearch_top;

@property (weak, nonatomic) IBOutlet UIButton *btn_illegalAdd;


@end

@implementation ThroughManageListVC

- (instancetype)initWithViewModel:(ThroughManageListViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return  self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)lr_configUI{
    
    @weakify(self);
    
    self.tableView.autoNetworkNotice = NO;
    self.tableView.isHavePlaceholder = YES;
    
    
    self.tableView.tableViewPlaceholderBlock = ^{
        @strongify(self);
        
        if (self.viewModel.arr_content.count > 0) {
            [self.viewModel.arr_content removeAllObjects];
            [self.tableView reloadData];
        }
        
        self.tableView.lr_handler.state = LRDataLoadStateLoading;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              @strongify(self);
              [self reloadData];
        });
    };
    
    self.tableView.tableViewHeaderRefresh = ^{
        @strongify(self);
        [self reloadData];
        
    };
    
    self.tableView.tableViewFooterLoadMore = ^{
        @strongify(self);
        [self loadData];
        
    };
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IllegalCollectListCell" bundle:nil] forCellReuseIdentifier:@"IllegalCollectListCellID"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 135.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if (self.viewModel.type == 1) {
        
        @weakify(self);
        [self zx_setRightBtnWithImgName:@"btn_search" clickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
            @strongify(self);
            [self handleBtnSearchClicked:nil];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(illegalSuccess:) name:NOTIFICATION_THROUGHMANAGE_SUCCESS object:nil];
        
        _v_search.hidden = YES;
        _layout_viewSearch_height.constant = 0;
        
        self.btn_illegalAdd.hidden = NO;
        
    }else if(self.viewModel.type == 2){
        
        self.zx_hideBaseNavBar = YES;
        if (IS_IPHONE_X_MORE){
            _layout_viewSearch_height.constant = Height_NavBar;
            
        }
        
        _layout_viewSearch_top.constant = - Height_StatusBar;
    
        self.btn_illegalAdd.hidden = YES;
        
    }
    
    
}

- (void)lr_bindViewModel{
    
    
    @weakify(self);
    

    [self.viewModel.command_list.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        [self.tableView endingRefresh];
        [self.tableView endingLoadMore];
        
        if ([x isEqualToString:@"请求最后一条成功"]) {
            [self.tableView endingNoMoreData];
            if (self.viewModel.arr_content.count == 0) {
                self.tableView.lr_handler.state = LRDataLoadStateEmpty;
            }
        }else if([x isEqualToString:@"加载成功"]){
            if (self.viewModel.arr_content.count == 0) {
                self.tableView.lr_handler.state = LRDataLoadStateEmpty;
            }else{
                self.tableView.lr_handler.state = LRDataLoadStateIdle;
            }
            
        }else if([x isEqualToString:@"加载失败"]){
        
            if (self.viewModel.arr_content.count == 0) {
                self.tableView.lr_handler.state = LRDataLoadStateFailed;
            }
        }
        
        [self.tableView reloadData];
        
    }];
    
    if (self.viewModel.type == 1) {
        
#pragma mark - 权限判断
        if ([UserModel isPermissionForThroughCollectList]) {
            [self loadDataForStart];
        }else{
            [self loadDataForEmpty];
        }
        
    }else{
        
        if (self.viewModel.arr_content.count > 0) {
            [self.viewModel.arr_content removeAllObjects];
            [self.tableView reloadData];
        }
        self.tableView.enableRefresh = NO;
        self.tableView.enableLoadMore = NO;
        self.tableView.lr_handler.state = LRDataLoadStateEmpty;
        [self.tableView reloadData];
        
    }
    
}

#pragma mark - 开始加载数据

- (void)loadDataForStart{
    @weakify(self);
    if (self.viewModel.arr_content.count > 0) {
        [self.viewModel.arr_content removeAllObjects];
        [self.tableView reloadData];
    }
    self.tableView.enableRefresh = YES;
    self.tableView.enableLoadMore = YES;
    [self.tableView resetNoMoreData];
    self.tableView.lr_handler.state = LRDataLoadStateLoading;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self reloadData];
    });
    
}


#pragma mark - 配置不能加载数据

- (void)loadDataForEmpty{
    
    //[ShareFun showTipLable:@"请联系管理员授权"];
    
    if (self.viewModel.arr_content.count > 0) {
        [self.viewModel.arr_content removeAllObjects];
        [self.tableView reloadData];
    }
    self.tableView.enableRefresh = NO;
    self.tableView.enableLoadMore = NO;
    self.tableView.lr_handler.state = LRDataLoadStateEmpty;
    [self.tableView reloadData];
    
}


#pragma mark - 加载新数据

- (void)reloadData{
    
    self.viewModel.param.start = 0;
    [self.tableView resetNoMoreData];
    [self.viewModel.command_list execute:nil];
    
}

- (void)loadData{
    [self.viewModel.command_list execute:nil];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.arr_content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IllegalCollectListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalCollectListCellID"];
    
    if (self.viewModel.arr_content && self.viewModel.arr_content.count > 0) {
        IllegalParkListModel *t_model = self.viewModel.arr_content[indexPath.row];
        cell.model = t_model;
    }
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.viewModel.arr_content && self.viewModel.arr_content.count > 0) {
        IllegalParkListModel *t_model = self.viewModel.arr_content[indexPath.row];
        IllegalDetailVC *t_vc = [[IllegalDetailVC alloc] init];
        t_vc.illegalType = IllegalTypeThroughManage;
        t_vc.illegalId = t_model.illegalParkId;
        [self.navigationController pushViewController:t_vc animated:YES];
       
    }
    
}


#pragma mark - buttonAction

- (IBAction)handleBtnSearchClicked:(id)sender {
    
    if (![UserModel isPermissionForThroughCollectList]) {
        [LRShowHUD showError:@"请联系管理员授权" duration:1.5f];
        return;
    }
    
    ThroughManageListViewModel * viewModel = [[ThroughManageListViewModel alloc] init];
    viewModel.type = 2;
    ThroughManageListVC * vc = [[ThroughManageListVC alloc] initWithViewModel:viewModel];
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

- (IBAction)handleBtnSearch:(id)sender {
    
    [self.tf_search resignFirstResponder];
     self.viewModel.param.carNo = self.tf_search.text;
    if (self.viewModel.param.carNo.length == 0) {
        [LRShowHUD showError:@"请输入搜索内容" duration:1.5f];
    }
    self.tableView.enableRefresh = YES;
    self.tableView.enableLoadMore = YES;
    [self.tableView beginRefresh];
    
    
}

#pragma mark - Notification

- (void)illegalSuccess:(NSNotification *)notification{
    [self.tableView beginRefresh];

}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_THROUGHMANAGE_SUCCESS object:nil];

    LxPrintf(@"ThroughManageListVC dealloc");
    
}

- (IBAction)handleIllegalAdd:(id)sender {
    
    ThroughManageVC * vc = [[ThroughManageVC alloc] init];
    NSRange range = [self.title rangeOfString:@"列表"];
    NSLog(@"rang:%@",NSStringFromRange(range));
    vc.title =  [self.title substringToIndex:range.location];
    [self.navigationController pushViewController:vc animated:YES];
    
}




@end
