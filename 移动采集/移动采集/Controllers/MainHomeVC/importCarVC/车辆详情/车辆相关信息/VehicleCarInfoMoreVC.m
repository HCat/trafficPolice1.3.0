//
//  VehicleCarInfoMoreVC.m
//  移动采集
//
//  Created by hcat on 2018/5/15.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleCarInfoMoreVC.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "VehicleCarCell.h"
#import "VehicleMemberCell.h"
#import "VehicleDriverCell.h"


@interface VehicleCarInfoMoreVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation VehicleCarInfoMoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (_infoType) {
        case VehicleCellTypeVehicleCar:
            self.title = @"车辆信息";
            break;
        case VehicleCellTypeMember:
            self.title = @"运输主体资料";
            break;
        case VehicleCellTypeDriver:
            self.title = @"驾驶员信息";
            break;
            
        default:
            break;
    }
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleCarCell" bundle:nil] forCellReuseIdentifier:@"VehicleCarCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleMemberCell" bundle:nil] forCellReuseIdentifier:@"VehicleMemberCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleDriverCell" bundle:nil] forCellReuseIdentifier:@"VehicleDriverCellID"];

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

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0;
    
    WS(weakSelf);
    switch (_infoType) {
        case VehicleCellTypeVehicleCar:{
            height = [tableView fd_heightForCellWithIdentifier:@"VehicleCarCellID" cacheByIndexPath:indexPath configuration:^(VehicleCarCell *cell) {
                SW(strongSelf, weakSelf);
                cell.vehicle = (VehicleModel *)strongSelf.vehicleModel;
                cell.imagelists = strongSelf.reponse.vehicleImgList;
                
            }];
 
        }
            break;
        case VehicleCellTypeMember:{
            height = [tableView fd_heightForCellWithIdentifier:@"VehicleMemberCellID" cacheByIndexPath:indexPath configuration:^(VehicleMemberCell *cell) {
                SW(strongSelf, weakSelf);
                cell.memberInfo = (MemberInfoModel *)strongSelf.memberInfoModel;
                cell.memberArea = strongSelf.reponse.memberArea;
                cell.imagelists = strongSelf.reponse.memberImgList;
                
            }];
            
        }
            break;
        case VehicleCellTypeDriver:{
            height = [tableView fd_heightForCellWithIdentifier:@"VehicleDriverCellID" cacheByIndexPath:indexPath configuration:^(VehicleDriverCell *cell) {
                SW(strongSelf, weakSelf);
                cell.driver = (VehicleDriverModel *)strongSelf.vehicleDriverModel;
            }];
            
        }
            break;
        default:
            break;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (_infoType) {
        case VehicleCellTypeVehicleCar:{
            
            VehicleCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleCarCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.vehicle = self.vehicleModel;
            WS(weakSelf);
            cell.imagelists = _reponse.vehicleImgList;
            cell.isReportEdit = _reponse.isReportEdit;
            cell.editBlock = ^{
                SW(strongSelf, weakSelf);
                [strongSelf.tableView reloadData];
            };
            
            return cell;
            
        }
            break;
        case VehicleCellTypeMember:{
            
            VehicleMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleMemberCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.memberInfo = self.memberInfoModel;
            cell.memberArea = _reponse.memberArea;
            cell.imagelists = _reponse.memberImgList;

            return cell;
            
            
        }
            break;
        case VehicleCellTypeDriver:{
            VehicleDriverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleDriverCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.driver = self.vehicleDriverModel;

            return cell;
            
        }
            break;
        default:
            break;
    }
    
    
    return nil;
    
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    LxPrintf(@"VehicleCarInfoMoreVC dealloc");
    
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
