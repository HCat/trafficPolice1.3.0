//
//  ScreenManageVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/6/19.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ScreenManageVC.h"
#import "ScreenManageAPI.h"
#import <MJRefresh.h>
#import "UITableView+Lr_Placeholder.h"
#import "ScreenManageCell.h"
#import "LRCameraVC.h"
#import "ScreenAddVC.h"

@interface ScreenManageVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_top_height;
@property (weak, nonatomic) IBOutlet UIButton *btn_empty;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn_scan;
@property (weak, nonatomic) IBOutlet UITextField *tf_search;

@property (weak, nonatomic) IBOutlet UIView *v_top;

@property (weak, nonatomic) IBOutlet UIView *v_tip;
@property (weak, nonatomic) IBOutlet UILabel *lb_tip;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UIButton *btn_makeSure;


@property (weak, nonatomic) IBOutlet UIButton *btn_add;


@property (nonatomic, strong) NSNumber * type;

@property (nonatomic, strong) ScreenListParam * param;

@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSMutableArray * arr_content;
@property (nonatomic, assign) NSInteger count;


@end

@implementation ScreenManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.param = [[ScreenListParam alloc] init];
    self.arr_content = @[].mutableCopy;
    self.param.rows = @50;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.tableView.isNetAvailable = NO;
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)lr_configUI{
    
    @weakify(self);
    
    self.title = @"综合屏管理";
    
    RAC(self.param, name) = [self.tf_search.rac_textSignal skip:1];
    
    self.v_tip.hidden = YES;
    
    self.btn_empty.layer.cornerRadius = 26/2.f;
    self.btn_empty.layer.masksToBounds = YES;
    self.btn_empty.layer.borderColor = UIColorFromRGB(0x666666).CGColor;
    self.btn_empty.layer.borderWidth = 0.5f;
    
    self.tableView.isNeedPlaceholderView = YES;
    self.tableView.firstReload = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.estimatedRowHeight = 44.5;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"ScreenManageCell" bundle:nil] forCellReuseIdentifier:@"ScreenManageCellID"];

    self.arr_content = [NSMutableArray array];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    [header setTitle:@"下拉查询" forState:MJRefreshStateIdle];
    [header setTitle:@"松手开始查询" forState:MJRefreshStatePulling];
    [header setTitle:@"查询中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"— 没有更多内容了 —" forState:MJRefreshStateNoMoreData];
    
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    footer.stateLabel.textColor = UIColorFromRGB(0xa6a6a6);
    self.tableView.mj_footer = footer;
    self.tableView.mj_footer.automaticallyHidden = YES;
    
    [self.tableView setReloadBlock:^{
        @strongify(self);
        self.tableView.isNetAvailable = NO;
        [self.tableView.mj_header beginRefreshing];
    }];
    
    [[[RACObserve(self.param, name) distinctUntilChanged] throttle:.5f] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (x) {
            self.tableView.isNetAvailable = NO;
            [self.tableView.mj_header beginRefreshing];
        }
        
    }];
    
    [[self.btn_cancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        self.v_tip.hidden = YES;
        
    }];
    
    
    [[self.btn_makeSure rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        self.v_tip.hidden = YES;
        
        ScreenDelManger * manger = [[ScreenDelManger alloc] init];
        manger.Id = self.userId;
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            @strongify(self);
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                
                self.tableView.isNetAvailable = NO;
                [self.tableView.mj_header beginRefreshing];
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [LRShowHUD showError:@"请求失败" duration:1.5f];
        }];
        
        
    }];
    
    
    [[self.btn_empty rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
    
        self.v_tip.hidden = NO;
        self.userId = @0;
        self.type = @2;
        self.lb_tip.text = @"是否清空全部信息";
        
    }];
    
    
    [[self.btn_scan rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
    
        LRCameraVC *home = [[LRCameraVC alloc] init];
        home.isAccident = YES;
        home.type = 3;
        home.fininshCaptureBlock = ^(LRCameraVC *camera) {
            if (camera) {
                if (camera.type == 3) {
                    self.param.name = camera.commonIdentifyResponse.name;
                
                }
            }
        };
        [self presentViewController:home
                           animated:NO
                         completion:^{
                         }];
        
    }];
    
    
    [[self.btn_add rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
    
        ScreenAddVC * vc = [[ScreenAddVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    

    
}

- (void)lr_bindViewModel{
    @weakify(self);
    

    [RACObserve(self, count)  subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);

        if ([x intValue] == 0) {
            self.v_top.hidden = YES;
            self.layout_top_height.constant = 0.f;
        }else{
            self.v_top.hidden = NO;
            self.layout_top_height.constant = 44.f;
        }

    }];
    
    
}



- (void)reloadData{
    self.param.page = @1;
    [self dataRequest];
}

- (void)loadData{
    self.param.page = @([self.param.page intValue] + 1);
    [self dataRequest];
}

- (void)dataRequest{
    @weakify(self);
    ScreenListManger *manger = [[ScreenListManger alloc] init];
    if (self.param.name && self.param.name.length == 0) {
        self.param.name = nil;
    }
    manger.param = self.param;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            if ([self.param.page isEqualToNumber:@1]) {
                if (self.arr_content.count > 0) {
                    [self.arr_content removeAllObjects];
                }
            }
            [self.arr_content addObjectsFromArray:manger.screenresponse.list];
            self.count = self.arr_content.count;
            if (self.arr_content.count == manger.screenresponse.total) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        
        }else{
            self.param.page = @([self.param.page intValue] - 1);
            if ([self.param.page intValue]< 1) {
                self.param.page = @1;
            }
            //[LRShowHUD showError:@"网络错误" duration:1.5 inView:self.view config:nil];
            
            [self.tableView reloadData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        self.param.page = @([self.param.page intValue] - 1);
        if ([self.param.page intValue]< 0) {
            self.param.page = @0;
        }
        //[LRShowHUD showError:@"网络错误" duration:1.5 inView:self.view config:nil];
        
        [self.tableView reloadData];
    }];

}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr_content.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ScreenManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScreenManageCellID"];
    ScreenItemModel *t_model = self.arr_content[indexPath.row];
    NSString * showText = t_model.content;
    NSString * nameText = t_model.name;
    if (nameText.length > 0) {
        cell.lb_content.attributedText = [ShareFun getAttributeWith:@[nameText] string:showText orginFont:15 orginColor:UIColorFromRGB(0x333333) attributeFont:15 attributeColor:UIColorFromRGB(0x3396FC)];
    }else{
        cell.lb_content.text = t_model.content;
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ScreenItemModel *t_model = self.arr_content[indexPath.row];
    
    self.v_tip.hidden = NO;
    self.userId = t_model.Id;
    self.type = @1;
    self.lb_tip.text = @"是否删除该条信息";
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
//    if (self.param.name && self.param.name.length > 0) {
//        self.tableView.isNetAvailable = NO;
//        [self.tableView.mj_header beginRefreshing];
//    }
//
    return YES;
}


@end
