//
//  IllegalAddListVC.m
//  移动采集
//
//  Created by hcat-89 on 2020/2/19.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "IllegalAddListVC.h"
#import "IllegalAddListViewModel.h"
#import "IllegalAddListCell.h"

#import "IllegalSearchView.h"
#import "AlertView.h"
#import "IllegalAddDetailVC.h"
#import "LRBaseTableView.h"
#import "UserModel.h"
#import "IllegalAddForSSVC.h"

@interface IllegalAddListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet LRBaseTableView *tableView;
@property(nonatomic,strong) IllegalAddListViewModel * viewModel;

@property (weak, nonatomic) IBOutlet UIView *view_status;
@property (weak, nonatomic) IBOutlet UIView *view_status_inside;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_viewSearchStatus_height;

@property(nonatomic, strong) NSMutableArray * arr_buttons;



@end

@implementation IllegalAddListVC

- (instancetype)init{
    
    if (self = [super init]) {
        self.viewModel = [[IllegalAddListViewModel alloc] init];
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel];
    
}
#pragma mark - set&&get

- (NSMutableArray *)arr_buttons{
    
    if (_arr_buttons == nil) {
        _arr_buttons = @[].mutableCopy;
    }
    return _arr_buttons;
}


#pragma mark - configUI

- (void)configUI{
    
    @weakify(self);
    
    self.view_status.hidden = YES;
    self.layout_viewSearchStatus_height.constant = 0;
    [self.view layoutIfNeeded];
    
    [self zx_setRightBtnWithImgName:@"btn_illegalSearch" clickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
        @strongify(self);
        [self handleBtnSearchClicked:nil];
    }];
    
    
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
    
        
    [self.tableView registerNib:[UINib nibWithNibName:@"IllegalAddListCell" bundle:nil] forCellReuseIdentifier:@"IllegalAddListCellID"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 110.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(illegalSuccess:) name:NOTIFICATION_ILLEGALADDSS_SUCCESS object:nil];
   
    
}

#pragma mark - bindViewModel
- (void)bindViewModel{
    
    @weakify(self);
    
    [self.viewModel.command_loadList.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
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
    
    if ([UserModel isPermissionForIllegalAddList]) {
        [self loadDataForStart];
    }else{
        [self loadDataForEmpty];
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
    self.viewModel.start = @0;
    [self.tableView resetNoMoreData];
    [self.viewModel.command_loadList execute:nil];
    
}

- (void)loadData{
    [self.viewModel.command_loadList execute:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.arr_content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IllegalParkListModel *itemModel = self.viewModel.arr_content[indexPath.row];
    
    IllegalAddListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalAddListCellID" forIndexPath:indexPath];
    cell.model = itemModel;
    cell.permission =self.viewModel.permission;
    return cell;
    
}

#pragma - mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IllegalParkListModel *t_model = self.viewModel.arr_content[indexPath.row];
    IllegalAddDetailViewModel * viewModel = [[IllegalAddDetailViewModel alloc] init];
    viewModel.illegalId = t_model.illegalParkId;
    IllegalAddDetailVC * vc = [[IllegalAddDetailVC alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark - buttonAction


#pragma mark - 搜索按钮点击
- (IBAction)handleBtnSearchClicked:(id)sender {
    
    if ([UserModel isPermissionForIllegalAddList] == NO) {
        [LRShowHUD showError:@"请联系管理员授权" duration:1.f];
    }
    
    @weakify(self);
    IllegalSearchView *view = [IllegalSearchView initCustomView];
    view.selectedBlock = ^(NSString * _Nonnull carNo, NSNumber * _Nonnull status) {
        @strongify(self);
        self.viewModel.search = carNo;
        self.viewModel.state = status;
        
        if (self.arr_buttons.count > 0) {
            for (UIButton * button in self.arr_buttons) {
                [button removeFromSuperview];
            }
            [self.arr_buttons removeAllObjects];
        }
        
        if (carNo && carNo.length > 0) {
            UIButton * button = [[UIButton alloc] init];
            [button setTitle:carNo forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xE4F0FC)];
           
            button.layer.cornerRadius = 5.0f;
            button.layer.borderWidth = 1.0f;
            button.layer.borderColor = UIColorFromRGB(0x3396FC).CGColor;
            button.layer.masksToBounds = YES;
            [self.view_status_inside addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@85.);
                make.height.equalTo(@31.);
                make.left.equalTo(@12.5);
                make.top.equalTo(@40);
            }];
            [self.arr_buttons addObject:button];
        }
        
        if (status) {
            UIButton * button = [[UIButton alloc] init];
            if ([status intValue] == 8) {
                [button setTitle:@"上报异常" forState:UIControlStateNormal];
            }else{
                [button setTitle:@"确认异常" forState:UIControlStateNormal];
            }
            
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xE4F0FC)];
           
            button.layer.cornerRadius = 5.0f;
            button.layer.borderWidth = 1.0f;
            button.layer.borderColor = UIColorFromRGB(0x3396FC).CGColor;
            button.layer.masksToBounds = YES;
            [self.view_status_inside addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if (carNo == nil || carNo.length == 0) {
                    make.width.equalTo(@85.);
                    make.height.equalTo(@31.);
                    make.left.equalTo(@12.5);
                    make.top.equalTo(@40);
                }else{
                    make.width.equalTo(@85.);
                    make.height.equalTo(@31.);
                    make.left.equalTo(@107);
                    make.top.equalTo(@40);
                }
                
            }];
            [self.arr_buttons addObject:button];
        }
        
        self.view_status.hidden = NO;
        self.layout_viewSearchStatus_height.constant = 106.f;
        [self.view layoutIfNeeded];
        [self.tableView beginRefresh];
    };
    [AlertView showWindowWithIllegalSearchViewWith:view inView:self.view];
    
}

#pragma mark - 搜索条件框隐藏按钮点击
- (IBAction)handleBtnSearchStatusClicked:(id)sender {
    self.viewModel.search = nil;
    self.viewModel.state = nil;
    self.view_status.hidden = YES;
    self.layout_viewSearchStatus_height.constant = 0;
    [self.view layoutIfNeeded];
    
    [self.tableView beginRefresh];
}


- (IBAction)handleIllegalAdd:(id)sender {
    
    IllegalAddForSSVC * vc = [[IllegalAddForSSVC alloc] init];
    NSRange range = [self.title rangeOfString:@"列表"];
    NSLog(@"rang:%@",NSStringFromRange(range));
    vc.title =  [self.title substringToIndex:range.location];
    [self.navigationController pushViewController:vc animated:YES];

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
    
    LxPrintf(@"IllegalList dealloc");
    
}

@end
