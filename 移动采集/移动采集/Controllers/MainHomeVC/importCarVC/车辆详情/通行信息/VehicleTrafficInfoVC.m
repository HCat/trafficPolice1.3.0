//
//  VehicleTrafficInfoVC.m
//  移动采集
//
//  Created by hcat on 2018/5/14.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleTrafficInfoVC.h"
#import "VehicleAPI.h"

#import "NetWorkHelper.h"
#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "VehicleTrafficTopCell.h"
#import "VehicleTrafficPlaceCell.h"

@interface VehicleTrafficInfoVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) VehicleRouteDetailModel * model;

@end

@implementation VehicleTrafficInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.isNeedPlaceholderView = YES;
    _tableView.firstReload = YES;
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleTrafficTopCell" bundle:nil] forCellReuseIdentifier:@"VehicleTrafficTopCellID"];
     [_tableView registerNib:[UINib nibWithNibName:@"VehicleTrafficPlaceCell" bundle:nil] forCellReuseIdentifier:@"VehicleTrafficPlaceCellID"];
    
    [self requestTrafficInfo];
    
    WS(weakSelf);
    //点击重新加载之后的处理
    [_tableView setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tableView.isNetAvailable = NO;
        [strongSelf requestTrafficInfo];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.tableView.isNetAvailable = NO;
        [strongSelf requestTrafficInfo];
    };
    
}

#pragma mark - 请求通行信息
- (void)requestTrafficInfo{
    WS(weakSelf);
    VehicleGetRouteApprovalManger * manger = [[VehicleGetRouteApprovalManger alloc] init];
    manger.vehicleId = _vehicleId;
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
        if (_model.routeDetentionList.count > 0 && _model.routeDetentionList) {
            row += 1;
        }
    }
    
    return row;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf);
    
    if (_model) {
        
        if (indexPath.row == 0) {
            return [tableView fd_heightForCellWithIdentifier:@"VehicleTrafficTopCellID" cacheByIndexPath:indexPath configuration:^(VehicleTrafficTopCell *cell) {
                SW(strongSelf, weakSelf);
                cell.model = strongSelf.model;
            }];
            
        }else if (indexPath.row == 1){
            
            return [tableView fd_heightForCellWithIdentifier:@"VehicleTrafficPlaceCellID" cacheByIndexPath:indexPath configuration:^(VehicleTrafficPlaceCell *cell) {
                SW(strongSelf, weakSelf);
                cell.model = strongSelf.model;
            }];
        }
 
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_model) {
        if (indexPath.row == 0) {
            
            VehicleTrafficTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleTrafficTopCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.fd_enforceFrameLayout = NO;
            cell.model = _model;
            return cell;
            
        }else if (indexPath.row == 1){
            
            VehicleTrafficTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleTrafficPlaceCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.fd_enforceFrameLayout = NO;
            cell.model = _model;
            return cell;
            
        }
        
    }
    
    
    return nil;
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"VehicleTrafficInfoVC dealloc");
    
}

@end
