//
//  AttendanceManageVC.m
//  移动采集
//
//  Created by hcat on 2019/4/3.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "AttendanceManageVC.h"
#import "AttendanceManageViewModel.h"
#import <MJRefresh.h>
#import "UITableView+Lr_Placeholder.h"
#import "NetWorkHelper.h"
#import "AttendancePoliceCell.h"
#import "BottomPickerView.h"
#import "BottomView.h"
#import "PGDatePickManager.h"
#import "UserModel.h"
#import "AttendanceSignInVC.h"

@interface AttendanceManageVC ()<PGDatePickerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *lb_department;
@property (weak, nonatomic) IBOutlet UIButton *btn_department;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UIButton *btn_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_group;
@property (weak, nonatomic) IBOutlet UIButton *btn_group;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) AttendanceManageViewModel * viewModel;


@end

@implementation AttendanceManageVC

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.viewModel = [[AttendanceManageViewModel alloc] init];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
    @weakify(self);
    
    //警员列表数据加载成功之后的处理
    [self.viewModel.command_polices.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if ([x isEqualToString:@"请求最后一条成功"]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else if([x isEqualToString:@"加载失败"]){
            self.viewModel.index_polices = @([self.viewModel.index_polices intValue] - 1);
            
            Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
            NetworkStatus status = [reach currentReachabilityStatus];
            if (status == NotReachable) {
                if (self.viewModel.arr_polices.count > 0) {
                    [self.viewModel.arr_polices removeAllObjects];
                }
                self.tableView.isNetAvailable = YES;
                [self.tableView reloadData];
            }
            
        }
        
        [self.tableView reloadData];
        
    }];
    
    [RACObserve([UserModel getUserModel], dutyCode) subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self);
        
        if (x) {
            if ([x isEqualToString:@"BIG_LEADER"]) {
                [self.viewModel.command_department execute:nil];
            }else{
                self.viewModel.departmentId = [UserModel getUserModel].departmentId;
                self.viewModel.departmentName = [UserModel getUserModel].departmentName;
            }
        }
    
    }];
    
    [RACObserve(self.viewModel, departmentId) subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (x) {
            [self.viewModel.command_group execute:nil];
        }
        
    }];
    
    [RACObserve(self.viewModel, departmentName) subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (x) {
            self.lb_department.text = self.viewModel.departmentName;
            self.lb_department.textColor = UIColorFromRGB(0x333333);
        }
    }];
    
    [RACObserve(self.viewModel, groupName) subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (x) {
            self.lb_group.text = self.viewModel.groupName;
            self.lb_group.textColor = UIColorFromRGB(0x333333);
        }
    }];
    
    [RACObserve(self.viewModel, workDateStr) subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (x) {
            self.lb_time.text = self.viewModel.workDateStr;
            self.lb_time.textColor = UIColorFromRGB(0x333333);
        }
    }];
    
    
    [[RACSignal combineLatest:@[RACObserve(self.viewModel, groupId),RACObserve(self.viewModel, workDateStr)] reduce:^id _Nonnull(NSNumber *groupId,NSString *workDateStr){
        return @(groupId && workDateStr);
        
    }] subscribeNext:^(NSNumber  * _Nullable isLoadPoliceList) {
        @strongify(self);
        if ([isLoadPoliceList boolValue]) {
            [self.tableView.mj_header beginRefreshing];
        }
    }];
    
    [RACObserve(self.viewModel, count_department) subscribeNext:^(NSNumber *  _Nullable x) {
        @strongify(self);
        if (x) {
            if ([x intValue] > 0) {
                self.btn_department.enabled = YES;
            }else{
                self.btn_department.enabled = NO;
            }
        }else{
            self.btn_department.enabled = NO;
        }
    }];
    
    
    [RACObserve(self.viewModel, count_group) subscribeNext:^(NSNumber *  _Nullable x) {
        @strongify(self);
        if (x) {
            if ([x intValue] > 0) {
                self.btn_group.enabled = YES;
                self.lb_group.text = @"请选择";
                self.lb_group.textColor = UIColorFromRGB(0x999999);
            }else{
                self.btn_group.enabled = NO;
                self.lb_group.text = @"当前中队无分组";
                self.lb_group.textColor = UIColorFromRGB(0x333333);
            }
        }else{
            self.btn_group.enabled = NO;
        }
    }];
    
    
    
}

