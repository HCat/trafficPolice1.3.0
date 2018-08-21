//
//  ScheduleVC.m
//  移动采集
//
//  Created by hcat on 2018/6/8.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "ScheduleVC.h"
#import <PureLayout.h>
#import "LTSCalendarManager.h"
#import "NSDate+Formatter.h"
#import "DutyAPI.h"
#import "ActionAPI.h"

#import <MJRefresh.h>
#import "UITableView+Lr_Placeholder.h"
#import "NetWorkHelper.h"

#import "PFNavigationDropdownMenu.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ActionDetailCell.h"
#import "UserTaskDetailVC.h"
#import "SRAlertView.h"

@interface ScheduleVC ()<LTSCalendarEventSource>

@property (weak, nonatomic) IBOutlet UIView *v_nav;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIButton *btn_watch;
@property (weak, nonatomic) IBOutlet UIButton *btn_task;

/******************** 值班视图相关 ********************/
@property (weak, nonatomic) IBOutlet UIView *v_watch;   //值班视图
@property (strong, nonatomic)LTSCalendarManager *manager;
@property (copy, nonatomic) NSString *date; //显示的年月
@property (strong, nonatomic) NSMutableArray * arr_data;

/******************** 任务视图相关 ********************/
@property (weak, nonatomic) IBOutlet UIView *v_task;    //任务视图
@property (weak, nonatomic) IBOutlet UITableView *tb_task;
@property (nonatomic, assign) NSInteger taskStatus; // -1 全部，1进行中，2已完成
@property (strong,nonatomic) PFNavigationDropdownMenu *menuView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *arr_tasks;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_topHeight;

@property (assign, nonatomic) NSInteger pageType; //页面类型：0代表值班 1代表行动

@property (weak, nonatomic) IBOutlet UIView *v_tip_duty;
@property (weak, nonatomic) IBOutlet UIView *v_tip_action;



@end

@implementation ScheduleVC

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
      
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arr_data = [NSMutableArray array];
    self.arr_tasks = [NSMutableArray array];
    self.index = 0;
    self.taskStatus = -1;
    self.pageType = 0;
 
    self.v_tip_duty.hidden = YES;
    self.v_tip_action.hidden = YES;
    
    if (IS_IPHONE_X) {
          _layout_topHeight.constant = _layout_topHeight.constant + 24;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDuty:) name:NOTIFICATION_RECEIVENOTIFICATION_DUTY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAction:) name:NOTIFICATION_RECEIVENOTIFICATION_ACTION object:nil];
    
    [self configWatchView];
    [self configTaskView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([ShareValue sharedDefault].dutyTip) {
        self.v_tip_duty.hidden = NO;
    }
    
    if ([ShareValue sharedDefault].actionTip) {
        self.v_tip_action.hidden = NO;
    }
    
    
    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        
        SW(strongSelf, weakSelf);
        
        if (self.pageType == 0) {
            self.manager.calenderScrollView.tableView.isNetAvailable = NO;
            [strongSelf requestDutyDetail:strongSelf.manager.calenderScrollView.calendarView.selectedDate];
        }else{
            
            strongSelf.tb_task.isNetAvailable = NO;
            [strongSelf.tb_task.mj_header beginRefreshing];
            
        }
        
    };
    
}

#pragma mark - 配置值班视图

