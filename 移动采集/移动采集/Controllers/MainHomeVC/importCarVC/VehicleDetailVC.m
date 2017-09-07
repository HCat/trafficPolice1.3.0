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

#import "VehicleCarCell.h"
#import "VehicleAPI.h"

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

@end

@implementation VehicleDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重点车辆";
    
    self.arr_content = [NSMutableArray array];
    _tableView.isNeedPlaceholderView = YES;
    _tableView.firstReload = YES;
    
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleCarCell" bundle:nil] forCellReuseIdentifier:@"VehicleCarCellID"];
    _tableView.fd_debugLogEnabled = YES;
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
    LxDBObjectAsJson(_reponse);
    if (_reponse) {
        
        if (_arr_content && _arr_content.count > 0) {
            [_arr_content removeAllObjects];
        }
        
        //添加车辆信息
        if (_reponse.vehicle) {
            [self.arr_content addObject:_reponse.vehicle];
        }
        
//        //添加运输主体信息
//        if (_reponse.memberInfo) {
//            [self.arr_content addObject:_reponse.memberInfo];
//        }
//        
//        //添加驾驶员资料
//        if (_reponse.driverList && _reponse.driverList.count > 0) {
//            for (VehicleDriverModel *t_model in _reponse.driverList) {
//                [self.arr_content addObject:t_model];
//            }
//        
//        }
//        
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
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                
                
                
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
            height = [tableView fd_heightForCellWithIdentifier:@"VehicleCarCellID" cacheByIndexPath:indexPath configuration:^(VehicleCarCell *cell) {
                SW(strongSelf, weakSelf);
                cell.vehicle = (VehicleModel *)strongSelf.arr_content[indexPath.row];
                
            }];
            break;
        }
        default:
            break;
    }
    
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VehicleCellType t_type = [self getTypeFromArray:indexPath.row];

    switch (t_type) {
        case VehicleCellTypeVehicleCar:{
            
            VehicleCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleCarCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.vehicle = (VehicleModel *)self.arr_content[indexPath.row];
            
            return cell;
            
            break;
        }
        default:
            break;
    }
    

    return nil;
    
}


- (VehicleCellType)getTypeFromArray:(NSInteger )row{

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
