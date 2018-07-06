//
//  LTSCalendarScrollView.m
//  LTSCalendar
//
//  Created by 李棠松 on 2018/1/13.
//  Copyright © 2018年 leetangsong. All rights reserved.
//

#import "LTSCalendarScrollView.h"
#import "NetWorkHelper.h"

#import "DutyLeaderCell.h"
#import "DutyPoliceCell.h"
#import "DutyHeaderCell.h"

@interface LTSCalendarScrollView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *line;

@property (nonatomic,strong) NSMutableArray *arr_leading;
@property (nonatomic,strong) NSMutableArray *arr_police;
@property (nonatomic,strong) NSMutableArray *arr_help;

@end


@implementation LTSCalendarScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
    self.tableView.backgroundColor = bgColor;
    self.line.backgroundColor = bgColor;
}

- (void)setReponse:(DutyGetWorkByDayReponse *)reponse{
    _reponse = reponse;
    
    if (_reponse) {
        self.arr_leading = [NSMutableArray arrayWithArray:_reponse.leaderList];
        self.arr_police = [NSMutableArray arrayWithArray:_reponse.policeTeam];
        self.arr_help = [NSMutableArray arrayWithArray:_reponse.helpTeam];
        [self.tableView reloadData];
    }else{
        self.arr_leading = [NSMutableArray array];
        self.arr_police = [NSMutableArray array];
        self.arr_help = [NSMutableArray array];
        [self.tableView reloadData];
    }

}


