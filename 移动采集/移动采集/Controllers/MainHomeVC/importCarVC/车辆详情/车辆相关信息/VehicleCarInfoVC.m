//
//  VehicleCarInfoVC.m
//  移动采集
//
//  Created by hcat on 2018/5/14.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleCarInfoVC.h"
#import "NetWorkHelper.h"
#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "VehicleAPI.h"

#import "VehicleCarNoShowCell.h"
#import "VehicleMemberNoShowCell.h"
#import "VehicleDriverNoShowCell.h"
#import "VehicleRemarkCell.h"

#import "VehicleCarInfoMoreVC.h"
#import "VehicleCarMoreVC.h"

@interface VehicleCarInfoVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *arr_content;



@end

@implementation VehicleCarInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.isNeedPlaceholderView = YES;
    _tableView.firstReload = YES;
    
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleCarNoShowCell" bundle:nil] forCellReuseIdentifier:@"VehicleCarNoShowCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleMemberNoShowCell" bundle:nil] forCellReuseIdentifier:@"VehicleMemberNoShowCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleDriverNoShowCell" bundle:nil] forCellReuseIdentifier:@"VehicleDriverNoShowCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleRemarkCell" bundle:nil] forCellReuseIdentifier:@"VehicleRemarkCellID"];
    
    WS(weakSelf);
    [_tableView setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tableView.isNetAvailable = NO;
        [strongSelf loadVehicleRequest:strongSelf.type];
    }];
    
    
    if (self.reponse) {
        [self.tableView reloadData];
    }else{
        [self loadVehicleRequest:self.type];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.tableView.isNetAvailable = NO;
        [strongSelf loadVehicleRequest:strongSelf.type];
    };
    
}

#pragma mark - set && get

- (void)setReponse:(VehicleDetailReponse *)reponse{
    
    _reponse = reponse;
    NSLog(@"%@",_reponse);
    if (_reponse) {
        
        if (_arr_content && _arr_content.count > 0) {
            [_arr_content removeAllObjects];
        }else{
            self.arr_content = [NSMutableArray array];
        }

        //添加车辆信息
        if (_reponse.vehicle) {
            _reponse.vehicle.memFormNo = _reponse.memberInfo.memFormNo;
            [self.arr_content addObject:_reponse.vehicle];
        }
        
        
        //添加驾驶员资料
        if (_reponse.driverList && _reponse.driverList.count > 0) {
            for (VehicleDriverModel *t_model in _reponse.driverList) {
                [self.arr_content addObject:t_model];
            }
            
        }
        
        //添加运输主体信息
        if (_reponse.memberInfo) {
            [self.arr_content addObject:_reponse.memberInfo];
        }
        
        //添加车辆备注信息
        if (_reponse.vehicleRemarkList && _reponse.vehicleRemarkList.count > 0) {
             for (VehicleRemarkModel *t_model in _reponse.vehicleRemarkList) {
                 [self.arr_content addObject:t_model];
             }
        }
   
    }
    
}



#pragma mark - 请求代码

