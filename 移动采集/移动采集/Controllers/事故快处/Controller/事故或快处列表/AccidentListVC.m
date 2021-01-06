//
//  AccidentListVC.m
//  trafficPolice
//
//  Created by hcat on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AccidentListVC.h"

#import "AccidentAPI.h"
#import "FastAccidentAPI.h"

#import "AccidentCell.h"
#import "AccidentCompleteVC.h"

#import "LRBaseTableView.h"
#import "UserModel.h"

#import "AccidentManageVC.h"

#import "AlertView.h"


@interface AccidentListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) AccidentListViewModel * viewModel;

@property (weak, nonatomic) IBOutlet LRBaseTableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet UIView *v_search;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_viewSearch_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_viewSearch_top;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_changeView_top;

@property (weak, nonatomic) IBOutlet UIView *v_change;

@property (nonatomic,copy) NSString *str_search;

@property (weak, nonatomic) IBOutlet UIButton *btn_illegalAdd;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *arr_button;


@end

@implementation AccidentListVC

- (instancetype)initWithViewModel:(AccidentListViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return  self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShowScreenClick:) name:@"筛选视图点击事件" object:nil];
}

- (void)lr_configUI{
    
    @weakify(self);
    
    self.viewModel.stateType = 3;
    
    for (UIButton * t_button in self.arr_button) {
        if (t_button.tag == 3) {
            t_button.selected = YES;
        }else{
            t_button.selected = NO;
        }
    }
    
    [[RACObserve(self.viewModel, stateType) skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        
        @strongify(self);
       
        for (UIButton * t_button in self.arr_button) {
            if (t_button.tag == [x intValue]) {
                t_button.selected = YES;
            }else{
                t_button.selected = NO;
            }
        }
        
        [self.tableView beginRefresh];
        
    }];
    
    if (self.viewModel.accidentType == AccidentTypeAccident) {
        
        self.layout_changeView_top.constant = 40.f;
        self.v_change.hidden = NO;
    }else if (self.viewModel.accidentType == AccidentTypeFastAccident){
        self.layout_changeView_top.constant = 0.f;
        self.v_change.hidden = YES;
        
    }
    
    self.tableView.autoNetworkNotice = YES;
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AccidentCell" bundle:nil] forCellReuseIdentifier:@"AccidentCellID"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 148.5f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if (self.viewModel.type == 1) {
        
        @weakify(self);
        [self zx_setRightBtnWithImgName:@"btn_search" clickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
            @strongify(self);
            [self handleBtnSearchClicked:nil];
        }];
        
        
        if (self.viewModel.accidentType == AccidentTypeAccident) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accidentSuccess:) name:NOTIFICATION_ACCIDENT_SUCCESS object:nil];
        }else if (self.viewModel.accidentType == AccidentTypeFastAccident){
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accidentSuccess:) name:NOTIFICATION_FASTACCIDENT_SUCCESS object:nil];
        }
        
        if (self.viewModel.accidentType == AccidentTypeFastAccident) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accidentSuccess:) name:@"快处处理成功" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accidentSuccess:) name:@"快处认定成功" object:nil];
        }
        
        _v_search.hidden = YES;
        _layout_viewSearch_height.constant = 0;
        
        self.btn_illegalAdd.hidden = NO;
        
    }else if(self.viewModel.type == 2){
        
        self.zx_hideBaseNavBar = YES;
        if (IS_IPHONE_X_MORE){
            _layout_viewSearch_height.constant = _layout_viewSearch_height.constant + 24 ;
            
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
        if (self.viewModel.accidentType == AccidentTypeAccident) {
            if ([UserModel isPermissionForAccidentList]) {
                [self loadDataForStart];
            }else{
                [self loadDataForEmpty];
            }
            
        }else if (self.viewModel.accidentType == AccidentTypeFastAccident){
            
            if ([UserModel isPermissionForFastAccidentList]) {
                [self loadDataForStart];
            }else{
                [self loadDataForEmpty];
            }
            
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
    self.viewModel.index= 0;
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
    
    AccidentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentCellID"];
    
    if (self.viewModel.arr_content && self.viewModel.arr_content.count > 0) {
        
        AccidentListModel *t_model = self.viewModel.arr_content[indexPath.row];
        cell.accidentType = self.viewModel.accidentType;
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
    
    if (self.viewModel.arr_content && self.viewModel.arr_content.count > 0) {
        
        AccidentListModel *t_model = self.viewModel.arr_content[indexPath.row];
    
        AccidentCompleteVC *t_vc = [[AccidentCompleteVC alloc] init];
        t_vc.accidentType = self.viewModel.accidentType;
        t_vc.accidentId = t_model.accidentId;
        t_vc.state = t_model;
        [self.navigationController pushViewController:t_vc animated:YES];
        
    }
}

#pragma mark - buttonAction


- (IBAction)handleBtnNameClicked:(id)sender {
    self.viewModel.stateType = 0;
}

- (IBAction)handleBtnCodeClicked:(id)sender {
    self.viewModel.stateType = 1;
}


- (IBAction)handleBtnCarNoClicked:(id)sender {
    self.viewModel.stateType = 2;
}

- (IBAction)handleBtnCarInfoClicked:(id)sender {
    self.viewModel.stateType = 3;
}

- (IBAction)handleBtnSearchClicked:(id)sender {
    

    if (self.viewModel.accidentType == AccidentTypeAccident) {
        if ([UserModel isPermissionForAccidentList]) {
            [AlertView showFiltartWithCar:self.viewModel.str_car withName:self.viewModel.str_name withAddress:self.viewModel.str_address withStartTime:self.viewModel.str_startTime withEndTime:self.viewModel.str_endTime inViewController:self.view];
        }

    }else if (self.viewModel.accidentType == AccidentTypeFastAccident){

        if ([UserModel isPermissionForFastAccidentList]) {
            AccidentListViewModel * viewModel = [[AccidentListViewModel alloc] init];
            viewModel.accidentType = self.viewModel.accidentType;
            viewModel.type = 2;
            AccidentListVC *vc = [[AccidentListVC alloc] initWithViewModel:viewModel];
            [self.navigationController pushViewController:vc animated:YES];
        }

    }
    
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
     self.viewModel.str_search = self.tf_search.text;
    if (self.viewModel.str_search.length == 0) {
        [LRShowHUD showError:@"请输入搜索内容" duration:1.5f];
    }
    self.tableView.enableRefresh = YES;
    self.tableView.enableLoadMore = YES;
    [self.tableView beginRefresh];
    
}



#pragma mark - Notication

- (void)accidentSuccess:(NSNotification *)notification{
     [self.tableView beginRefresh];
}

- (IBAction)handleIllegalAdd:(id)sender {
    
    AccidentManageVC *t_vc = [[AccidentManageVC alloc] init];
    t_vc.accidentType = self.viewModel.accidentType;
    NSRange range = [self.title rangeOfString:@"列表"];
    NSLog(@"rang:%@",NSStringFromRange(range));
    t_vc.title =  [self.title substringToIndex:range.location];
    [self.navigationController pushViewController:t_vc animated:YES];

}

#pragma mark - NSNotificationCenter

- (void)handleShowScreenClick:(NSNotification *)notification{
    
    RACTupleUnpack(NSString * str_car,NSString * str_name, NSString * str_address, NSString * str_startTime, NSString * str_endTime) = notification.object;
    
    self.viewModel.str_car = str_car;
    self.viewModel.str_name = str_name;
    self.viewModel.str_address = str_address;
    self.viewModel.str_startTime = str_startTime;
    self.viewModel.str_endTime = str_endTime;
    
    [self.tableView beginRefresh];
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"筛选视图点击事件" object:nil];
    
    if (self.viewModel.accidentType == AccidentTypeAccident) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ACCIDENT_SUCCESS object:nil];
    }else if (self.viewModel.accidentType == AccidentTypeFastAccident){
         [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_FASTACCIDENT_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"快处处理成功" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"快处认定成功" object:nil];
        
    }

    LxPrintf(@"AccidentListVC dealloc");
    
}




@end
