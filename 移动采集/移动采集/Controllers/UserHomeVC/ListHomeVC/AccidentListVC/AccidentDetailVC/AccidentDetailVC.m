//
//  AccidentDetailVC.m
//  trafficPolice
//
//  Created by hcat on 2017/6/8.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AccidentDetailVC.h"

#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "NetWorkHelper.h"

#import "AccidentAPI.h"
#import "FastAccidentAPI.h"

#import "AccidentRemarkCell.h"
#import "AccidentImageCell.h"
#import "AccidentMessageCell.h"
#import "AccidentPartyCell.h"
#import "AccidentRemarkListVC.h"


@interface AccidentDetailVC ()

@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (nonatomic,strong,readwrite) AccidentDetailsModel * model;
@property(nonatomic,strong)  AccidentPartyCell * partycell;

@end

@implementation AccidentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.cacheModel) {
    self.view.backgroundColor = [UIColor clearColor];
    }
    
    if (_accidentType == AccidentTypeAccident) {
        self.title = @"事故详情";
    }else if(_accidentType == AccidentTypeFastAccident){
        self.title = @"快处事故详情";
    }

    _tb_content.isNeedPlaceholderView = YES;
    _tb_content.firstReload = YES;
    //隐藏多余行的分割线
    _tb_content.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tb_content setSeparatorInset:UIEdgeInsetsZero];
    [_tb_content setLayoutMargins:UIEdgeInsetsZero];
    _tb_content.allowsSelection = NO;
    
    [_tb_content registerNib:[UINib nibWithNibName:@"AccidentRemarkCell" bundle:nil] forCellReuseIdentifier:@"AccidentRemarkCellID"];
    
    
    if (self.cacheModel) {
        self.model = self.cacheModel;
        [_tb_content reloadData];
    }else{
        if (_accidentType == AccidentTypeAccident) {
            [self loadAccidentDetail];
        }else if (_accidentType == AccidentTypeFastAccident){
            [self loadAccidentFastDetail];
        }
        
        WS(weakSelf);
        //点击重新加载之后的处理
        [_tb_content setReloadBlock:^{
            SW(strongSelf, weakSelf);
            strongSelf.tb_content.isNetAvailable = NO;
            if (strongSelf.accidentType == AccidentTypeAccident) {
                [strongSelf loadAccidentDetail];
            }else if (strongSelf.accidentType == AccidentTypeFastAccident){
                [strongSelf loadAccidentFastDetail];
            }
            
        }];
        
    }
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!self.cacheModel) {
        WS(weakSelf);
        [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
            
            SW(strongSelf, weakSelf);
            strongSelf.tb_content.isNetAvailable = NO;
            if (strongSelf.accidentType == AccidentTypeAccident) {
                [strongSelf loadAccidentDetail];
            }else if (strongSelf.accidentType == AccidentTypeFastAccident){
                [strongSelf loadAccidentFastDetail];
            }
            
        };
    }
    
}

#pragma mark - set && get 

- (void)setRemarkModel:(RemarkModel *)remarkModel{

    _remarkModel = remarkModel;
    
    if (_remarkModel) {

        [_tb_content reloadData];
    
    }

}

- (void)setRemarkCount:(NSInteger)remarkCount{

    _remarkCount = remarkCount;
    [_tb_content reloadData];
    
}


#pragma mark - 数据请求部分

- (void)loadAccidentDetail{

    WS(weakSelf);
    AccidentDetailsManger *manger = [[AccidentDetailsManger alloc] init];
    manger.accidentId = _accidentId;
    
    LRShowHUD *hud = [LRShowHUD showWhiteLoadingWithText:@"加载中..." inView:self.view config:nil];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.model = manger.accidentDetailModel;
            [strongSelf.tb_content reloadData];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
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

- (void)loadAccidentFastDetail{

    WS(weakSelf);
    FastAccidentDetailsManger *manger = [[FastAccidentDetailsManger alloc] init];
    manger.fastaccidentId = _accidentId;
    
    LRShowHUD *hud = [LRShowHUD showWhiteLoadingWithText:@"加载中..." inView:self.view config:nil];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.model = manger.fastAccidentDetailModel;
            [strongSelf.tb_content reloadData];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
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
    
    NSInteger count = 0;
    if (_remarkModel) {
        count += 1;
    }
    if (_model) {
        count += 3;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_remarkModel) {
        
        if (indexPath.row == 0) {
            WS(weakSelf);
            return [tableView fd_heightForCellWithIdentifier:@"AccidentRemarkCellID" cacheByIndexPath:indexPath configuration:^(AccidentRemarkCell *cell) {
                SW(strongSelf, weakSelf);
                cell.remarkModel = strongSelf.remarkModel;
                
            }];
            
        }
    }
    
    if (indexPath.row == (_remarkModel ? 1:0)) {
        AccidentImageCell *cell = (AccidentImageCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell heightWithimages];
    }else if (indexPath.row == (_remarkModel ? 2:1)){
        AccidentMessageCell *cell = (AccidentMessageCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell heightWithAccident];
    }else if (indexPath.row == (_remarkModel ? 3:2)){
        AccidentPartyCell *cell = (AccidentPartyCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell heightWithAccident];
    }
    
    return 105;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_remarkModel) {
        
        if (indexPath.row == 0) {
            
            AccidentRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentRemarkCellID"];
    
            cell.remarkModel = _remarkModel;
            cell.remarkCount = _remarkCount;
            return cell;
           
        }
        
    }
    if (indexPath.row == (_remarkModel ? 1:0)) {
        AccidentImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentImageCellID"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"AccidentImageCell" bundle:nil] forCellReuseIdentifier:@"AccidentImageCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentImageCellID"];
        }
        
        
        if (_model) {
            
            cell.arr_images = _model.picList.mutableCopy;

        }else{
            cell.arr_images = nil;
        }
    
        return cell;
        
    }else if(indexPath.row == (_remarkModel ? 2:1)){
    
        AccidentMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentMessageCellID"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"AccidentMessageCell" bundle:nil] forCellReuseIdentifier:@"AccidentMessageCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentMessageCellID"];
        }
        
        if (_model) {
            if (_model.accident ) {
                cell.accident = _model.accident;
            }
        }
        
        return cell;
    
    }else if(indexPath.row == (_remarkModel ? 3:2)){
        
        if (!_partycell) {
            [tableView registerNib:[UINib nibWithNibName:@"AccidentPartyCell" bundle:nil] forCellReuseIdentifier:@"AccidentPartyCellID"];
            self.partycell = [tableView dequeueReusableCellWithIdentifier:@"AccidentPartyCellID"];
        }
        
        _partycell.accidentType = _accidentType;
        if (_model) {
            if (_model.accidentList) {
                _partycell.list = _model.accidentList;
                WS(weakSelf);
                _partycell.block = ^() {
                    SW(strongSelf, weakSelf);
                    [strongSelf.tb_content beginUpdates];
                    [strongSelf.tb_content endUpdates];
                    [strongSelf.tb_content scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                };
            }
            
        }
        
        return _partycell;
        
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == (_remarkModel ? 3:2)) {
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0, ScreenWidth, 0, 0)];
        
    }else{
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [cell setLayoutMargins:UIEdgeInsetsZero];
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

    LxPrintf(@"AccidentDetailVC dealloc");
    
}

@end
