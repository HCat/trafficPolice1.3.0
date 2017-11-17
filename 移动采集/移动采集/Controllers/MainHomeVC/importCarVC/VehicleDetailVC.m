//
//  VehicleDetailVC.m
//  移动采集
//
//  Created by hcat on 2017/9/7.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "VehicleDetailVC.h"


#import "NetWorkHelper.h"
#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "VehicleAPI.h"

#import "VehicleCarCell.h"
#import "VehicleCarNoShowCell.h"
#import "VehicleMemberCell.h"
#import "VehicleMemberNoShowCell.h"
#import "VehicleDriverCell.h"
#import "VehicleDriverNoShowCell.h"
#import "VehicleRemarkCell.h"


typedef NS_ENUM(NSUInteger, VehicleCellType) {
    VehicleCellTypeVehicleCar,  //车辆信息
    VehicleCellTypeMember,      //运输主体
    VehicleCellTypeDriver,      //驾驶员信息
    VehicleCellTypeRemark,      //备注信息
    
};


@interface VehicleDetailVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *arr_content;
@property (nonatomic,strong) VehicleDetailReponse *reponse;

@property (nonatomic,assign) BOOL isShowVehicleCar;
@property (nonatomic,assign) BOOL isShowVehicleMember;
@property (nonatomic,assign) BOOL isShowVehicleDriver;

@end

@implementation VehicleDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重点车辆";
    
    self.arr_content = [NSMutableArray array];
    _tableView.isNeedPlaceholderView = YES;
    _tableView.firstReload = YES;
    
    self.isShowVehicleCar = NO;
    self.isShowVehicleMember = NO;
    self.isShowVehicleDriver = NO;
    
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleCarCell" bundle:nil] forCellReuseIdentifier:@"VehicleCarCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleCarNoShowCell" bundle:nil] forCellReuseIdentifier:@"VehicleCarNoShowCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleMemberCell" bundle:nil] forCellReuseIdentifier:@"VehicleMemberCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleMemberNoShowCell" bundle:nil] forCellReuseIdentifier:@"VehicleMemberNoShowCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleDriverCell" bundle:nil] forCellReuseIdentifier:@"VehicleDriverCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleDriverNoShowCell" bundle:nil] forCellReuseIdentifier:@"VehicleDriverNoShowCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleRemarkCell" bundle:nil] forCellReuseIdentifier:@"VehicleRemarkCellID"];
    
    WS(weakSelf);
    [_tableView setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tableView.isNetAvailable = NO;
        [strongSelf loadVehicleRequest:strongSelf.type];
    }];
    
    [self loadVehicleRequest:self.type];
    
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
        
//        //添加车辆备注信息
//        if (_reponse.vehicleRemarkList && _reponse.vehicleRemarkList.count > 0) {
//            for (VehicleRemarkModel *t_model in _reponse.vehicleRemarkList) {
//                [self.arr_content addObject:t_model];
//            }
//
//        }
        
        
    }

}

#pragma mark - 请求代码

