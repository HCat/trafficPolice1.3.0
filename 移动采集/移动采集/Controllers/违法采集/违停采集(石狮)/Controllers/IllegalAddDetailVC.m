//
//  IllegalAddDetailVC.m
//  移动采集
//
//  Created by hcat-89 on 2020/2/20.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "IllegalAddDetailVC.h"

#import "IllegalImageCell.h"
#import "IllegalMessageCell.h"

#import "UITableView+Lr_Placeholder.h"
#import "NetWorkHelper.h"

#import "IllegalAddDetailViewModel.h"

@interface IllegalAddDetailVC ()

@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (nonatomic,strong) IllegalAddDetailViewModel * viewModel;
@end

@implementation IllegalAddDetailVC

- (instancetype)initWithViewModel:(IllegalAddDetailViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel];
    
    [self.viewModel.command_detail execute:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    @weakify(self);
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        @strongify(self);
        [self.viewModel.command_detail execute:nil];
    };
    
}

#pragma mark - configUI

- (void)configUI{
    self.title = @"违章详情";
    
    _tb_content.isNeedPlaceholderView = YES;
    _tb_content.firstReload = YES;
    _tb_content.allowsSelection = NO;
    @weakify(self);
    [_tb_content setReloadBlock:^{
        
        @strongify(self);
        self.tb_content.isNetAvailable = NO;
        [self.viewModel.command_detail execute:nil];
        
    }];
    
}

#pragma mark - bindViewModel

- (void)bindViewModel{
    
    @weakify(self);
    [self.viewModel.command_detail.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        if([x isEqualToString:@"加载失败"]){
            Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
            NetworkStatus status = [reach currentReachabilityStatus];
            if (status == NotReachable) {
                self.viewModel.model = nil;
                self.tb_content.isNetAvailable = YES;
                [self.tb_content reloadData];
            }
            
            
        }else{
            [self.tb_content reloadData];
        }
        
    }];

}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.viewModel.model) {
        
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
        cell.type = @2;
        if (self.viewModel.model) {

            if (self.viewModel.model.picList && self.viewModel.model.picList.count > 0) {
                NSMutableArray * m_array = @[].mutableCopy;
                [m_array addObjectsFromArray:self.viewModel.model.picList];
                [m_array addObjectsFromArray:self.viewModel.model.abnormalPic];
                
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
        
        cell.subType = ParkTypePark;
        
        if (self.viewModel.model) {
            
            if (self.viewModel.model.illegalCollect) {
                cell.illegalCollect = self.viewModel.model.illegalCollect;
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

#pragma mark -dealloc

- (void)dealloc{
    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
    LxPrintf(@"IllegalAddDetailVC dealloc");
}

@end
