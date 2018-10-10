//
//  IllegalParkUpListVC.m
//  移动采集
//
//  Created by hcat on 2018/9/25.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalParkUpListVC.h"
#import "LRPlaceholderView.h"
#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "IllegalParkUpListCell.h"


@interface IllegalParkUpListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) IllegalParkUpListViewModel * viewModel;


@end

@implementation IllegalParkUpListVC

- (instancetype)initWithViewModel:(IllegalParkUpListViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
        
        @weakify(self);
        [self.viewModel.racSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self.tableView reloadData];
        }];
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.isNeedPlaceholderView = YES;
    _tableView.firstReload = NO;
    LRPlaceholderView *placeholderView = [[LRPlaceholderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-35)];
    placeholderView.img_dataNull = [UIImage imageNamed:@"icon_tablePlaceholder_null2"];
    placeholderView.isNetvailable = NO;
    placeholderView.str_placeholder = @"暂无数据";
    _tableView.placeholderView = placeholderView;
    
    [_tableView registerNib:[UINib nibWithNibName:@"IllegalParkUpListCell" bundle:nil] forCellReuseIdentifier:@"IllegalParkUpListCellID"];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _viewModel.arr_viewModel.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf);
    return [tableView fd_heightForCellWithIdentifier:@"IllegalParkUpListCellID" cacheByIndexPath:indexPath configuration:^(IllegalParkUpListCell *cell) {
        SW(strongSelf, weakSelf);
        IllegalUpListCellViewModel * model = strongSelf.viewModel.arr_viewModel[indexPath.row];
        cell.viewModel = model;
        
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IllegalParkUpListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalParkUpListCellID"];
    IllegalUpListCellViewModel * model = _viewModel.arr_viewModel[indexPath.row];
    cell.delegate = self;
    cell.viewModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - LYSideslipCellDelegate
- (NSArray<LYSideslipCellAction *> *)sideslipCell:(LYSideslipCell *)sideslipCell editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    LYSideslipCellAction *action = [LYSideslipCellAction rowActionWithStyle:LYSideslipCellActionStyleNormal title:@"标为异常" handler:^(LYSideslipCellAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @strongify(self);
        IllegalDBModel * dbModel = self.viewModel.arr_illegal[indexPath.row];
        dbModel.isAbnormal = !dbModel.isAbnormal;
        [dbModel save];
        IllegalUpListCellViewModel * cellViewModel = self.viewModel.arr_viewModel[indexPath.row];
        cellViewModel.isAbnormal = !cellViewModel.isAbnormal;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
        [sideslipCell hiddenAllSideslip];
        
        
    }];
    action.backgroundColor = DefaultColor;
    action.fontSize = 14.f;
    return @[action];
    
}

- (BOOL)sideslipCell:(LYSideslipCell *)sideslipCell canSideslipRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IllegalDBModel * dbModel = _viewModel.arr_illegal[indexPath.row];
    
    if (dbModel.isAbnormal) {
        return NO;
    }else{
        return YES;
    }

}




#pragma mark -dealloc

- (void)dealloc{
    NSLog(@"IllegalParkUpListVC dealloc");
    
}

@end