- (void)loadVehicleRequest:(VehicleRequestType)type{
    
    WS(weakSelf);
    
    if (!_nummberId) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
        
        return;
    }
    
    if (type == VehicleRequestTypeQRCode) {
        
        VehicleDetailByQrCodeManger *manger = [[VehicleDetailByQrCodeManger alloc] init];
        manger.qrCode = _nummberId;
        manger.isLog = NO;
        [manger configLoadingTitle:@"加载"];
        
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf,weakSelf);
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                strongSelf.reponse = manger.vehicleDetailReponse;
                [strongSelf.tableView reloadData];
            }
            
            if ([manger.responseModel.msg isEqualToString:@"该车牌号对应车辆信息不存在"]){
                [strongSelf.tableView reloadData];
                
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf,weakSelf);
            Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
            NetworkStatus status = [reach currentReachabilityStatus];
            if (status == NotReachable) {
                if (strongSelf.arr_content.count > 0) {
                    [strongSelf.arr_content removeAllObjects];
                }
                strongSelf.tableView.isNetAvailable = YES;
                [strongSelf.tableView reloadData];
            }
            
            
        }];
        
    }else{
        
        VehicleDetailByPlateNoManger *manger = [[VehicleDetailByPlateNoManger alloc] init];
        manger.plateNo = _nummberId;
        manger.isLog = YES;
        [manger configLoadingTitle:@"加载"];
        
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            SW(strongSelf,weakSelf);
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                strongSelf.reponse = manger.vehicleDetailReponse;
                [strongSelf.tableView reloadData];
            }
            
            if ([manger.responseModel.msg isEqualToString:@"该车牌号对应车辆信息不存在"]){
                [strongSelf.tableView reloadData];
                
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf,weakSelf);
            Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
            NetworkStatus status = [reach currentReachabilityStatus];
            if (status == NotReachable) {
                if (strongSelf.arr_content.count > 0) {
                    [strongSelf.arr_content removeAllObjects];
                }
                strongSelf.tableView.isNetAvailable = YES;
                [strongSelf.tableView reloadData];
            }
            
        }];
        
    }
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    if (_arr_content) {
        count = _arr_content.count;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0;
    
    VehicleCellType t_type = [self getTypeFromArray:indexPath.row];
    
    WS(weakSelf);
    switch (t_type) {
        case VehicleCellTypeVehicleCar:{
            height = [tableView fd_heightForCellWithIdentifier:@"VehicleCarNoShowCellID" cacheByIndexPath:indexPath configuration:^(VehicleCarNoShowCell *cell) {
                SW(strongSelf, weakSelf);
                cell.vehicle = (VehicleModel *)strongSelf.arr_content[indexPath.row];
                cell.imagelists = strongSelf.reponse.vehicleImgList;
            }];
            
            LxPrintf(@"VehicleCar:::%f",height);
            
        }
            break;
        case VehicleCellTypeMember:{
            height = [tableView fd_heightForCellWithIdentifier:@"VehicleMemberNoShowCellID" cacheByIndexPath:indexPath configuration:^(VehicleMemberNoShowCell *cell) {
                SW(strongSelf, weakSelf);
                cell.memberInfo = (MemberInfoModel *)strongSelf.arr_content[indexPath.row];
            }];
            
            LxPrintf(@"VehicleMember:::%f",height);
            
        }
            break;
        case VehicleCellTypeDriver:{
            height = [tableView fd_heightForCellWithIdentifier:@"VehicleDriverNoShowCellID" cacheByIndexPath:indexPath configuration:^(VehicleDriverNoShowCell *cell) {
                SW(strongSelf, weakSelf);
                cell.driver = (VehicleDriverModel *)strongSelf.arr_content[indexPath.row];
            }];
            
            LxPrintf(@"VehicleDriver:::%f",height);
            
        }
            break;
        case VehicleCellTypeRemark:{
            height = [tableView fd_heightForCellWithIdentifier:@"VehicleRemarkCellID" cacheByIndexPath:indexPath configuration:^(VehicleRemarkCell *cell) {
                SW(strongSelf, weakSelf);
                cell.remark = (VehicleRemarkModel *)strongSelf.arr_content[indexPath.row];
            }];
         }
            break;
           
        default:
            break;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VehicleCellType t_type = [self getTypeFromArray:indexPath.row];
    WS(weakSelf);
    switch (t_type) {
        case VehicleCellTypeVehicleCar:{
            
            VehicleCarNoShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleCarNoShowCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.vehicle = (VehicleModel *)self.arr_content[indexPath.row];
            cell.imagelists = _reponse.vehicleImgList;
            cell.isReportEdit = _reponse.isReportEdit;
            cell.block = ^{
                SW(strongSelf, weakSelf);
                VehicleCarInfoMoreVC *carInfoMoreVC = [[VehicleCarInfoMoreVC alloc] init];
                carInfoMoreVC.infoType = VehicleCellTypeVehicleCar;
                carInfoMoreVC.vehicleModel = (VehicleModel *)strongSelf.arr_content[indexPath.row];
                carInfoMoreVC.reponse = strongSelf.reponse;
                VehicleCarMoreVC *vc_target = (VehicleCarMoreVC *)[ShareFun findViewController:strongSelf.view withClass:[VehicleCarMoreVC class]];
                [vc_target.navigationController pushViewController:carInfoMoreVC animated:YES];
            };
            
            cell.editBlock = ^{
                SW(strongSelf, weakSelf);
                [strongSelf.tableView reloadData];
            };
            return cell;
            
        }
            break;
        case VehicleCellTypeMember:{
            
            VehicleMemberNoShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleMemberNoShowCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.memberInfo = (MemberInfoModel *)self.arr_content[indexPath.row];
            cell.block = ^{
                SW(strongSelf, weakSelf);
                VehicleCarInfoMoreVC *carInfoMoreVC = [[VehicleCarInfoMoreVC alloc] init];
                carInfoMoreVC.infoType = VehicleCellTypeMember;
                carInfoMoreVC.memberInfoModel = (MemberInfoModel *)strongSelf.arr_content[indexPath.row];
                carInfoMoreVC.reponse = strongSelf.reponse;
                VehicleCarMoreVC *vc_target = (VehicleCarMoreVC *)[ShareFun findViewController:strongSelf.view withClass:[VehicleCarMoreVC class]];
                [vc_target.navigationController pushViewController:carInfoMoreVC animated:YES];
            };
            
            return cell;
            
            
        }
            break;
        case VehicleCellTypeDriver:{
            VehicleDriverNoShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleDriverNoShowCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.driver = (VehicleDriverModel *)self.arr_content[indexPath.row];
            cell.block = ^{
                SW(strongSelf, weakSelf);
                VehicleCarInfoMoreVC *carInfoMoreVC = [[VehicleCarInfoMoreVC alloc] init];
                carInfoMoreVC.infoType = VehicleCellTypeDriver;
                carInfoMoreVC.vehicleDriverModel = (VehicleDriverModel *)strongSelf.arr_content[indexPath.row];
                carInfoMoreVC.reponse = strongSelf.reponse;
                VehicleCarMoreVC *vc_target = (VehicleCarMoreVC *)[ShareFun findViewController:strongSelf.view withClass:[VehicleCarMoreVC class]];
                [vc_target.navigationController pushViewController:carInfoMoreVC animated:YES];
            };
            return cell;
            
        }
            break;
        case VehicleCellTypeRemark:{
            VehicleRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleRemarkCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.remark = (VehicleRemarkModel *)self.arr_content[indexPath.row];
            return cell;
        }
            break;
          
        default:
            break;
    }
    
    
    return nil;
    
}


- (VehicleCellType)getTypeFromArray:(NSInteger )row{
    
    if (_arr_content && _arr_content.count > 0) {
        id obj = _arr_content[row];
        if ([obj isKindOfClass:[VehicleModel class]]) {
            return VehicleCellTypeVehicleCar;
        }else if ([obj isKindOfClass:[MemberInfoModel class]]){
            return VehicleCellTypeMember;
        }else if ([obj isKindOfClass:[VehicleDriverModel class]]){
            return VehicleCellTypeDriver;
        }else if ([obj isKindOfClass:[VehicleRouteModel class]]){
            return VehicleCellTypeRoute;
        }else {
            return VehicleCellTypeRemark;
            
        }
    }else{
        return -1;
        
    }
    
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
    LxPrintf(@"VehicleCarInfoVC dealloc");
    
    
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
