//
//  VehicleUpCarDetailVC.m
//  移动采集
//
//  Created by hcat on 2018/5/29.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleUpCarDetailVC.h"
#import "VehicleAPI.h"
#import "VehicleUpInfoDetailCell.h"
#import "VehicleUpImageDetailCell.h"
#import "VehicleUpRemarkDetailCell.h"

#import "NetWorkHelper.h"
#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface VehicleUpCarDetailVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) VehicleUpDetailModel * model;

@end

@implementation VehicleUpCarDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上报详情";
    
    _tableView.isNeedPlaceholderView = YES;
    _tableView.firstReload = YES;
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleUpInfoDetailCell" bundle:nil] forCellReuseIdentifier:@"VehicleUpInfoDetailCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleUpImageDetailCell" bundle:nil] forCellReuseIdentifier:@"VehicleUpImageDetailCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleUpRemarkDetailCell" bundle:nil] forCellReuseIdentifier:@"VehicleUpRemarkDetailCellID"];
    
    
    [self requestVehicleDetail];
    
    WS(weakSelf);
    //点击重新加载之后的处理
    [_tableView setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tableView.isNetAvailable = NO;
        [strongSelf requestVehicleDetail];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.tableView.isNetAvailable = NO;
        [strongSelf requestVehicleDetail];
    };
    
}

#pragma mark - 请求数据

- (void)requestVehicleDetail{
    WS(weakSelf);
    VehicleUpCarDetailManger *manger = [[VehicleUpCarDetailManger alloc] init];
    manger.vehicleUpId = _vehicleId;
    [manger configLoadingTitle:@"请求"];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.model = manger.detailReponse;
            [strongSelf.tableView reloadData];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf,weakSelf);
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            strongSelf.model = nil;
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
    NSInteger row = 0;
    if (_model) {
        row += 1;
        if (_model.imgList.count > 0 && _model.imgList) {
            row += 1;
        }
        
        if (_model.remark.length > 0 && _model.remark) {
            row += 1;
        }
    }
    
    return row;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf);
    
    if (_model) {
        
        if (indexPath.row == 0) {
            return [tableView fd_heightForCellWithIdentifier:@"VehicleUpInfoDetailCellID" cacheByIndexPath:indexPath configuration:^(VehicleUpInfoDetailCell *cell) {
                SW(strongSelf, weakSelf);
                cell.model = strongSelf.model;
            }];
            
        }else if (indexPath.row == 1){
            if (_model.imgList.count > 0 && _model.imgList) {
                return [tableView fd_heightForCellWithIdentifier:@"VehicleUpImageDetailCellID" cacheByIndexPath:indexPath configuration:^(VehicleUpImageDetailCell *cell) {
                    SW(strongSelf, weakSelf);
                    cell.model = strongSelf.model;
                }];
            }else if (_model.remark.length > 0 && _model.remark) {
                return [tableView fd_heightForCellWithIdentifier:@"VehicleUpRemarkDetailCellID" cacheByIndexPath:indexPath configuration:^(VehicleUpRemarkDetailCell *cell) {
                    SW(strongSelf, weakSelf);
                    cell.model = strongSelf.model;
                }];
            }
            
        }else if (indexPath.row == 2){
            if (_model.remark.length > 0 && _model.remark) {
                return [tableView fd_heightForCellWithIdentifier:@"VehicleUpRemarkDetailCellID" cacheByIndexPath:indexPath configuration:^(VehicleUpRemarkDetailCell *cell) {
                    SW(strongSelf, weakSelf);
                    cell.model = strongSelf.model;
                }];
            }
            
        }

    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_model) {
        if (indexPath.row == 0) {
            
            VehicleUpInfoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleUpInfoDetailCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.fd_enforceFrameLayout = NO;
            cell.model = _model;
            return cell;
            
        }else if (indexPath.row == 1){
            
            if (_model.imgList.count > 0 && _model.imgList) {
                VehicleUpImageDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleUpImageDetailCellID"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.fd_enforceFrameLayout = NO;
                cell.model = _model;
                return cell;
            }else if (_model.remark.length > 0 && _model.remark) {
                VehicleUpRemarkDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleUpRemarkDetailCellID"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.fd_enforceFrameLayout = NO;
                cell.model = _model;
                return cell;
            }
            
        }else if (indexPath.row == 2){
            
            if (_model.remark.length > 0 && _model.remark) {
                VehicleUpRemarkDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleUpRemarkDetailCellID"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.fd_enforceFrameLayout = NO;
                cell.model = _model;
                return cell;
            }
            
        }
        
    }
    
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - scrollViewDelegate
//用于滚动到顶部的时候使得tableView不能再继续下拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _tableView){
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
    LxPrintf(@"VehicleUpCarDetailVC dealloc");
    
}


@end
