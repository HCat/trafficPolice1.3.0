//
//  ThroughManageShowList.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/30.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ThroughManageShowList.h"
#import "LRBaseTableView.h"
#import "IllegalCollectListCell.h"
#import "IllegalDetailVC.h"
#import "PFNavigationDropdownMenu.h"

@interface ThroughManageShowList ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) PFNavigationDropdownMenu *menuView;
@property (nonatomic, strong) ThroughManageShowViewModel * viewModel;

@property (weak, nonatomic) IBOutlet LRBaseTableView *tableView;

@end

@implementation ThroughManageShowList


- (instancetype)initWithViewModel:(ThroughManageShowViewModel *)viewModel{
    
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
    
    self.title = @"历史采集记录";
    
    self.tableView.autoNetworkNotice = NO;
    self.tableView.isHavePlaceholder = YES;
    self.tableView.enableRefresh = YES;
    self.tableView.enableLoadMore = YES;
    
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
    
    
    
    NSMutableArray *items_t = [NSMutableArray array];
    [items_t addObject:@"近一个月"];
    [items_t addObject:@"近三个月"];
    [items_t addObject:@"近六个月"];
    [items_t addObject:@"近一年"];
    
    
    _menuView = [[PFNavigationDropdownMenu alloc] initWithFrame:CGRectMake(0, Height_NavBar, SCREEN_WIDTH, 44)
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
        @strongify(self);
        self.viewModel.param.timeType = @(indexPath + 1);
        [self.tableView beginRefresh];
        
    };
    
    [self.view addSubview:_menuView];
    
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.top.equalTo(self.view).offset(Height_NavBar);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
            
    }];
    
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
    
    self.viewModel.param.timeType = @(1);
    
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


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    LxPrintf(@"ThroughManageShowList dealloc");
    
}



@end
