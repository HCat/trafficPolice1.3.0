//
//  AccidentDetailVC.m
//  trafficPolice
//
//  Created by hcat on 2017/6/8.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AccidentDetailVC.h"

#import "UITableView+Lr_Placeholder.h"

#import "NetWorkHelper.h"

#import "AccidentAPI.h"
#import "FastAccidentAPI.h"

#import "AccidentImageCell.h"
#import "AccidentMessageCell.h"
#import "AccidentPartyCell.h"

@interface AccidentDetailVC ()

@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (nonatomic,strong) AccidentDetailModel * model;
@property(nonatomic,strong)  AccidentPartyCell * partycell;

@end

@implementation AccidentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    if (_accidentType == AccidentTypeAccident) {
        [self loadAccidentDetail];
    }else if (_accidentType == AccidentTypeFastAccident){
        [self loadAccidentFastDetail];
    }
    
    
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

#pragma mark - 数据请求部分

- (void)loadAccidentDetail{

    WS(weakSelf);
    AccidentDetailManger *manger = [[AccidentDetailManger alloc] init];
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
    FastAccidentDetailManger *manger = [[FastAccidentDetailManger alloc] init];
    manger.fastaccidentId = _accidentId;
    
    ShowHUD *hud = [ShowHUD showWhiteLoadingWithText:@"加载中..." inView:self.view config:nil];
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
    
    if (_model) {
        return 3;
    }else{
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AccidentImageCell *cell = (AccidentImageCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell heightWithimages];
    }else if (indexPath.row == 1){
        AccidentMessageCell *cell = (AccidentMessageCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell heightWithAccident];
    }else if (indexPath.row == 2){
        AccidentPartyCell *cell = (AccidentPartyCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell heightWithAccident];
    }
    return 105;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        AccidentImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentImageCellID"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"AccidentImageCell" bundle:nil] forCellReuseIdentifier:@"AccidentImageCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentImageCellID"];
        }
        
        
        if (_model) {
            NSMutableArray *t_arr = [NSMutableArray array];
            if (_model.picList && _model.picList.count > 0) {
                for (AccidentPicListModel * t_model in _model.picList) {
                    [t_arr addObject:t_model.imgUrl];
                }
                cell.arr_images = t_arr;
            }
        }
    
        return cell;
        
    }else if(indexPath.row == 1){
    
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
    
    }else if(indexPath.row == 2){
        
        if (!_partycell) {
            [tableView registerNib:[UINib nibWithNibName:@"AccidentPartyCell" bundle:nil] forCellReuseIdentifier:@"AccidentPartyCellID"];
            self.partycell = [tableView dequeueReusableCellWithIdentifier:@"AccidentPartyCellID"];
        }
        
        _partycell.accidentType = _accidentType;
        if (_model) {
            if (_model.accident ) {
                _partycell.accident = _model.accident;
                WS(weakSelf);
                _partycell.block = ^() {
                    SW(strongSelf, weakSelf);
                    [strongSelf.tb_content beginUpdates];
                    [strongSelf.tb_content endUpdates];
                    
                    [strongSelf.tb_content scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    
                };
            }
            
            _partycell.accidentVo = _model.accidentVo;
        }
        
        
        return _partycell;
        
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
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