#pragma mark - viewWillAppear

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    @weakify(self);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        @strongify(self);
        self.tableView.isNetAvailable = NO;
        self.viewModel.index_polices = @0;
        [self.tableView.mj_header beginRefreshing];
    };
    
}


#pragma mark - configUI

- (void)configUI{
    
    self.title = @"勤务管理";
    self.tableView.isNeedPlaceholderView = YES;
    self.tableView.str_placeholder = @"暂无人员勤务";
    //self.tableView.firstReload = YES;
    //隐藏多余行的分割线
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    
    [_tableView registerNib:[UINib nibWithNibName:@"AttendancePoliceCell" bundle:nil] forCellReuseIdentifier:@"AttendancePoliceCellID"];
    
    //点击重新加载之后的处理
    @weakify(self);
    [self.tableView setReloadBlock:^{
        @strongify(self);
        self.tableView.isNetAvailable = NO;
        self.viewModel.index_polices = @0;
        [self.tableView.mj_header beginRefreshing];
    }];
    
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

    //中队按钮事件
    [[self.btn_department rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.viewModel.count_department > 0) {
            BottomPickerView *t_view = [BottomPickerView initCustomView];
            [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 207)];
            t_view.pickerTitle = @"中队";
            t_view.items = self.viewModel.arr_department;
            t_view.selectedBtnBlock = ^(NSArray *items, NSInteger index) {
                @strongify(self);
                DepartmentModel * departmentModel = items[index];
                self.viewModel.departmentId = departmentModel.departmentId;
                self.viewModel.departmentName = departmentModel.name;
                [BottomView dismissWindow];
            };
            
            [BottomView showWindowWithBottomView:t_view];
        }
        
    }];
    
    //分组按钮事件
    [[self.btn_group rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.viewModel.count_group > 0) {
            BottomPickerView *t_view = [BottomPickerView initCustomView];
            [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 207)];
            t_view.pickerTitle = @"分组";
            t_view.items = self.viewModel.arr_group;
            t_view.selectedBtnBlock = ^(NSArray *items, NSInteger index) {
                @strongify(self);
                PoliceGroupModel * policeGroupModel = items[index];
                self.viewModel.groupId = policeGroupModel.groupId;
                self.viewModel.groupName = policeGroupModel.name;
                [BottomView dismissWindow];
            };
            
            [BottomView showWindowWithBottomView:t_view];
        }
        
    }];
    
    //时间按钮事件
    [[self.btn_time rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
        PGDatePicker *datePicker = datePickManager.datePicker;
        datePicker.delegate = self;
        datePickManager.titleLabel.text = @"日期";
        datePickManager.isShadeBackgroud = YES;
        
        datePicker.minimumDate = [NSDate setYear:2017 month:1 day:1 hour:00 minute:00];
        datePicker.maximumDate =  [NSDate dateWithTimeInterval:-24*60*60 sinceDate:[NSDate date]];
        datePicker.datePickerType = PGPickerViewType3;
        datePicker.datePickerMode = PGDatePickerModeDate;
        
        [self presentViewController:datePickManager
                           animated:NO
                         completion:^{
                         }];
   
    }];
    
    
}

#pragma mark - 加载新数据

- (void)reloadData{
    
    if (self.viewModel.workDateStr && self.viewModel.groupId) {
        self.viewModel.index_polices = @0;
        [self.viewModel.command_polices execute:self.viewModel.index_polices];
    }else{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
    
}

- (void)loadData{
    self.viewModel.index_polices = @([self.viewModel.index_polices intValue] + 1);
    [self.viewModel.command_polices execute:self.viewModel.index_polices];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.arr_polices.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AttendancePoliceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttendancePoliceCellID"];
    cell.viewModel = self.viewModel.arr_polices[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AttendanceSignInViewModel * viewModel = [[AttendanceSignInViewModel alloc] init];
    viewModel.policemodel = self.viewModel.arr_polices[indexPath.row];
    
    AttendanceSignInVC * vc = [[AttendanceSignInVC alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark - PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    
    NSLog(@"dateComponents = %@", dateComponents);
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:dateComponents];
    NSDateFormatter *dataFormant = [[NSDateFormatter alloc] init];
    [dataFormant setDateFormat: @"yyyy-MM-dd"];
    NSString *dateStr = [dataFormant stringFromDate:date];
    
    self.viewModel.workDateStr = dateStr;
    
}


#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"AttendanceManageVC dealloc");
}

@end
