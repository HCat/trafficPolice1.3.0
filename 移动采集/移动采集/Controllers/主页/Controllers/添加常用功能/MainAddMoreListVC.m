//
//  MainAddMoreListVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/14.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "MainAddMoreListVC.h"
#import "MainAddMoreListViewModel.h"
#import "LRBaseTableView.h"
#import "MainListCell.h"

@interface MainAddMoreListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet LRBaseTableView *tableView;

@property(nonatomic, strong) MainAddMoreListViewModel * viewModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_top_tableView;

@end

@implementation MainAddMoreListVC

- (instancetype)init{
    
    if (self = [super init]) {
        self.viewModel = [[MainAddMoreListViewModel alloc] init];
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)lr_configUI{
    
    @weakify(self);
    
    self.title = @"添加常用应用";
    self.layout_top_tableView.constant = -Height_NavBar;
    
    
    self.tableView.autoNetworkNotice = YES;
    self.tableView.isHavePlaceholder = YES;
    self.tableView.enableRefresh = YES;
    
    self.tableView.tableViewPlaceholderBlock = ^{
        @strongify(self);
        
        
        if (self.viewModel.arr_content.count > 0) {
            [self.viewModel.arr_content removeAllObjects];
            [self.tableView reloadData];
        }
        
        self.tableView.lr_handler.state = LRDataLoadStateLoading;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              @strongify(self);
              [self reloadData];
        });
    };
    
    self.tableView.tableViewHeaderRefresh = ^{
        @strongify(self);
        [self reloadData];
        
    };
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MainListCell" bundle:nil] forCellReuseIdentifier:@"MainListCellID"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 135.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
}


- (void)lr_bindViewModel{
    
    @weakify(self);
    

    [self.viewModel.command_list.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        [self.tableView endingRefresh];
        [self.tableView endingLoadMore];
        
        if([x isEqualToString:@"加载成功"]){
            if (self.viewModel.arr_content.count == 0) {
                self.tableView.lr_handler.state = LRDataLoadStateEmpty;
            }else{
                self.tableView.lr_handler.state = LRDataLoadStateIdle;
            }
            
            int number = 0;
            for (MenuInfoModel * model in self.viewModel.arr_content) {
                
                if ([model.isOrg isEqualToNumber:@1]) {
                    if ([model.isUser isEqualToNumber:@1]) {
                        if ([model.isActive isEqualToNumber:@1]) {
                            number = number + 1;
                        }
                    }
                }
            
            }
            
            NSString * string = @"确定";
            
            if (number > 0) {
                string = [NSString stringWithFormat:@"确定(%d)",number];
            }
            
            [self zx_setRightBtnWithText:string clickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
                @strongify(self);
                [self.viewModel.command_save execute:nil];
            }];
            

        }else if([x isEqualToString:@"加载失败"]){
            
            if (self.viewModel.arr_content.count == 0) {
                self.tableView.lr_handler.state = LRDataLoadStateFailed;
            }
        }
        
        [self.tableView reloadData];
        
    }];
    
    [self.viewModel.command_save.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if([x isEqualToString:@"保存成功"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MAINCOMMON_SUCCESS object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
    
    if (self.viewModel.arr_content.count > 0) {
        [self.viewModel.arr_content removeAllObjects];
        [self.tableView reloadData];
    }
    [self.tableView resetNoMoreData];
    self.tableView.lr_handler.state = LRDataLoadStateLoading;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self reloadData];
    });
    
    
}

#pragma mark - 加载新数据

- (void)reloadData{
    
    [self.tableView resetNoMoreData];
    [self.viewModel.command_list execute:nil];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.arr_content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainListCellID" forIndexPath:indexPath];
    cell.model = self.viewModel.arr_content[indexPath.row];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MenuInfoModel * model = self.viewModel.arr_content[indexPath.row];
    
    if ([model.current isEqualToString:@"1"]) {
        [self.tableView reloadData];
        return;
    }
    
    if ([model.isOrg isEqualToNumber:@1]) {
        if ([model.isUser isEqualToNumber:@1]) {
            if ([model.isActive isEqualToNumber:@1]) {
                model.isActive = @0;
            }else{
                model.isActive = @1;
            }
        }
        
    }
    
    @weakify(self);
    int number = 0;
    for (MenuInfoModel * model in self.viewModel.arr_content) {
        
        if ([model.current isEqualToString:@"1"]) {
            continue;
        }
        
        if ([model.isOrg isEqualToNumber:@1]) {
            if ([model.isUser isEqualToNumber:@1]) {
                if ([model.isActive isEqualToNumber:@1]) {
                    number = number + 1;
                }
            }
        }
        
    }
    
    NSString * string = @"确定";
    
    if (number > 0) {
        string = [NSString stringWithFormat:@"确定(%d)",number];
    }
    
    [self zx_setRightBtnWithText:string clickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
        @strongify(self);
        [self.viewModel.command_save execute:nil];
    }];
    
    
    [self.tableView reloadData];
    
}


@end