- (void)configWatchView{
    
    self.manager = [LTSCalendarManager new];
    self.manager.eventSource = self;
    self.manager.weekDayView = [[LTSCalendarWeekDayView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [self.v_watch addSubview:self.manager.weekDayView];
    
    self.manager.calenderScrollView = [[LTSCalendarScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.manager.weekDayView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-50-self.v_nav.frame.size.height -CGRectGetMaxY(self.manager.weekDayView.frame))];
    
    [self.v_watch addSubview:self.manager.calenderScrollView];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self.manager.calenderScrollView.calendarView addObserver:self forKeyPath:@"currentDate" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    self.manager.calenderScrollView.tableView.isNeedPlaceholderView = YES;
    self.manager.calenderScrollView.tableView.firstReload = YES;
    
    WS(weakSelf);
    [self.manager.calenderScrollView.tableView setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.manager.calenderScrollView.tableView.isNetAvailable = NO;
        [strongSelf requestDutyDetail:strongSelf.manager.calenderScrollView.calendarView.selectedDate];
    }];
    
    [LTSCalendarAppearance share].scrollBgcolor = [UIColor clearColor];
    [LTSCalendarAppearance share].weekDayTextColor = DefaultTextColor;
    [LTSCalendarAppearance share].dayTextColor = DefaultTextColor;
    [LTSCalendarAppearance share].dayTextColorSelected = [UIColor whiteColor];
    [LTSCalendarAppearance share].weekDayTextFont = [UIFont systemFontOfSize:14.f];
    [LTSCalendarAppearance share].dayTextFont = [UIFont systemFontOfSize:14.f];
    [LTSCalendarAppearance share].isShowLunarCalender = NO;
    [LTSCalendarAppearance share].dayCircleColorSelected = DefaultColor;
    [LTSCalendarAppearance share].dayCircleColorToday = DefaultColor;
    [LTSCalendarAppearance share].dayCircleSize = 30;
    
    [self.manager reloadAppearanceAndData];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = [LTSCalendarAppearance share].calendar.timeZone;
    dateFormatter.dateFormat = @"yyyy年MM月";
    
    self.date = [dateFormatter stringFromDate:self.manager.calenderScrollView.calendarView.currentDate];
    if (self.pageType == 0) {
        _lb_title.text = self.date;
        [self requestDuty:self.manager.calenderScrollView.calendarView.currentDate.yyyyMMByLineWithDate];
        [self requestDutyDetail:self.manager.calenderScrollView.calendarView.currentDate];
    }
    
}

- (void)configTaskView{
    
    
    _tb_task.isNeedPlaceholderView = YES;
    _tb_task.firstReload = YES;
    
    [self initRefresh];
    [_tb_task.mj_header beginRefreshing];
    
    [_tb_task registerNib:[UINib nibWithNibName:@"ActionDetailCell" bundle:nil] forCellReuseIdentifier:@"ActionDetailCellID"];
    
    WS(weakSelf);
    //点击重新加载之后的处理
    [_tb_task setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_task.isNetAvailable = NO;
        [strongSelf.tb_task.mj_header beginRefreshing];
    }];
    
    [self setUpDropdownMenu];
    
}

- (void)setUpDropdownMenu{
    
    NSArray *items = @[@"全部", @"进行中", @"已完成"];
    
    _menuView = [[PFNavigationDropdownMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)
                                                          title:items.firstObject
                                                          items:items
                                                  containerView:_v_task];
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
    WS(weakSelf);
    _menuView.didSelectItemAtIndexHandler = ^(NSUInteger indexPath){
        NSLog(@"Did select item at index: %ld", indexPath);
        SW(strongSelf, weakSelf);
        if (indexPath == 0) {
            strongSelf.taskStatus = - 1;
        }else{
            strongSelf.taskStatus = indexPath;
        }
        
        [strongSelf reloadTaskData];
        
    };
    
    [_v_task addSubview:_menuView];
    [_menuView configureForAutoLayout];
    [_menuView autoSetDimension:ALDimensionHeight toSize:44];
    [_menuView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [_menuView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
    [_menuView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:0];
    [_v_task layoutIfNeeded];
    
    [self.view bringSubviewToFront:_v_nav];
}

#pragma mark - 创建下拉刷新，以及上拉加载更多

- (void)initRefresh{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadTaskData)];
    [header setTitle:@"下拉查询" forState:MJRefreshStateIdle];
    [header setTitle:@"松手开始查询" forState:MJRefreshStatePulling];
    [header setTitle:@"查询中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    _tb_task.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadTaskData)];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"— 没有更多内容了 —" forState:MJRefreshStateNoMoreData];
    
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    footer.stateLabel.textColor = UIColorFromRGB(0xa6a6a6);
    _tb_task.mj_footer = footer;
    _tb_task.mj_footer.automaticallyHidden = YES;
    
}


#pragma mark - set && get

- (void)setPageType:(NSInteger)pageType{

    _pageType = pageType;
    
    if (_pageType == 0) {
        _btn_watch.backgroundColor = DefaultColor;
        [_btn_watch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _btn_task.backgroundColor = [UIColor whiteColor];
        [_btn_task setTitleColor:DefaultTextColor forState:UIControlStateNormal];
        
        [self.view bringSubviewToFront:_v_watch];
        [self.view sendSubviewToBack:_v_task];
        [self.view bringSubviewToFront:_v_nav];
        _lb_title.text = _date;
        
    }else if (_pageType == 1){
        
        _btn_task.backgroundColor = DefaultColor;
        [_btn_task setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn_watch.backgroundColor = [UIColor whiteColor];
        [_btn_watch setTitleColor:DefaultTextColor forState:UIControlStateNormal];
        
        [self.view bringSubviewToFront:_v_task];
        [self.view sendSubviewToBack:_v_watch];
        [self.view bringSubviewToFront:_v_nav];
        _lb_title.text = @"行动";
    }

}

- (void)setButtonIndex:(NSInteger)index{
    
    if (index == 0) {
        [self setPageType:0];
        [self receiveDuty:nil];
    }else{
        [self setPageType:1];
        [self receiveAction:nil];
    }

}

#pragma mark - 请求排班数据

- (void)requestDuty:(NSString *)date{
    
    WS(weakSelf);
    
    DutyGetDutyByMonthManger *manger = [[DutyGetDutyByMonthManger alloc] init];
    manger.dateStr = date;
    manger.isNoShowFail = YES;
    //[manger configLoadingTitle:@"请求"];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        if (strongSelf.arr_data && strongSelf.arr_data.count > 0) {
            [strongSelf.arr_data removeAllObjects];
        }
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            for (DutyMonthModel *model in manger.monthReponse) {
                NSString *t_str = [NSString stringWithFormat:@"%@%@日",strongSelf.date,model.dutyDay];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy年MM月dd日"];
                
                NSDate * date = [formatter dateFromString:t_str];
                [strongSelf.arr_data addObject:date];
            }
            
            [strongSelf.manager reloadAppearanceAndData];
            
        }else{
            
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //SW(strongSelf, weakSelf);
        
        
    }];
    
}

