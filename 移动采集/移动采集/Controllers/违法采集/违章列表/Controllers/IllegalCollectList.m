//
//  IllegalCollectList.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/22.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "IllegalCollectList.h"
#import "LRBaseTableView.h"
#import "IllegalCell.h"
#import "IllegalDetailVC.h"
#import "IllegalCollectListCell.h"

#import "UserModel.h"
#import "IllegalParkForJJVC.h"
#import "NoPressTowardVC.h"
#import "InhibitLineVC.h"
#import "LockParkVC.h"
#import "CarInfoInputVC.h"
#import "MotorbikeAddVC.h"
#import "ThroughAddVC.h"

@interface IllegalCollectList ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) IllegalCollectListViewModel * viewModel;

@property (weak, nonatomic) IBOutlet LRBaseTableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *tf_search;

@property (weak, nonatomic) IBOutlet UIView *v_search;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_viewSearch_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_viewSearch_top;

@property (weak, nonatomic) IBOutlet UIButton *btn_illegalAdd;


@end

@implementation IllegalCollectList

- (instancetype)initWithViewModel:(IllegalCollectListViewModel *)viewModel{
    
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
        
        if (self.viewModel.illegalType == IllegalTypePark) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(illegalSuccess:) name:NOTIFICATION_ILLEGALPARK_SUCCESS object:nil];
        }else if (self.viewModel.illegalType == IllegalTypeThrough){
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(illegalSuccess:) name:NOTIFICATION_ILLEGALTHROUGH_SUCCESS object:nil];
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
        if (self.viewModel.illegalType == IllegalTypePark) {
            
            if (self.viewModel.subType == ParkTypePark) {
                
                if ([UserModel isPermissionForIllegalList]) {
                    [self loadDataForStart];
                }else{
                    [self loadDataForEmpty];
                }
            }else if (self.viewModel.subType == ParkTypeReversePark) {
                
                if ([UserModel isPermissionForIllegalReverseList]) {
                    [self loadDataForStart];
                }else{
                    [self loadDataForEmpty];
                }
            }else if (self.viewModel.subType == ParkTypeLockPark) {
                
                if ([UserModel isPermissionForIllegalLockList]) {
                    [self loadDataForStart];
                }else{
                    [self loadDataForEmpty];
                }
            }else if (self.viewModel.subType == ParkTypeViolationLine) {
                
                if ([UserModel isPermissionForInhibitLineList]) {
                    [self loadDataForStart];
                }else{
                    [self loadDataForEmpty];
                }
            }else if (self.viewModel.subType == ParkTypeCarInfoAdd) {
                
                if ([UserModel isPermissionForCarInfoList]) {
                    [self loadDataForStart];
                }else{
                    [self loadDataForEmpty];
                }
            }else if (self.viewModel.subType == ParkTypeMotorbikeAdd) {
                
                if ([UserModel isPermissionForMotorBikeList]) {
                    [self loadDataForStart];
                }else{
                    [self loadDataForEmpty];
                }
            }
            
        }else if (self.viewModel.illegalType == IllegalTypeThrough){
            
            if (self.viewModel.subType == ParkTypeThrough) {
                
                if ([UserModel isPermissionForThroughList]) {
                    [self loadDataForStart];
                }else{
                    [self loadDataForEmpty];
                }
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
        t_vc.illegalType = self.viewModel.illegalType;
        t_vc.subType = self.viewModel.subType;
        t_vc.illegalId = t_model.illegalParkId;
        [self.navigationController pushViewController:t_vc animated:YES];
    }
    
}


#pragma mark - buttonAction

- (IBAction)handleBtnSearchClicked:(id)sender {
    IllegalCollectListViewModel * viewModel = [[IllegalCollectListViewModel alloc] init];
    viewModel.illegalType = self.viewModel.illegalType;
    viewModel.subType = self.viewModel.subType;
    viewModel.type = 2;
    IllegalCollectList * vc = [[IllegalCollectList alloc] initWithViewModel:viewModel];
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
     self.viewModel.str_search = self.tf_search.text;
    if (self.viewModel.str_search.length == 0) {
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
    
    if (self.viewModel.illegalType == IllegalTypePark) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ILLEGALPARK_SUCCESS object:nil];
    }else if (self.viewModel.illegalType == IllegalTypeThrough){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ILLEGALTHROUGH_SUCCESS object:nil];
    }

    LxPrintf(@"IllegalCollectList dealloc");
    
}

- (IBAction)handleIllegalAdd:(id)sender {
    
    if (self.viewModel.illegalType == IllegalTypePark) {
        
        if (self.viewModel.subType == ParkTypePark) {
            IllegalParkForJJVC * vc = [[IllegalParkForJJVC alloc] init];
            NSRange range = [self.title rangeOfString:@"列表"];
            NSLog(@"rang:%@",NSStringFromRange(range));
            vc.title =  [self.title substringToIndex:range.location];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.viewModel.subType == ParkTypeReversePark){
            NoPressTowardVC * vc = [[NoPressTowardVC alloc] init];
            NSRange range = [self.title rangeOfString:@"列表"];
            NSLog(@"rang:%@",NSStringFromRange(range));
            vc.title =  [self.title substringToIndex:range.location];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.viewModel.subType == ParkTypeViolationLine){
            InhibitLineVC * vc = [[InhibitLineVC alloc] init];
            NSRange range = [self.title rangeOfString:@"列表"];
            NSLog(@"rang:%@",NSStringFromRange(range));
            vc.title =  [self.title substringToIndex:range.location];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.viewModel.subType == ParkTypeLockPark){
            LockParkVC * vc = [[LockParkVC alloc] init];
            NSRange range = [self.title rangeOfString:@"列表"];
            NSLog(@"rang:%@",NSStringFromRange(range));
            vc.title =  [self.title substringToIndex:range.location];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.viewModel.subType == ParkTypeLockPark){
            LockParkVC * vc = [[LockParkVC alloc] init];
            NSRange range = [self.title rangeOfString:@"列表"];
            NSLog(@"rang:%@",NSStringFromRange(range));
            vc.title =  [self.title substringToIndex:range.location];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.viewModel.subType == ParkTypeCarInfoAdd){
            CarInfoInputVC * vc = [[CarInfoInputVC alloc] init];
            NSRange range = [self.title rangeOfString:@"列表"];
            NSLog(@"rang:%@",NSStringFromRange(range));
            vc.title =  [self.title substringToIndex:range.location];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.viewModel.subType == ParkTypeMotorbikeAdd){
            MotorbikeAddVC * vc = [[MotorbikeAddVC alloc] init];
            NSRange range = [self.title rangeOfString:@"列表"];
            NSLog(@"rang:%@",NSStringFromRange(range));
            vc.title =  [self.title substringToIndex:range.location];
            [self.navigationController pushViewController:vc animated:YES];
        }

    }else if (self.viewModel.illegalType == IllegalTypeThrough){
        ThroughAddVC * vc = [[ThroughAddVC alloc] init];
        NSRange range = [self.title rangeOfString:@"列表"];
        NSLog(@"rang:%@",NSStringFromRange(range));
        vc.title =  [self.title substringToIndex:range.location];
        [self.navigationController pushViewController:vc animated:YES];
    
    }

}





@end
