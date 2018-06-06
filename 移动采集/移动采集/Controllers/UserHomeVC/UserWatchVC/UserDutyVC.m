//
//  UserDutyVC.m
//  移动采集
//
//  Created by hcat on 2017/10/26.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "UserDutyVC.h"
#import "DutyCell.h"
#import "DutyAPI.h"

#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface UserDutyVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_tableViewHeight;

@property (nonatomic, strong) NSMutableArray <DutyPeopleModel *> * leaderList;
@property (nonatomic, strong) NSMutableArray <DutyPeopleModel *> * policeList;
@property (nonatomic, strong) NSMutableArray <DutyPeopleModel *> * othersList;


@end

@implementation UserDutyVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"排班详情";
    
    self.leaderList = [NSMutableArray array];
    self.policeList = [NSMutableArray array];
    self.othersList = [NSMutableArray array];
    
    WS(weakSelf);
    _tableView.isNeedPlaceholderView = YES;
    _tableView.firstReload = YES;
    [_tableView setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tableView.isNetAvailable = NO;
        [strongSelf requestDuty];
    }];
    
    [_tableView registerNib:[UINib nibWithNibName:@"DutyCell" bundle:nil] forCellReuseIdentifier:@"DutyCellID"];
    
    [self requestDuty];
    
}

#pragma mark - 请求数据

- (void)requestDuty{
    
    WS(weakSelf);
    
    DutyGetDutyByDayManger * manger = [[DutyGetDutyByDayManger alloc] init];
    manger.dateStr = _dateStr;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            [strongSelf.leaderList addObjectsFromArray:manger.dutyGetDutyByDayReponse.leaderList];
            [strongSelf.policeList addObjectsFromArray:manger.dutyGetDutyByDayReponse.policeList];
            [strongSelf.othersList addObjectsFromArray:manger.dutyGetDutyByDayReponse.othersList];
            [strongSelf.tableView reloadData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            SW(strongSelf, weakSelf);
            strongSelf.tableView.isNetAvailable = YES;
            [strongSelf.tableView reloadData];
        }
        
    }];
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WS(weakSelf);
    return [tableView fd_heightForCellWithIdentifier:@"DutyCellID" cacheByIndexPath:indexPath configuration:^(DutyCell *cell) {
        SW(strongSelf, weakSelf);
        
        if (indexPath.row == 0) {
            cell.lb_people.text =  [NSString stringWithFormat:@"%@ 09:00-17:30",_dateStr];
            
        }else if (indexPath.row == 1){
            
            if (strongSelf.leaderList.count > 0) {
                NSMutableArray *t_arr = [NSMutableArray array];
                for (DutyPeopleModel *model in strongSelf.leaderList) {
                    [t_arr addObject:model.realName];
                }
                cell.lb_people.text = [t_arr componentsJoinedByString:@","];
            }
            
        }else if (indexPath.row == 2){
            
            if (strongSelf.policeList.count > 0) {
                NSMutableArray *t_arr = [NSMutableArray array];
                for (DutyPeopleModel *model in strongSelf.policeList) {
                    [t_arr addObject:model.realName];
             
                }
                cell.lb_people.text = [t_arr componentsJoinedByString:@","];
            }
            
            
        }else if (indexPath.row == 3){
            
            if (strongSelf.othersList.count > 0) {
                NSMutableArray *t_arr = [NSMutableArray array];
                for (DutyPeopleModel *model in strongSelf.othersList) {
                    [t_arr addObject:model.realName];
                    
                }
                cell.lb_people.text = [t_arr componentsJoinedByString:@","];
            }
        
        }
        
        
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DutyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DutyCellID"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.lb_title.text = @"值班日期";
        cell.lb_title.backgroundColor = UIColorFromRGB(0xf26262);
        cell.lb_people.text = [NSString stringWithFormat:@"%@ 09:00-17:30",_dateStr];
        
    }else if (indexPath.row == 1){
        cell.lb_title.text = @"值班领导";
        cell.lb_title.backgroundColor = UIColorFromRGB(0x45a6ea);
        if (self.leaderList.count > 0) {
            NSMutableArray *t_arr = [NSMutableArray array];
            for (DutyPeopleModel *model in self.leaderList) {
                [t_arr addObject:model.realName];
            }
            cell.lb_people.text = [t_arr componentsJoinedByString:@","];
        }
        
    }else if (indexPath.row == 2){
        cell.lb_title.text = @"值班民警";
        cell.lb_title.backgroundColor = UIColorFromRGB(0xfaad37);
        if (self.policeList.count > 0) {
            NSMutableArray *t_arr = [NSMutableArray array];
            for (DutyPeopleModel *model in self.policeList) {
                [t_arr addObject:model.realName];
              
            }
            cell.lb_people.text = [t_arr componentsJoinedByString:@","];
        }
        
    }else if (indexPath.row == 3){
        cell.lb_title.text = @"值班辅警";
        cell.lb_title.backgroundColor = UIColorFromRGB(0x787ef3);
        if (self.othersList.count > 0) {
            NSMutableArray *t_arr = [NSMutableArray array];
            for (DutyPeopleModel *model in self.othersList) {
                [t_arr addObject:model.realName];
            }
            cell.lb_people.text = [t_arr componentsJoinedByString:@","];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - scrollViewDelegate
//用于滚动到顶部的时候使得tableView不能再继续下拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _tableView){
        
        [_tableView resignFirstResponder];
        if (scrollView.contentOffset.y < 0) {
            CGPoint position = CGPointMake(0, 0);
            [scrollView setContentOffset:position animated:NO];
            return;
        }
    }
}




#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"UserDutyVC dealloc");
    
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