- (void)initUI{
    
    self.delegate = self;
    self.bounces = false;
    self.showsVerticalScrollIndicator = false;
    self.backgroundColor = [LTSCalendarAppearance share].scrollBgcolor;
    LTSCalendarContentView *calendarView = [[LTSCalendarContentView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, [LTSCalendarAppearance share].weekDayHeight*[LTSCalendarAppearance share].weeksToDisplay)];
    calendarView.currentDate = [NSDate date];
    [self addSubview:calendarView];
    self.calendarView = calendarView;
    self.line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(calendarView.frame), CGRectGetWidth(self.frame),0.5)];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(calendarView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetMaxY(calendarView.frame))];
    self.tableView.backgroundColor = self.backgroundColor;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);

    self.tableView.scrollEnabled = [LTSCalendarAppearance share].isShowSingleWeek;
    
    [self addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DutyLeaderCell" bundle:nil] forCellReuseIdentifier:@"DutyLeaderCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DutyPoliceCell" bundle:nil] forCellReuseIdentifier:@"DutyPoliceCellID"];
     [self.tableView registerNib:[UINib nibWithNibName:@"DutyHeaderCell" bundle:nil] forCellReuseIdentifier:@"DutyHeaderCellID"];
    
    
    
    self.line.backgroundColor = self.backgroundColor;
    [self addSubview:self.line];
    [LTSCalendarAppearance share].isShowSingleWeek ? [self scrollToSingleWeek]:[self scrollToAllWeek];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    if (_arr_leading && _arr_leading.count > 0) {
        row += 1;
    }
    if (_arr_police && _arr_police.count > 0) {
        row += 1;
    }
    
    if (_arr_help && _arr_help.count > 0) {
        row += 1;
    }
    if (row > 0) {
        row += 1;
    }
    
    return  row;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0f;
    
    if (indexPath.row == 0) {
        height = 20;
    }else if (indexPath.row == 1) {
        if (_arr_leading && _arr_leading.count > 0) {
            DutyLeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DutyLeaderCellID"];
            height = [cell getHeightWithArray:_arr_leading];
            return height;
        }
        if (_arr_police && _arr_police.count > 0) {
            
            DutyPoliceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DutyPoliceCellID"];
            cell.type = 0;
            height = [cell getHeightWithArr:_arr_police];
            return height;
        }
        
        if (_arr_help && _arr_help.count > 0) {
            DutyPoliceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DutyPoliceCellID"];
            cell.type = 1;
            height = [cell getHeightWithArr:_arr_help];
            return height;
        }
        
       
    }else if (indexPath.row == 2){
        if (_arr_police && _arr_police.count > 0) {
            
            DutyPoliceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DutyPoliceCellID"];
            cell.type = 0;
            height = [cell getHeightWithArr:_arr_police];
            return height;
        }
        
        if (_arr_help && _arr_help.count > 0) {
            DutyPoliceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DutyPoliceCellID"];
            cell.type = 1;
            height = [cell getHeightWithArr:_arr_help];
            return height;
        }
    }else if (indexPath.row == 3){
        if (_arr_help && _arr_help.count > 0) {
            DutyPoliceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DutyPoliceCellID"];
            cell.type = 1;
            height = [cell getHeightWithArr:_arr_help];
            return height;
        }
    }
    
    
    LxPrintf(@"heightcccfcccc = %f",height);
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    if (indexPath.row == 0) {
        DutyHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DutyHeaderCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if (indexPath.row == 1) {
        
        if (_arr_leading && _arr_leading.count > 0) {
            DutyLeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DutyLeaderCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.arr_leader = _arr_leading;
            
            return cell;
        }
        if (_arr_police && _arr_police.count > 0) {
            
            DutyPoliceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DutyPoliceCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
            cell.type = 0;
            cell.arr_group = _arr_police;
            
            return cell;
        }
        
        if (_arr_help && _arr_help.count > 0) {
            DutyPoliceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DutyPoliceCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.type = 1;
            cell.arr_group = _arr_help;
            return cell;
        }
    
    }else if (indexPath.row == 2){
        
        if (_arr_police && _arr_police.count > 0) {
            
            DutyPoliceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DutyPoliceCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.type = 0;
            cell.arr_group = _arr_police;
            
            return cell;
        }
        
        if (_arr_help && _arr_help.count > 0) {
            DutyPoliceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DutyPoliceCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.type = 1;
            cell.arr_group = _arr_help;
            return cell;
        }
    }else if (indexPath.row == 3){
        if (_arr_help && _arr_help.count > 0) {
            DutyPoliceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DutyPoliceCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.type = 1;
            cell.arr_group = _arr_help;
            return cell;
        }
    }
    
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    CGFloat offsetY = scrollView.contentOffset.y;
    
    
    if (scrollView != self) {
        return;
    }
  
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    ///日历需要滑动的距离
    CGFloat calendarCountDistance = self.calendarView.singleWeekOffsetY;
    
    CGFloat scale = calendarCountDistance/tableCountDistance;
    
    CGRect calendarFrame = self.calendarView.frame;
    self.calendarView.maskView.alpha = offsetY/tableCountDistance;
    calendarFrame.origin.y = offsetY-offsetY*scale;
    if(ABS(offsetY) >= tableCountDistance) {
         self.tableView.scrollEnabled = true;
        //为了使滑动更加顺滑，这部操作根据 手指的操作去设置
//         [self.calendarView setSingleWeek:true];
        
    }else{
        
        self.tableView.scrollEnabled = false;
        if ([LTSCalendarAppearance share].isShowSingleWeek) {
           
            [self.calendarView setSingleWeek:false];
        }
    }
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = CGRectGetHeight(self.frame)-CGRectGetHeight(self.calendarView.frame)+offsetY;
    self.tableView.frame = tableFrame;
    self.bounces = false;
    if (offsetY<=0) {
        self.bounces = true;
        calendarFrame.origin.y = offsetY;
        tableFrame.size.height = CGRectGetHeight(self.frame)-CGRectGetHeight(self.calendarView.frame);
        self.tableView.frame = tableFrame;
    }
    self.calendarView.frame = calendarFrame;
    
    
    
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    if ( appearce.isShowSingleWeek) {
        if (self.contentOffset.y != tableCountDistance) {
            return  nil;
        }
    }
    if ( !appearce.isShowSingleWeek) {
        if (self.contentOffset.y != 0 ) {
            return  nil;
        }
    }

    return  [super hitTest:point withEvent:event];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self != scrollView) {
        return;
    }
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);

    if (scrollView.contentOffset.y>=tableCountDistance) {
        [self.calendarView setSingleWeek:true];
    }
    
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self != scrollView) {
        return;
    }
   
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    //point.y<0向上
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:scrollView];
    
    if (point.y<=0) {
       
        [self scrollToSingleWeek];
    }
    
    if (scrollView.contentOffset.y<tableCountDistance-20&&point.y>0) {
        [self scrollToAllWeek];
    }
}
//手指触摸完
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self != scrollView) {
        return;
    }
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    //point.y<0向上
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:scrollView];
    
    
    if (point.y<=0) {
        if (scrollView.contentOffset.y>=20) {
            if (scrollView.contentOffset.y>=tableCountDistance) {
                [self.calendarView setSingleWeek:true];
            }
            [self scrollToSingleWeek];
        }else{
            [self scrollToAllWeek];
        }
    }else{
        if (scrollView.contentOffset.y<tableCountDistance-20) {
            [self scrollToAllWeek];
        }else{
            [self scrollToSingleWeek];
        }
    }
  
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self != scrollView) {
        return;
    }
     [self.calendarView setUpVisualRegion];
}


- (void)scrollToSingleWeek{
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    [self setContentOffset:CGPointMake(0, tableCountDistance) animated:true];
    
    
}

- (void)scrollToAllWeek{
    [self setContentOffset:CGPointMake(0, 0) animated:true];
}


- (void)layoutSubviews{
    [super layoutSubviews];

    self.contentSize = CGSizeMake(0, CGRectGetHeight(self.frame)+[LTSCalendarAppearance share].weekDayHeight*([LTSCalendarAppearance share].weeksToDisplay-1));
}

@end
