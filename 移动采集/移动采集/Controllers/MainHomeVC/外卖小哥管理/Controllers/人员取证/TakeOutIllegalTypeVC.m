//
//  TakeOutIllegalTypeVC.m
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutIllegalTypeVC.h"
#import "TakeOutIllegalTypeCell.h"
#import "TakeOutIllegalTypeTopCell.h"
#import "UITableView+Lr_Placeholder.h"
#import "NetWorkHelper.h"

@interface TakeOutIllegalTypeVC ()

@property(nonatomic,strong) TakeOutIllegalTypeViewModel * viewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *btn_commit;


@end

@implementation TakeOutIllegalTypeVC


- (instancetype)initWithViewModel:(TakeOutIllegalTypeViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel];

    [self.viewModel.command_type execute:nil];
}

#pragma mark - 配置UI界面

- (void)configUI{
    
    self.title = @"违法行为";
    
    self.tableView.isNeedPlaceholderView = YES;
    self.tableView.str_placeholder = @"暂无扣分记录";
    self.tableView.firstReload = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"TakeOutIllegalTypeCell" bundle:nil] forCellReuseIdentifier:@"TakeOutIllegalTypeCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TakeOutIllegalTypeTopCell" bundle:nil] forCellReuseIdentifier:@"TakeOutIllegalTypeTopCellID"];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    @weakify(self);
    //点击重新加载之后的处理
    [self.tableView setReloadBlock:^{
        @strongify(self);
        self.tableView.isNetAvailable = NO;
        [self.viewModel.command_type execute:nil];
    }];
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        @strongify(self);
        self.tableView.isNetAvailable = NO;
        [self.viewModel.command_type execute:nil];
    };
    
    
    [[self.btn_commit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        NSMutableArray * t_arr = @[].mutableCopy;
        NSMutableArray * t_arr_code = @[].mutableCopy;
        
        for (DeliveryIllegalTypeModel * itemModel in self.viewModel.arr_content) {
            if (itemModel.isSelected) {
                [t_arr addObject:itemModel.illegalName];
                [t_arr_code addObject:itemModel.illegalId];
            }
        }
        
        if (t_arr && t_arr.count > 0) {
            NSString *arrrayString = [t_arr componentsJoinedByString:@","];
            NSString *arrrayCode = [t_arr_code componentsJoinedByString:@","];
            if (self.block) {
                self.block(arrrayString, arrrayCode);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [LRShowHUD showError:@"请选择类型" duration:1.5f];
        }
        
    }];

}

#pragma mark - 绑定ViewModels

- (void)bindViewModel{
    
    @weakify(self);
    
    [self.viewModel.command_type.executionSignals.switchToLatest subscribeNext:^(id _Nullable x) {
        @strongify(self);
        
        if([x isEqualToString:@"加载失败"]){
            
            Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
            NetworkStatus status = [reach currentReachabilityStatus];
            if (status == NotReachable) {
                if (self.viewModel.arr_content.count > 0) {
                    [self.viewModel.arr_content removeAllObjects];
                }
                self.tableView.isNetAvailable = YES;
                [self.tableView reloadData];
            }
            
            
        }
        
        [self.tableView reloadData];
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.arr_content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DeliveryIllegalTypeModel *itemModel = self.viewModel.arr_content[indexPath.row];
    
    if (itemModel) {
        if ([itemModel.floor isEqualToNumber:@1]) {
            TakeOutIllegalTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TakeOutIllegalTypeCellID" forIndexPath:indexPath];
            cell.model = itemModel;
            return cell;
        }else{
            TakeOutIllegalTypeTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TakeOutIllegalTypeTopCellID" forIndexPath:indexPath];
            cell.model = itemModel;
            return cell;
        }
    }

    return nil;
    
}

#pragma - mark UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DeliveryIllegalTypeModel *itemModel = self.viewModel.arr_content[indexPath.row];
    
    if (itemModel) {
        if ([itemModel.floor isEqualToNumber:@1]) {
            itemModel.isSelected = !itemModel.isSelected;
            [self.tableView reloadData];
        }
    }
    
}


#pragma mark - dalloc

- (void)dealloc{
    LxPrintf(@"TakeOutIllegalTypeVC dealloc");
}

@end
