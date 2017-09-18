//
//  IllegalDetailVC.m
//  trafficPolice
//
//  Created by hcat on 2017/6/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalDetailVC.h"

#import "UITableView+Lr_Placeholder.h"
#import "NetWorkHelper.h"

#import "IllegalParkAPI.h"
#import "IllegalThroughAPI.h"

#import "IllegalImageCell.h"
#import "IllegalMessageCell.h"
#import "IllegalFootCell.h"


@interface IllegalDetailVC ()

@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (nonatomic,strong) IllegalParkDetailModel *model;

@end

@implementation IllegalDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_illegalType == IllegalTypePark) {
        if (_subType == ParkTypePark) {
            self.title = @"违停详情";
        }else if (_subType == ParkTypeReversePark){
            self.title = @"不按朝向详情";
        }else if (_subType == ParkTypeLockPark){
            self.title = @"违停锁车详情";
        }else{
            self.title = @"车辆录入详情";
        }
    }else if(_illegalType == IllegalTypeThrough){
        self.title = @"闯禁令详情";
    }
    
    _tb_content.isNeedPlaceholderView = YES;
    _tb_content.firstReload = YES;
    _tb_content.allowsSelection = NO;
    
    [self setNetworking];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    WS(weakSelf);
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        if (strongSelf.illegalType == IllegalTypePark) {
            [strongSelf loadIllegalParkDetail];
        }else if (strongSelf.illegalType == IllegalTypeThrough){
            [strongSelf loadIllegalThroughDetail];
        }
    };
    


}

#pragma mark - 数据请求

- (void)setNetworking{

    WS(weakSelf);
    //点击重新加载之后的处理
    [_tb_content setReloadBlock:^{
        
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        if (strongSelf.illegalType == IllegalTypePark) {
            [strongSelf loadIllegalParkDetail];
        }else if (strongSelf.illegalType == IllegalTypeThrough){
            [strongSelf loadIllegalThroughDetail];
        }
        
    }];

    if (_illegalType == IllegalTypePark) {
        [self loadIllegalParkDetail];
    }else if (_illegalType == IllegalTypeThrough){
        [self loadIllegalThroughDetail];
    }
    
}

- (void)loadIllegalParkDetail{

    WS(weakSelf);
    IllegalParkDetailManger *manger = [[IllegalParkDetailManger alloc] init];
    manger.illegalParkId = _illegalId;
    [manger configLoadingTitle:@"加载"];

    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.model = manger.illegalDetailModel;
            [strongSelf.tb_content reloadData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf,weakSelf);
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            strongSelf.model = nil;
            strongSelf.tb_content.isNetAvailable = YES;
            [strongSelf.tb_content reloadData];
        }
        
    }];

}

- (void)loadIllegalThroughDetail{

    WS(weakSelf);
    IllegalThroughDetailManger *manger = [[IllegalThroughDetailManger alloc] init];
    manger.illegalThroughId = _illegalId;
    [manger configLoadingTitle:@"加载"];
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.model = manger.illegalDetailModel;
            [strongSelf.tb_content reloadData];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf,weakSelf);
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            strongSelf.model = nil;
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
    
    if (_model) {
        
        if (_subType == ParkTypeCarInfoAdd) {
            return 2;
        }
        
        if ([_model.illegalCollect.state isEqualToNumber:@1]) {
            return 3;
        }else{
            return 2;
        }
        
    }else{
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        IllegalImageCell *cell = (IllegalImageCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell heightWithimages];
    }else if (indexPath.row == 1) {
        IllegalMessageCell *cell = (IllegalMessageCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell heightWithIllegal];
    }else if (indexPath.row == 2) {
        return 75;
    }
    
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        IllegalImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalImageCellID"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"IllegalImageCell" bundle:nil] forCellReuseIdentifier:@"IllegalImageCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalImageCellID"];
        }
        
        if (_model) {

            if (_model.picList && _model.picList.count > 0) {
                cell.arr_images = [_model.picList mutableCopy];
            }
        }
        
        return cell;
        
    }else if (indexPath.row == 1){
        
        IllegalMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalMessageCellID"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"IllegalMessageCell" bundle:nil] forCellReuseIdentifier:@"IllegalMessageCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalMessageCellID"];
        }
        
        cell.subType = _subType;
        
        if (_model) {
            
            if (_model.illegalCollect) {
                cell.illegalCollect = _model.illegalCollect;
            }
        }
       
        
        return cell;

    }else if (indexPath.row == 2){
        
        IllegalFootCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalFootCellID"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"IllegalFootCell" bundle:nil] forCellReuseIdentifier:@"IllegalFootCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalFootCellID"];
        }
        
        WS(weakSelf);
        cell.illegalUpAbnormalBlock = ^{
            
            SW(strongSelf, weakSelf);
            IllegalParkReportAbnormalManger *manger = [[IllegalParkReportAbnormalManger alloc] init];
            manger.illegalParkId = strongSelf.illegalId;
            [manger configLoadingTitle:@"上报"];
            manger.v_showHud = strongSelf.view;
            
            [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                
                if (manger.responseModel.code == CODE_SUCCESS) {
                    strongSelf.model.illegalCollect.state = @8;
                    strongSelf.model.illegalCollect.stateName  = @"异常处理中";
                    [strongSelf.tb_content reloadData];
                }
            
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                
            }];
            
       };
        
        return cell;
        
    }

    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - scrollViewDelegate
//用于滚动到顶部的时候使得tableView不能再继续下拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tb_content){
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

    LxPrintf(@"IllegalDetailVC dealloc");
    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
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
