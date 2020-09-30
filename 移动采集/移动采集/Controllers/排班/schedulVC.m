//
//  schedulVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/20.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "schedulVC.h"
#import <PureLayout.h>
#import "LTSCalendarManager.h"
#import "NSDate+Formatter.h"
#import "DutyAPI.h"

#import <MJRefresh.h>
#import "UITableView+Lr_Placeholder.h"
#import "NetWorkHelper.h"
#import "SRAlertView.h"

@interface schedulVC ()<LTSCalendarEventSource>

@property (weak, nonatomic) IBOutlet UIView *v_nav;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;

/******************** 值班视图相关 ********************/
@property (weak, nonatomic) IBOutlet UIView *v_watch;   //值班视图
@property (strong, nonatomic)LTSCalendarManager *manager;
@property (copy, nonatomic) NSString *date; //显示的年月
@property (strong, nonatomic) NSMutableArray * arr_data;


@end

@implementation schedulVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"值班";
    
    self.arr_data = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDuty:) name:NOTIFICATION_RECEIVENOTIFICATION_DUTY object:nil];
    
    [self configWatchView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
   
    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        
        SW(strongSelf, weakSelf);
        
        self.manager.calenderScrollView.tableView.isNetAvailable = NO;
        [strongSelf requestDutyDetail:strongSelf.manager.calenderScrollView.calendarView.selectedDate];
        
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
    _lb_title.text = self.date;
    [self requestDuty:self.manager.calenderScrollView.calendarView.currentDate.yyyyMMByLineWithDate];
    [self requestDutyDetail:self.manager.calenderScrollView.calendarView.currentDate];
    
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
        _lb_title.text = date;
        
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

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
   [self.manager.calenderScrollView.calendarView removeObserver:self forKeyPath:@"currentDate"];
    LxPrintf(@"ScheduleVC dealloc");
    
}


@end