#pragma mark - 请求某具体的一天值班

- (void)requestDutyDetail:(NSDate *)date{
    
    NSString *dateStr = date.yyyyMMddByLineWithDate;
    WS(weakSelf);
    DutyGetWorkByDayManger *manger = [[DutyGetWorkByDayManger alloc] init];
    manger.dateStr = dateStr;
    [manger configLoadingTitle:@"请求"];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        strongSelf.manager.calenderScrollView.reponse = manger.workReponse;
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}

#pragma mark - 请求任务数据

- (void)reloadTaskData{
    self.index = 0;
    [self loadTaskData];
}

- (void)loadTaskData{
    
    if (_index == 0) {
        if (_arr_tasks && _arr_tasks.count > 0) {
            [_arr_tasks removeAllObjects];
        }
    }
    
    WS(weakSelf);
    ActionGetTypeListParam *param = [[ActionGetTypeListParam alloc] init];
    param.start = _index;
    param.length = 10;
    if (self.taskStatus != -1 ) {
         param.actionStatus = @(self.taskStatus);
    }
   
    ActionGetTypeListManger *manger = [[ActionGetTypeListManger alloc] init];
    manger.param = param;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        
        [strongSelf.tb_task.mj_header endRefreshing];
        [strongSelf.tb_task.mj_footer endRefreshing];
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            [strongSelf.arr_tasks addObjectsFromArray:manger.actionReponse.list];
            if (strongSelf.arr_tasks.count == manger.actionReponse.total) {
                [strongSelf.tb_task.mj_footer endRefreshingWithNoMoreData];
            }else{
                strongSelf.index += param.length;
            }
            
            [strongSelf.tb_task reloadData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        [strongSelf.tb_task.mj_header endRefreshing];
        [strongSelf.tb_task.mj_footer endRefreshing];
        
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            if (strongSelf.arr_tasks.count > 0) {
                [strongSelf.arr_tasks removeAllObjects];
            }
            strongSelf.tb_task.isNetAvailable = YES;
            [strongSelf.tb_task reloadData];
        }
        
    }];
    
}


#pragma mark - ButtonAction

- (IBAction)handleBtnWatchClicked:(id)sender {
    self.pageType = 0;
    [[ShareValue sharedDefault] setDutyTip:NO];
    _v_tip_duty.hidden = YES;
}

