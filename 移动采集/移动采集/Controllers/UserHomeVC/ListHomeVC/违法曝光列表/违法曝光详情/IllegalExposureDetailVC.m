//
//  IllegalExposureDetailVC.m
//  移动采集
//
//  Created by hcat on 2019/12/6.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "IllegalExposureDetailVC.h"
#import "UITableView+Lr_Placeholder.h"
#import "NetWorkHelper.h"
#import "IllegalImageCell.h"
#import "IllegalMessageCell.h"

@interface IllegalExposureDetailVC ()

@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (nonatomic,strong) ExposureCollectDetailModel * model;

@end

@implementation IllegalExposureDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"违法曝光详情";
    
    _tb_content.isNeedPlaceholderView = YES;
    _tb_content.firstReload = YES;
    _tb_content.allowsSelection = NO;
       
    WS(weakSelf);
    //点击重新加载之后的处理
    [_tb_content setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        [strongSelf loadIllegalExposureDetail];
           
     }];
    [self loadIllegalExposureDetail];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    WS(weakSelf);
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
            SW(strongSelf, weakSelf);
            strongSelf.tb_content.isNetAvailable = NO;
            [strongSelf loadIllegalExposureDetail];
    };
   
}


- (void)loadIllegalExposureDetail{

    WS(weakSelf);
    ExposureCollectDetailManger *manger = [[ExposureCollectDetailManger alloc] init];
    manger.exposureCollectId = _exposureCollectId;
    [manger configLoadingTitle:@"加载"];

    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.model = manger.exposureCollectDetailModel;
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
        
        return 2;
        
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
        
        cell.type = @1;
        if (_model) {

            if (_model.pictureList && _model.pictureList.count > 0) {
                NSMutableArray * m_array = @[].mutableCopy;
                [m_array addObjectsFromArray:_model.pictureList];
                cell.arr_images = m_array;
            }
        }
        
        return cell;
        
    }else if (indexPath.row == 1){
        
        IllegalMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalMessageCellID"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"IllegalMessageCell" bundle:nil] forCellReuseIdentifier:@"IllegalMessageCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalMessageCellID"];
        }
    
        if (_model) {
            
            if (_model.collect) {
                cell.exposureCollectModel = _model.collect;
            }
        }
       
        
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

#pragma mark - dealloc

- (void)dealloc{
    LxPrintf(@"IllegalExposureDetailVC dealloc");
    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
}

@end
