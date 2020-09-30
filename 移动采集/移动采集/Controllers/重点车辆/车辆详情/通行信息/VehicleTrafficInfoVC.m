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

@interface VehicleTrafficInfoVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <VehicleRouteDetailModel *> * arr_model;

@end

@implementation VehicleTrafficInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arr_model = @[].mutableCopy;
    
    _tableView.isNeedPlaceholderView = YES;
    _tableView.firstReload = YES;
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleTrafficTopCell" bundle:nil] forCellReuseIdentifier:@"VehicleTrafficTopCellID"];
    
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
            [strongSelf.arr_model addObjectsFromArray:manger.list];
            [strongSelf.tableView reloadData];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf,weakSelf);
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            if (strongSelf.arr_model.count > 0) {
                [strongSelf.arr_model removeAllObjects];
            }
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

    return _arr_model.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf);
    
    if (_arr_model.count > 0) {
        return [tableView fd_heightForCellWithIdentifier:@"VehicleTrafficTopCellID" cacheByIndexPath:indexPath configuration:^(VehicleTrafficTopCell *cell) {
            SW(strongSelf, weakSelf);
            if (strongSelf.arr_model.count > 0) {
                cell.model = strongSelf.arr_model[indexPath.row];
            }
            
        }];
       
 
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_arr_model.count > 0) {
        VehicleTrafficTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleTrafficTopCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.fd_enforceFrameLayout = NO;
        cell.model = _arr_model[indexPath.row];;
        return cell;
        
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
