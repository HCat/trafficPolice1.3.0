//
//  AttendanceSignInVC.m
//  移动采集
//
//  Created by hcat on 2019/4/4.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "AttendanceSignInVC.h"
#import "UITableView+Lr_Placeholder.h"
#import "AttendanceSignInCell.h"

@interface AttendanceSignInVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) AttendanceSignInViewModel * viewModel;

@end

@implementation AttendanceSignInVC

- (instancetype)initWithViewModel:(AttendanceSignInViewModel *)viewModel{
    
    if (self = [super init]) {
        
        self.viewModel = viewModel;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
    
    @weakify(self);
    [self.viewModel.command_signIn.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if ([x isEqualToString:@"加载成功"]) {
            [self.tableView reloadData];
        }
    
    }];
    
    [self.viewModel.command_signIn execute:nil];
    
}

#pragma mark - configUI

- (void)configUI{
    
    self.title = self.viewModel.policemodel.realName;
    self.tableView.isNeedPlaceholderView = YES;
    self.tableView.str_placeholder = @"暂无考勤信息";
    self.tableView.firstReload = YES;
    //隐藏多余行的分割线
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [_tableView registerNib:[UINib nibWithNibName:@"AttendanceSignInCell" bundle:nil] forCellReuseIdentifier:@"AttendanceSignInCellID"];
    
    //点击重新加载之后的处理
    @weakify(self);
    [self.tableView setReloadBlock:^{
        @strongify(self);
        [self.viewModel.command_signIn execute:nil];
    }];
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.arr_signIn.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AttendanceSignInCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttendanceSignInCellID"];
    cell.viewModel = self.viewModel.arr_signIn[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"AttendanceSignInVC dealloc");
}

@end
