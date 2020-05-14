//
//  AccidentUpListVC.m
//  移动采集
//
//  Created by hcat on 2018/10/19.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "AccidentUpListVC.h"
#import "LRPlaceholderView.h"
#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "IllegalParkUpListCell.h"
#import "AccidentDBModel.h"
#import "AccidentDetailVC.h"

@interface AccidentUpListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) AccidentUpListViewModel * viewModel;
@property (weak, nonatomic) IBOutlet UIButton *btn_up;

@end

@implementation AccidentUpListVC

- (instancetype)initWithViewModel:(AccidentUpListViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
        
        WS(weakSelf);
        [self.viewModel.rac_addCache subscribeNext:^(id  _Nullable x) {
            SW(strongSelf, weakSelf);
            [strongSelf.tableView reloadData];
        }];
        [self.viewModel.rac_deleteCache subscribeNext:^(NSNumber * x) {
            SW(strongSelf, weakSelf);
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[x integerValue] inSection:0];
            [strongSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    
    WS(weakSelf);
    [[RACObserve(self.viewModel, isUping) map:^id _Nullable(NSNumber * value) {
        return [value boolValue] ? @"暂停" : @"上传";
    }] subscribeNext:^(id  _Nullable x) {
        SW(strongSelf, weakSelf);
        [strongSelf.btn_up setTitle:x forState:UIControlStateNormal];
    }];
    
    [[RACSignal combineLatest:@[RACObserve(self.viewModel, illegalCount),RACObserve(self.viewModel, isAutoUp)] reduce:^id(NSNumber * illegalCount,NSNumber *isAutoUp){
        
        return @([illegalCount intValue] == 0 || [isAutoUp boolValue]);
        
    }]subscribeNext:^(id  _Nullable x) {
        SW(strongSelf, weakSelf);
        strongSelf.btn_up.hidden = [x boolValue];
        
    }];
    
    
    [RACObserve(self.viewModel, illegalCount) subscribeNext:^(NSNumber * x) {
        SW(strongSelf, weakSelf);
        if ([x intValue] == 0) {
            [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
                [strongSelf.tableView reloadData];
                
            }];
            
        }
    }];
    
    
    [[self.btn_up rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        SW(strongSelf, weakSelf);
        strongSelf.viewModel.isUping = !strongSelf.viewModel.isUping;
        
    }];
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
        AccidentUpListCellViewModel * model = strongSelf.viewModel.arr_viewModel[indexPath.row];
        cell.accidentViewModel = model;
        
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IllegalParkUpListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalParkUpListCellID"];
    AccidentUpListCellViewModel * model = _viewModel.arr_viewModel[indexPath.row];
    cell.accidentViewModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AccidentDBModel *t_model = _viewModel.arr_accident[indexPath.row];
    AccidentDetailVC *accidentDetailVC = [[AccidentDetailVC alloc] init];
    accidentDetailVC.cacheModel = [t_model mapAccidentDetailModel];
    accidentDetailVC.accidentType = [t_model.type integerValue];
    [self.navigationController pushViewController:accidentDetailVC animated:YES];
    
}

#pragma mark -dealloc

- (void)dealloc{
    NSLog(@"AccidentUpListVC dealloc");
    
}

@end
