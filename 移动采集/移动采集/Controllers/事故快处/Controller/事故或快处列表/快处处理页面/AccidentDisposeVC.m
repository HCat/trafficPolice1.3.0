//
//  AccidentDisposeVC.m
//  移动采集
//
//  Created by hcat on 2019/8/30.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "AccidentDisposeVC.h"
#import "UITableView+Lr_Placeholder.h"

#import "NetWorkHelper.h"
#import "AccidentDisposeCell.h"


@interface AccidentDisposeVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btn_up;



@property (nonatomic, strong) AccidentDisposeViewModel * viewModel;



@end

@implementation AccidentDisposeVC

- (instancetype)initWithViewModel:(AccidentDisposeViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return self;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
    @weakify(self);
    [self.viewModel.command_people.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        if ([x isEqualToString:@"加载成功"]) {
            [self.tableView reloadData];
        }else{
            self.tableView.isNetAvailable = YES;
            [self.tableView reloadData];
        }
        
    }];
    
    [self.viewModel.command_dealAccident.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        if ([x isEqualToString:@"提交成功"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"快处处理成功" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
    [self.viewModel.command_people execute:nil];
    
}


#pragma mark -

- (void)configUI{
    
    self.title = @"快处处理";
  
    self.tableView.isNeedPlaceholderView = YES;
    self.tableView.str_placeholder = @"暂无人员列表";
    self.tableView.firstReload = YES;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"AccidentDisposeCell" bundle:nil] forCellReuseIdentifier:@"AccidentDisposeCellID"];
    
    @weakify(self);
    //点击重新加载之后的处理
    [self.tableView setReloadBlock:^{
        @strongify(self);
        self.tableView.isNetAvailable = NO;
        [self.viewModel.command_people execute:nil];
    }];
    
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        @strongify(self);
        self.tableView.isNetAvailable = NO;
        [self.viewModel.command_people execute:nil];
    };
    
    
    [[self.btn_up rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
       @strongify(self);
        
        for (AccidentDisposePeopelModel * model in self.viewModel.arr_count) {
            
            if (!model.responsibilityId) {
                [ShareFun showTipLable:@"请选择责任"];
                return ;
            }
            
        }
        
        [self.viewModel.command_dealAccident execute:nil];
        
    }];
    
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.arr_count.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    AccidentDisposePeopelModel *itemModel = self.viewModel.arr_count[indexPath.row];
    
    AccidentDisposeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentDisposeCellID"];
    cell.model = itemModel;
   
    return cell;
    
}

#pragma - mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}



#pragma mark - dealloc

-(void)dealloc{
    NSLog(@"AccidentDisposeVC dealloc");
}

@end
