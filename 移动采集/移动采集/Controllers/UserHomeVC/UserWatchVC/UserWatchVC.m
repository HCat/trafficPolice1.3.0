//
//  UserWatchVC.m
//  移动采集
//
//  Created by hcat on 2017/10/24.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "UserWatchVC.h"
#import <PureLayout.h>
#import "NSDate+Formatter.h"

#define kWidthSpace 33
#define KHeightItem 37
#define kCalendarOfWidth (SCREEN_WIDTH - (2 * kWidthSpace))

@interface UserWatchVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_lead;
@property (weak, nonatomic) IBOutlet UIView *v_calendar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_calendar_height;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dayModelArray;

@property (weak, nonatomic) IBOutlet UILabel *lb_month;
@property (weak, nonatomic) IBOutlet UIView *v_month;

@property (strong, nonatomic) NSDate *tempDate;


@end

@implementation UserWatchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.v_calendar addSubview:self.collectionView];
    self.v_calendar.layer.borderWidth = 1.0f;
    self.v_calendar.layer.borderColor = [UIColorFromRGB(0xf5ae42) CGColor];
    self.v_calendar.layer.masksToBounds = YES;
    [_collectionView configureForAutoLayout];
    [_collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
    [_collectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_v_month];
    
    self.tempDate = [NSDate date];
    [self getDataDayModel:self.tempDate];

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tempDate = [NSDate date];
    [self getDataDayModel:self.tempDate];
    
}


#pragma mark - set && get

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        NSInteger width = kCalendarOfWidth/7;
        NSInteger height = KHeightItem;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(width, height);
        flowLayout.headerReferenceSize = CGSizeMake(kCalendarOfWidth, KHeightItem);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, width * 7, 200) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
        [_collectionView registerClass:[CalendarHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CalendarHeaderView"];
        
    }
    return _collectionView;
}

#pragma mark - privateMethods

- (void)getDataDayModel:(NSDate *)date{
    
    self.lb_month.text = date.mmChineseWithDate;
    
    if ([[NSDate date].mmWithDate isEqualToString:date.mmWithDate]) {
        self.lb_title.text = @"当月值班";
    }else{
        self.lb_title.text = [NSString stringWithFormat:@"%@月值班",date.mmWithDate];
    }

    NSUInteger days = [self numberOfDaysInMonth:date];
    NSInteger week = [self startDayOfWeek:date];
    self.dayModelArray = [[NSMutableArray alloc] initWithCapacity:42];
    int day = 1;
    for (int i= 1; i<days+week; i++) {
        if (i<week) {
            [self.dayModelArray addObject:@""];
        }else{
            MonthModel *mon = [MonthModel new];
            mon.dayValue = day;
            NSDate *dayDate = [self dateOfDay:day];
            mon.dateValue = dayDate;
            if ([dayDate.yyyyMMddByLineWithDate isEqualToString:[NSDate date].yyyyMMddByLineWithDate]) {
                mon.isSelectedDay = YES;
            }
            [self.dayModelArray addObject:mon];
            day++;
        }
    }
    [self.collectionView reloadData];
    
    if (self.dayModelArray && self.dayModelArray.count > 0) {
        
        self.layout_calendar_height.constant = ((int)ceil(self.dayModelArray.count/7.0) + 1) * KHeightItem + 50;
        
        [self.view layoutIfNeeded];
    }
    
}

#pragma mark - 获取这个月的天数

- (NSUInteger)numberOfDaysInMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [greCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    
}

#pragma mark - 获取这个月第一天的日期

- (NSDate *)firstDateOfMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:date];
    comps.day = 1;
    return [greCalendar dateFromComponents:comps];
}

#pragma mark - 获取这个月第一天是星期几

- (NSUInteger)startDayOfWeek:(NSDate *)date
{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//Asia/Shanghai
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:[self firstDateOfMonth:date]];
    return comps.weekday;
}

#pragma mark - 获取上个月

- (NSDate *)getLastMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:date];
    comps.month -= 1;
    return [greCalendar dateFromComponents:comps];
}

#pragma mark - 获取下个月

- (NSDate *)getNextMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:date];
    comps.month += 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSDate *)dateOfDay:(NSInteger)day{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:self.tempDate];
    comps.day = day;
    return [greCalendar dateFromComponents:comps];
}


#pragma mark - buttonAction

- (IBAction)handleBtnNextMonthClicked:(id)sender {
    
    self.tempDate = [self getNextMonth:self.tempDate];
    [self getDataDayModel:self.tempDate];
    
}


- (IBAction)handleBtnPreMonthClicked:(id)sender {
    
    self.tempDate = [self getLastMonth:self.tempDate];
    [self getDataDayModel:self.tempDate];
    
}

#pragma mark - UICollectionView delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dayModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
    cell.dayLabel.backgroundColor = [UIColor whiteColor];
    cell.dayLabel.textColor = UIColorFromRGB(0x444444);
    id mon = self.dayModelArray[indexPath.row];
    if ([mon isKindOfClass:[MonthModel class]]) {
        cell.monthModel = (MonthModel *)mon;
    }else{
        cell.dayLabel.text = @"";
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CalendarHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CalendarHeaderView" forIndexPath:indexPath];
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    id mon = self.dayModelArray[indexPath.row];
    if ([mon isKindOfClass:[MonthModel class]]) {
        
    }
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"UserWatchVC dealloc");
    
}

@end

@implementation CalendarHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        NSArray *weekArray = [[NSArray alloc] initWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
        
        for (int i=0; i<weekArray.count; i++) {
            
            UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(i* kCalendarOfWidth/7, 0, kCalendarOfWidth/7, KHeightItem)];
            
            weekLabel.textAlignment = NSTextAlignmentCenter;
            weekLabel.textColor = UIColorFromRGB(0x444444);
            if (i == 0 || i == [weekArray count] - 1) {
                weekLabel.textColor = UIColorFromRGB(0xfa3e3e);
            }
            
            weekLabel.font = [UIFont systemFontOfSize:13.f];
            weekLabel.text = weekArray[i];
            [self addSubview:weekLabel];
        }
        
    }
    return self;
}

@end

@implementation CalendarCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        CGFloat width = 28;
        CGFloat height = 28;
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake( self.contentView.frame.size.width*0.5-width*0.5,  self.contentView.frame.size.height*0.5-height*0.5, width, height )];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.layer.masksToBounds = YES;
        dayLabel.layer.cornerRadius = height * 0.5;
        
        [self.contentView addSubview:dayLabel];
        
        self.dayLabel = dayLabel;
        
    
    }
    return self;
}

- (void)setMonthModel:(MonthModel *)monthModel{
    
    _monthModel = monthModel;
    
    self.dayLabel.text = [NSString stringWithFormat:@"%ld",monthModel.dayValue];
    
    
    if (self.v_today) {
        [self.v_today removeFromSuperview];
        self.v_today = nil;
    }
    
    if (monthModel.isSelectedDay) {
        
        self.v_today = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.dayLabel.frame), CGRectGetMinY(self.dayLabel.frame), 5, 5)];
        self.v_today.layer.cornerRadius = 5.0/2;
        self.v_today.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.v_today];
        
    }
}
@end


@implementation MonthModel

@end