- (void)loadVehicleRequest:(VehicleRequestType)type{

    WS(weakSelf);
    
    if (!_NummberId) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
        
        return;
    }
    
    if (type == VehicleRequestTypeQRCode) {
        VehicleDetailByQrCodeManger *manger = [[VehicleDetailByQrCodeManger alloc] init];
        manger.qrCode = _NummberId;
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
        manger.plateNo = _NummberId;
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
            if (_isShowVehicleCar) {
                height = [tableView fd_heightForCellWithIdentifier:@"VehicleCarCellID" cacheByIndexPath:indexPath configuration:^(VehicleCarCell *cell) {
                    SW(strongSelf, weakSelf);
                    cell.vehicle = (VehicleModel *)strongSelf.arr_content[indexPath.row];
                    cell.imagelists = [strongSelf.reponse.vehicleImgList copy];
                   
                    
                }];
            }else{
                height = [tableView fd_heightForCellWithIdentifier:@"VehicleCarNoShowCellID" cacheByIndexPath:indexPath configuration:^(VehicleCarNoShowCell *cell) {
                    SW(strongSelf, weakSelf);
                    cell.vehicle = (VehicleModel *)strongSelf.arr_content[indexPath.row];
                   
                }];
            
            }
        
        }
        break;
        case VehicleCellTypeMember:{
            if (_isShowVehicleMember) {
                height = [tableView fd_heightForCellWithIdentifier:@"VehicleMemberCellID" cacheByIndexPath:indexPath configuration:^(VehicleMemberCell *cell) {
                    SW(strongSelf, weakSelf);
                    cell.memberInfo = (MemberInfoModel *)strongSelf.arr_content[indexPath.row];
                    cell.memberArea = strongSelf.reponse.memberArea;
                    cell.imagelists = [strongSelf.reponse.memberImgList copy];
                    
                    
                }];
            }else{
                height = [tableView fd_heightForCellWithIdentifier:@"VehicleMemberNoShowCellID" cacheByIndexPath:indexPath configuration:^(VehicleMemberNoShowCell *cell) {
                    SW(strongSelf, weakSelf);
                    cell.memberInfo = (MemberInfoModel *)strongSelf.arr_content[indexPath.row];
                
                }];
                
            }
        
        }
        break;
        case VehicleCellTypeDriver:{
            if (_isShowVehicleDriver) {
                height = [tableView fd_heightForCellWithIdentifier:@"VehicleDriverCellID" cacheByIndexPath:indexPath configuration:^(VehicleDriverCell *cell) {
                    SW(strongSelf, weakSelf);
                    cell.driver = (VehicleDriverModel *)strongSelf.arr_content[indexPath.row];
                }];
            }else{
                height = [tableView fd_heightForCellWithIdentifier:@"VehicleDriverNoShowCellID" cacheByIndexPath:indexPath configuration:^(VehicleDriverNoShowCell *cell) {
                    SW(strongSelf, weakSelf);
                    cell.driver = (VehicleDriverModel *)strongSelf.arr_content[indexPath.row];
                    
                    
                }];
                
            }
            
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
    
    LxPrintf(@"height:%lf",height);
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VehicleCellType t_type = [self getTypeFromArray:indexPath.row];

    switch (t_type) {
        case VehicleCellTypeVehicleCar:{
            
            if (_isShowVehicleCar) {
            
                
                VehicleCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleCarCellID"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.vehicle = (VehicleModel *)self.arr_content[indexPath.row];
                WS(weakSelf);
                cell.imagelists = [_reponse.vehicleImgList copy];
               
                cell.block = ^{
                    SW(strongSelf, weakSelf);
                    strongSelf.isShowVehicleCar = NO;
                    [strongSelf.tableView reloadData];
                    
                };
                
                return cell;
            }else{
            
                VehicleCarNoShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleCarNoShowCellID"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.vehicle = (VehicleModel *)self.arr_content[indexPath.row];
                WS(weakSelf);
                cell.block = ^{
                    SW(strongSelf, weakSelf);
                    strongSelf.isShowVehicleCar = YES;
                    [strongSelf.tableView reloadData];
                    
                };
                 return cell;
            }
            
        }
        break;
        case VehicleCellTypeMember:{
            
            if (_isShowVehicleMember) {
                
                VehicleMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleMemberCellID"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.memberInfo = (MemberInfoModel *)self.arr_content[indexPath.row];
                cell.memberArea = _reponse.memberArea;
                WS(weakSelf);
                cell.imagelists = [_reponse.memberImgList copy];
                
                cell.block = ^{
                    SW(strongSelf, weakSelf);
                    strongSelf.isShowVehicleMember = NO;
                    [strongSelf.tableView reloadData];
                    
                };
                
                return cell;
            }else{
                
                VehicleMemberNoShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleMemberNoShowCellID"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.memberInfo = (MemberInfoModel *)self.arr_content[indexPath.row];
                WS(weakSelf);
                cell.block = ^{
                    SW(strongSelf, weakSelf);
                    strongSelf.isShowVehicleMember = YES;
                    [strongSelf.tableView reloadData];
                    
                };
                return cell;
            }
            
            
        }
        break;
        case VehicleCellTypeDriver:{
            if (_isShowVehicleDriver) {
                VehicleDriverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleDriverCellID"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.driver = (VehicleDriverModel *)self.arr_content[indexPath.row];
                WS(weakSelf);
                cell.block = ^{
                    SW(strongSelf, weakSelf);
                    strongSelf.isShowVehicleDriver = NO;
                    [strongSelf.tableView reloadData];
                    
                };
                
                return cell;
            }else{
                VehicleDriverNoShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleDriverNoShowCellID"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.driver = (VehicleDriverModel *)self.arr_content[indexPath.row];
                WS(weakSelf);
                cell.block = ^{
                    SW(strongSelf, weakSelf);
                    strongSelf.isShowVehicleDriver = YES;
                    [strongSelf.tableView reloadData];
                    
                };

                return cell;
            }
            
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
        }else{
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
    LxPrintf(@"VehicleDetailVC dealloc");

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