- (IBAction)handleBtnTaskClicked:(id)sender {
    self.pageType = 1;
    [[ShareValue sharedDefault] setActionTip:NO];
    _v_tip_action.hidden = YES;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_tasks.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf);
    return [tableView fd_heightForCellWithIdentifier:@"ActionDetailCellID" cacheByIndexPath:indexPath configuration:^(ActionDetailCell *cell) {
        SW(strongSelf,weakSelf);
        if (strongSelf.arr_tasks && strongSelf.arr_tasks.count > 0) {
            ActionTaskListModel *t_model = strongSelf.arr_tasks[indexPath.row];
            cell.model = t_model;
            
        }
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ActionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActionDetailCellID"];
    
    if (_arr_tasks && _arr_tasks.count > 0) {
        ActionTaskListModel *t_model = _arr_tasks[indexPath.row];
        cell.model = t_model;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_arr_tasks && _arr_tasks.count > 0) {
        
        UserTaskDetailVC *t_vc = [[UserTaskDetailVC alloc] init];
        t_vc.model = _arr_tasks[indexPath.row];
        [self.navigationController pushViewController:t_vc animated:YES];
        
    }
    
}


#pragma mark - LTSCalendarEventSource

- (BOOL)calendarHaveEventWithDate:(NSDate *)date{
    if (self.arr_data && self.arr_data.count > 0) {
        for (NSDate * duty in self.arr_data) {
            if ([self.manager.calenderScrollView.calendarView isEqual:duty other:date]) {
                return YES;
            }
        }
    }
    return NO;
    
}

- (UIColor *)calendarHaveEventDotColorWithDate:(NSDate *)date{
    
    NSTimeInterval secs = [date timeIntervalSinceDate:[NSDate date]];
    if (secs < 0) {
        return UIColorFromRGB(0xd2d2d2);
    }
    
    return DefaultColor;
    
}


- (void)calendarDidSelectedDate:(NSDate *)date{
    
    
    [self requestDutyDetail:date];
    
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"currentDate"] && object == self.manager.calenderScrollView.calendarView){
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = [LTSCalendarAppearance share].calendar.timeZone;
        dateFormatter.dateFormat = @"yyyy年MM月";
        
        NSString * date = [dateFormatter stringFromDate:self.manager.calenderScrollView.calendarView.currentDate];
        if (self.pageType == 0) {
            _lb_title.text = date;
        }
        
        if (![self.date isEqualToString: date]) {
            self.date = date;
            [self requestDuty:self.manager.calenderScrollView.calendarView.currentDate.yyyyMMByLineWithDate];
            
        }
        
        
    }
}


#pragma mark - notification

- (void)receiveDuty:(NSNotification *)notice{
    
    NSDictionary *aps = notice.object;

    if (aps) {
        WS(weakSelf);
        SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:[aps objectForKey:@"alert"]
                                                    leftActionTitle:nil
                                                   rightActionTitle:@"确定"
                                                     animationStyle:AlertViewAnimationNone
                                                       selectAction:^(AlertViewActionType actionType) {
                                                           SW(strongSelf, weakSelf);
                                                           [strongSelf requestDuty:strongSelf.manager.calenderScrollView.calendarView.currentDate.yyyyMMByLineWithDate];
                                                           [strongSelf requestDutyDetail:strongSelf.manager.calenderScrollView.calendarView.currentDate];
                                                           
                                                           
                                                       }];
        alertView.blurCurrentBackgroundView = NO;
        [alertView show];
        
        return;
        
    }
    
    [self requestDuty:self.manager.calenderScrollView.calendarView.currentDate.yyyyMMByLineWithDate];
    [self requestDutyDetail:self.manager.calenderScrollView.calendarView.currentDate];
    
    
}

- (void)receiveAction:(NSNotification *)notice{
    
    NSDictionary *aps = notice.object;
    
    if (aps) {
        WS(weakSelf);
        SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:[aps objectForKey:@"alert"]
                                                    leftActionTitle:nil
                                                   rightActionTitle:@"确定"
                                                     animationStyle:AlertViewAnimationNone
                                                       selectAction:^(AlertViewActionType actionType) {
                                                           SW(strongSelf, weakSelf);
                                                           [strongSelf reloadTaskData];
                                                           
                                                           
                                                       }];
        alertView.blurCurrentBackgroundView = NO;
        [alertView show];
        
        return;
    }
    
    [self reloadTaskData];
    
}

#pragma mark - AKTabBar Method

- (NSString *)tabImageName{
    return @"tabbar_list_n";
}

- (NSString *)tabSelectedImageName{
    return @"tabbar_list_h";
}

- (NSString *)tabTitle{
    return NSLocalizedString(@"日程", nil);
}

-(BOOL)showTip{
    
    if (ApplicationDelegate.vc_tabBar.selectedIndex == 1) {
        return NO;
    }else{
        return [ShareValue sharedDefault].dutyTip || [ShareValue sharedDefault].actionTip;
    }
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
   [self.manager.calenderScrollView.calendarView removeObserver:self forKeyPath:@"currentDate"];
    LxPrintf(@"ScheduleVC dealloc");
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
