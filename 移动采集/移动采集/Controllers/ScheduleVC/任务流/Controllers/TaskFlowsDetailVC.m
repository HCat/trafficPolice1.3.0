//
//  TaskFlowsDetailVC.m
//  移动采集
//
//  Created by hcat-89 on 2020/3/5.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "TaskFlowsDetailVC.h"
#import "NetWorkHelper.h"
#import "TaskFlowsDetailContentCell.h"
#import "TaskFlowsDetailBackWorkCell.h"
#import "TaskFlowsDetailReplyCell.h"
#import "TaskFlowsTrafficPermitCell.h"
#import "TaskFlowsDetailResultCell.h"
#import "UINavigationBar+BarItem.h"

#import "TaskFlowsHandleVC.h"
#import "TaskFlowsForwardVC.h"

@interface TaskFlowsDetailVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *v_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_height;

@property (weak, nonatomic) IBOutlet UIButton *btn_manage;

@property (strong, nonatomic) TaskFlowsDetailViewModel *viewModel;

@end

@implementation TaskFlowsDetailVC

- (instancetype)initWithViewModel:(TaskFlowsDetailViewModel *)viewModel{
    
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskFlowsChange:) name:@"任务流处理成功" object:nil];
        
        self.viewModel = viewModel;
    }
    
    return self;
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    @weakify(self);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        @strongify(self);
        [self.viewModel.command_loadDetail execute:nil];
        
    };
    
    [self configUI];
    [self bindViewModel];
    
    [self.viewModel.command_loadDetail execute:nil];
}

#pragma mark - configUI

- (void)configUI{

    self.title = @"任务详情";

    [self.tableView registerNib:[UINib nibWithNibName:@"TaskFlowsDetailContentCell" bundle:nil] forCellReuseIdentifier:@"TaskFlowsDetailContentCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskFlowsDetailBackWorkCell" bundle:nil] forCellReuseIdentifier:@"TaskFlowsDetailBackWorkCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskFlowsDetailReplyCell" bundle:nil] forCellReuseIdentifier:@"TaskFlowsDetailReplyCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskFlowsDetailResultCell" bundle:nil] forCellReuseIdentifier:@"TaskFlowsDetailResultCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskFlowsTrafficPermitCell" bundle:nil] forCellReuseIdentifier:@"TaskFlowsTrafficPermitCellID"];
    
    self.tableView.estimatedRowHeight = 110.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    @weakify(self);
    [[self.btn_manage rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        
        TaskFlowsHandleVC * vc = [[TaskFlowsHandleVC alloc] init];
        vc.taskId = self.viewModel.taskFlowsId;
        vc.type = self.viewModel.result.taskDetail.type;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    
    [RACObserve(self.viewModel, taskFlowsStatus) subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        
        if ([x isEqualToNumber:@0] && [self.viewModel.taskFlowsType isEqualToNumber:@1]) {
             [self showRightBarButtonItemWithTitle:@"转发" target:self action:@selector(handleForwarding)];
        }else{
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        
    }];
    

}

#pragma mark - bindViewModel

- (void)bindViewModel{
    
    @weakify(self);
    
    [RACObserve(self.viewModel, my_taskReply) subscribeNext:^(id  _Nullable x) {
        
        @strongify(self);
        
        if (x || [self.viewModel.taskFlowsType isEqualToNumber:@2]) {
            
            self.layout_height.constant = 0.f;
            self.v_bottom.hidden = YES;
            [self.view layoutIfNeeded];
            
        }else{
            
            self.layout_height.constant = 88.f;
            self.v_bottom.hidden = NO;
            [self.view layoutIfNeeded];
        }
        
    }];
    
    
    [self.viewModel.command_loadDetail.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
       
        @strongify(self);
        [self.tableView reloadData];
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.viewModel.result) {
        if (self.viewModel.my_taskReply) {
            return self.viewModel.arr_replys.count + 2;
        }else{
            return self.viewModel.arr_replys.count + 1;
        }
        
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        if ([self.viewModel.result.taskDetail.type isEqualToNumber:@2]) {
            TaskFlowsDetailBackWorkCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TaskFlowsDetailBackWorkCellID" forIndexPath:indexPath];
            cell.result = self.viewModel.result;
            
            return cell;
        }else if ([self.viewModel.result.taskDetail.type isEqualToNumber:@3]) {
            TaskFlowsTrafficPermitCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TaskFlowsTrafficPermitCellID" forIndexPath:indexPath];
            cell.result = self.viewModel.result;
        
            return cell;
            
            
        }else{
            TaskFlowsDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskFlowsDetailContentCellID" forIndexPath:indexPath];
            cell.result = self.viewModel.result;
                       
            return cell;
        }
        
        
    }else{
        
        if (self.viewModel.my_taskReply && indexPath.row == self.viewModel.arr_replys.count + 1) {
            
            TaskFlowsDetailResultCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TaskFlowsDetailResultCellID" forIndexPath:indexPath];
            cell.replyModel = self.viewModel.my_taskReply;
            
            return cell;
        }else{
            
            TaskFlowsDetailReplyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TaskFlowsDetailReplyCellID" forIndexPath:indexPath];
            cell.result = self.viewModel.result;
            TaskFlowsReplyModel * replyModel = self.viewModel.arr_replys[indexPath.row-1];
            cell.replyModel = replyModel;
            if (indexPath.row - 1 == 0) {
                cell.first = YES;
            }else{
                cell.first = NO;
            }
            
            return cell;
        }
        
    }
    
    return nil;
    
}

#pragma mark - scrollViewDelegate
//用于滚动到顶部的时候使得tableView不能再继续下拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _tableView){
    
       if (scrollView.contentOffset.y < 0) {
            CGPoint position = CGPointMake(0, 0);
            [scrollView setContentOffset:position animated:NO];
            return;
        }
        
    }
}

#pragma mark - button Action

- (void)handleForwarding{
    
    TaskFlowsForwardViewModel * viewModel = [[TaskFlowsForwardViewModel alloc] init];
    viewModel.taskId = self.viewModel.result.taskDetail.taskFlowsId;
    TaskFlowsForwardVC * vc = [[TaskFlowsForwardVC alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)taskFlowsChange:(NSNotification *)notification{
    
    NSNumber * object = notification.object;
    
    if (object && [object isEqualToNumber:@1]) {
        self.viewModel.taskFlowsStatus = @1;
    }
    
    [self.viewModel.command_loadDetail execute:nil];
    
}

#pragma mark - dealloc

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"任务流处理成功" object:nil];
    
    LxPrintf(@"TaskFlowsDetailVC dealloc");
}

@end
