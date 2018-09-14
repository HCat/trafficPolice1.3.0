//
//  ActionDetailVC.m
//  移动采集
//
//  Created by hcat on 2018/8/2.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "ActionDetailVC.h"
#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "NetWorkHelper.h"
#import "ActionAPI.h"
#import "ActionDetailCell.h"
#import "ActionTopCell.h"
#import "UINavigationBar+BarItem.h"


@interface ActionDetailVC ()

@property (weak, nonatomic) IBOutlet UITableView *tb_content;

@property (nonatomic,strong) NSMutableArray *arr_content;

@property (nonatomic,strong) ActionDetailReponse * actionReponse;

@end

@implementation ActionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行动详情";
    self.arr_content = [NSMutableArray array];
    
    [self setUpTableView];
    
    [self requestDetail];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        [strongSelf requestDetail];
    };
    
}

#pragma mark - set

- (void)setUpTableView{
    
    _tb_content.isNeedPlaceholderView = YES;
    _tb_content.firstReload = YES;
    
    [_tb_content registerNib:[UINib nibWithNibName:@"ActionTopCell" bundle:nil] forCellReuseIdentifier:@"ActionTopCellID"];
    [_tb_content registerNib:[UINib nibWithNibName:@"ActionDetailCell" bundle:nil] forCellReuseIdentifier:@"ActionDetailCellID"];
    
    WS(weakSelf);
    //点击重新加载之后的处理
    [_tb_content setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        [strongSelf requestDetail];
    }];
    
}

#pragma mark - 请求数据

- (void)requestDetail{
    
    WS(weakSelf);
    
    if (_arr_content && _arr_content.count > 0) {
        [_arr_content removeAllObjects];
    }
    
    ActionDetailManger *manger = [[ActionDetailManger alloc] init];
    manger.actionId = _actionId;
    [manger configLoadingTitle:@"加载"];
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            
            strongSelf.actionReponse = manger.acctionReponse;
            
            if ([strongSelf.actionReponse.action.status isEqualToNumber:@0]) {
                [strongSelf showRightBarButtonItemWithTitle:@"发布" target:strongSelf action:@selector(handleBtnUpClicked)];
                
            }
            
           
            [strongSelf.arr_content addObjectsFromArray:manger.acctionReponse.actionTaskList];
            [strongSelf.tb_content reloadData];
            
        }else{
            NSString *t_errString = [NSString stringWithFormat:@"网络错误:code:%ld msg:%@",manger.responseModel.code,manger.responseModel.msg];
            [LRShowHUD showError:t_errString duration:1.5 inView:strongSelf.view config:nil];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf,weakSelf);
        
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            if (strongSelf.arr_content.count > 0) {
                [strongSelf.arr_content removeAllObjects];
            }
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

    return _arr_content.count + 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WS(weakSelf);
    
    if (indexPath.row == 0) {
        
        CGFloat height = [tableView fd_heightForCellWithIdentifier:@"ActionTopCellID" cacheByIndexPath:indexPath configuration:^(ActionTopCell *cell) {
            SW(strongSelf, weakSelf);
            if (strongSelf.actionReponse.action) {
                
                ActionInfoModel *t_model = strongSelf.actionReponse.action;
                cell.action = t_model;
                
            }
        }];
        
        return height;
        
    }else{
        
        CGFloat height = [tableView fd_heightForCellWithIdentifier:@"ActionDetailCellID" cacheByIndexPath:indexPath configuration:^(ActionDetailCell *cell) {
            SW(strongSelf, weakSelf);
            if (strongSelf.arr_content && strongSelf.arr_content.count > 0) {
                ActionTaskListModel *t_model = strongSelf.arr_content[indexPath.row - 1];
                cell.model = t_model;
                
                
            }
        }];
        
        return height;
        
    }
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        
        ActionTopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ActionTopCellID"];
        if (self.actionReponse.action) {
            
            ActionInfoModel *t_model = self.actionReponse.action;
            cell.action = t_model;
            
        }
        
        
        return cell;
        
    }else{
        ActionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActionDetailCellID"];
        
        if (_arr_content && _arr_content.count > 0) {
            ActionTaskListModel *t_model = _arr_content[indexPath.row - 1];
            cell.model = t_model;
            
        }
        
        return cell;
    
    }
   
}


#pragma mark - btnMethods

- (void)handleBtnUpClicked{
    
    ActionChangeStatusManger * manger  = [[ActionChangeStatusManger alloc] init];
    manger.actionId = self.actionId;
    manger.status = @1;
    [manger configLoadingTitle:@"发布"];
    WS(weakSelf);
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ACTION_UP object:nil];
        [strongSelf showRightBarButtonItemWithTitle:@"" target:strongSelf action:@selector(handleBtnUpClicked)];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"ActionDetailVC dealloc");
    
}


@end
