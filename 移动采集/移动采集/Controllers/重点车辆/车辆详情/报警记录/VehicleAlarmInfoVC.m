//
//  VehicleAlarmInfoVC.m
//  移动采集
//
//  Created by hcat on 2018/5/14.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleAlarmInfoVC.h"
#import "VehicleAPI.h"
#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "NetWorkHelper.h"


#import "VehicleAreaAlarmCell.h"
#import "VehicleRoadAlarmCell.h"
#import "VehicleTiredAlarmCell.h"
#import "VehicleExpireAlarmCell.h"
#import "VehicleSpeedAlarmListVC.h"
#import "VehicleExpireAlarmVC.h"
#import "VehicleTiredAlarmVC.h"



#import "VehicleCarMoreVC.h"



@interface VehicleAlarmInfoVC ()

@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (strong,nonatomic) VehicleAlarmRecordReponse *reponse;


@end

@implementation VehicleAlarmInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tb_content.isNeedPlaceholderView = YES;
    _tb_content.str_placeholder = @"暂无报警记录";
    _tb_content.firstReload = YES;
    [_tb_content registerNib:[UINib nibWithNibName:@"VehicleAreaAlarmCell" bundle:nil] forCellReuseIdentifier:@"VehicleAreaAlarmCellID"];
    [_tb_content registerNib:[UINib nibWithNibName:@"VehicleRoadAlarmCell" bundle:nil] forCellReuseIdentifier:@"VehicleRoadAlarmCellID"];
    [_tb_content registerNib:[UINib nibWithNibName:@"VehicleTiredAlarmCell" bundle:nil] forCellReuseIdentifier:@"VehicleTiredAlarmCellID"];
    [_tb_content registerNib:[UINib nibWithNibName:@"VehicleExpireAlarmCell" bundle:nil] forCellReuseIdentifier:@"VehicleExpireAlarmCellID"];
    
    WS(weakSelf);
    [_tb_content setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        [strongSelf loadData];
    }];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        [strongSelf loadData];
    };
    
}

#pragma mark - 请求数据

- (void)loadData{
    WS(weakSelf);
    
    VehicleAlarmRecordManger *manger = [[VehicleAlarmRecordManger alloc] init];
    manger.vehicleId = _vehicleId;
    [manger configLoadingTitle:@"查询"];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.reponse = manger.vehicleAlarmRecord;
            [strongSelf.tb_content reloadData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf,weakSelf);
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            strongSelf.reponse = nil;
            strongSelf.tb_content.isNetAvailable = YES;
            [strongSelf.tb_content reloadData];
        }
        
    }];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.reponse.arr_type.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WS(weakSelf);
    NSString *model =  self.reponse.arr_type[indexPath.row];

    if ([model isEqualToString:@"VehicleAreaAlarmModel"]) {
        return [tableView fd_heightForCellWithIdentifier:@"VehicleAreaAlarmCellID" cacheByIndexPath:indexPath configuration:^(VehicleAreaAlarmCell *cell) {
            SW(strongSelf, weakSelf);
            cell.areaAlarmModel = strongSelf.reponse.areaSpeedAlarm;
        }];
    }
    
    if ([model isEqualToString:@"VehicleRoadAlarmModel"]) {
        return [tableView fd_heightForCellWithIdentifier:@"VehicleRoadAlarmCellID" cacheByIndexPath:indexPath configuration:^(VehicleRoadAlarmCell *cell) {
            SW(strongSelf, weakSelf);
            cell.roadAlarmModel = strongSelf.reponse.roadSpeedAlarm;
        }];
    }
    
    if ([model isEqualToString:@"VehicleTiredAlarmModel"]) {
        return [tableView fd_heightForCellWithIdentifier:@"VehicleTiredAlarmCellID" cacheByIndexPath:indexPath configuration:^(VehicleTiredAlarmCell *cell) {
            SW(strongSelf, weakSelf);
            cell.tiredAlarmModel = strongSelf.reponse.fatigueAlarm;
        }];
    }
    
    if ([model isEqualToString:@"VehicleExpireAlarmModel"]) {
        return [tableView fd_heightForCellWithIdentifier:@"VehicleExpireAlarmCellID" cacheByIndexPath:indexPath configuration:^(VehicleExpireAlarmCell *cell) {
            SW(strongSelf, weakSelf);
            cell.expireAlarmModel = strongSelf.reponse.vehicleExpireAlarm;
        }];
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *model =  self.reponse.arr_type[indexPath.row];
    
    if ([model isEqualToString:@"VehicleAreaAlarmModel"]) {
        VehicleAreaAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleAreaAlarmCellID"];
        cell.fd_enforceFrameLayout = NO;
        cell.areaAlarmModel = self.reponse.areaSpeedAlarm;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    if ([model isEqualToString:@"VehicleRoadAlarmModel"]) {
        VehicleRoadAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleRoadAlarmCellID"];
        cell.fd_enforceFrameLayout = NO;
        cell.roadAlarmModel = self.reponse.roadSpeedAlarm;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    if ([model isEqualToString:@"VehicleTiredAlarmModel"]) {
        VehicleTiredAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleTiredAlarmCellID"];
        cell.fd_enforceFrameLayout = NO;
        cell.tiredAlarmModel = self.reponse.fatigueAlarm;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    if ([model isEqualToString:@"VehicleExpireAlarmModel"]) {
        VehicleExpireAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleExpireAlarmCellID"];
        cell.fd_enforceFrameLayout = NO;
        cell.expireAlarmModel = self.reponse.vehicleExpireAlarm;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VehicleCarMoreVC *vc_target = (VehicleCarMoreVC *)[ShareFun findViewController:self.view withClass:[VehicleCarMoreVC class]];
    
    NSString *model =  self.reponse.arr_type[indexPath.row];
    
    if ([model isEqualToString:@"VehicleAreaAlarmModel"]) {
        VehicleSpeedAlarmListVC * t_vc = [[VehicleSpeedAlarmListVC alloc] init];
        t_vc.vehicleid = _vehicleId;
        t_vc.alarmType = @"1";
        [vc_target.navigationController pushViewController:t_vc animated:YES];
        
    }
    
    if ([model isEqualToString:@"VehicleRoadAlarmModel"]) {
        VehicleSpeedAlarmListVC * t_vc = [[VehicleSpeedAlarmListVC alloc] init];
        t_vc.vehicleid = _vehicleId;
        t_vc.alarmType = @"111";
        [vc_target.navigationController pushViewController:t_vc animated:YES];
        
    }
    
    if ([model isEqualToString:@"VehicleTiredAlarmModel"]) {
        VehicleTiredAlarmVC * t_vc = [[VehicleTiredAlarmVC alloc] init];
        t_vc.plateNo = _plateNo;
        t_vc.startTime = [ShareFun timeWithTimeInterval:self.reponse.fatigueAlarm.startTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
        t_vc.endTime = [ShareFun timeWithTimeInterval:self.reponse.fatigueAlarm.endTime dateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [vc_target.navigationController pushViewController:t_vc animated:YES];

    }
    
    if ([model isEqualToString:@"VehicleExpireAlarmModel"]) {
        VehicleExpireAlarmVC * t_vc = [[VehicleExpireAlarmVC alloc] init];
        t_vc.model = self.reponse.vehicleExpireAlarm;
        [vc_target.navigationController pushViewController:t_vc animated:YES];
    }
    
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"VehicleAlarmInfoVC dealloc");
}


@end
