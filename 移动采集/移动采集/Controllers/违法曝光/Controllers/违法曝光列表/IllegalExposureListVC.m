//
//  IllegalExposureListVC.m
//  移动采集
//
//  Created by hcat on 2019/12/6.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "IllegalExposureListVC.h"
#import "ExposureCollectAPI.h"
#import "IllegalExposureVC.h"

#import <MJRefresh.h>

#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "IllegalCell.h"
#import "NetWorkHelper.h"
#import "IllegalExposureDetailVC.h"

#import "LRBaseTableView.h"
#import "IllegalCollectListCell.h"
#import "UserModel.h"


@interface IllegalExposureListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet LRBaseTableView *tableView;

@property (nonatomic,strong) NSMutableArray *arr_content;

@property (nonatomic,assign) NSInteger index; //加载更多数据索引


@end

@implementation IllegalExposureListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    
    self.tableView.autoNetworkNotice = YES;
    self.tableView.isHavePlaceholder = YES;

    self.tableView.tableViewPlaceholderBlock = ^{
        @strongify(self);
        
        if (self.arr_content.count > 0) {
            [self.arr_content removeAllObjects];
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
    
    self.tableView.tableViewFooterLoadMore = ^{
        @strongify(self);
        [self loadData];
        
    };
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IllegalCollectListCell" bundle:nil] forCellReuseIdentifier:@"IllegalCollectListCellID"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 135.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.arr_content = [NSMutableArray array];
       
  
    if ([UserModel isPermissionForExposureList]) {
        
        if (self.arr_content.count > 0) {
            [self.arr_content removeAllObjects];
            [self.tableView reloadData];
        }
        self.tableView.enableRefresh = YES;
        self.tableView.enableLoadMore = YES;
        [self.tableView resetNoMoreData];
        self.tableView.lr_handler.state = LRDataLoadStateLoading;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self reloadData];
        });
    }else{
        if (self.arr_content.count > 0) {
            [self.arr_content removeAllObjects];
            [self.tableView reloadData];
        }
        self.tableView.enableRefresh = NO;
        self.tableView.enableLoadMore = NO;
        self.tableView.lr_handler.state = LRDataLoadStateEmpty;
        [self.tableView reloadData];
    }
    
    
    
}

#pragma mark - 加载新数据

- (void)reloadData{
    self.index = 0;
    [self loadData];
}

- (void)loadData{
    
    @weakify(self);
    if (_index == 0) {
        if (_arr_content && _arr_content.count > 0) {
            [_arr_content removeAllObjects];
        }
    }
    
    ExposureCollectListPagingParam *param = [[ExposureCollectListPagingParam alloc] init];
     param.start = _index;
     param.length = 10;
     
     
     ExposureCollectListPagingManger *manger = [[ExposureCollectListPagingManger alloc] init];
     manger.param = param;
    
     [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
         @strongify(self);
         [self.tableView endingRefresh];
         [self.tableView endingLoadMore];
         
         if (manger.responseModel.code == CODE_SUCCESS) {
             
             [self.arr_content addObjectsFromArray:manger.exposureCollectListPagingReponse.list];
             if (self.arr_content.count == manger.exposureCollectListPagingReponse.total) {
                 [self.tableView endingNoMoreData];
                 if (self.arr_content.count == 0) {
                     self.tableView.lr_handler.state = LRDataLoadStateEmpty;
                 }
             }else{
                 self.index += param.length;
                 if (self.arr_content.count == 0) {
                     self.tableView.lr_handler.state = LRDataLoadStateEmpty;
                 }else{
                     self.tableView.lr_handler.state = LRDataLoadStateIdle;
                 }
             }
             [self.tableView reloadData];
         }else{
             if (self.arr_content.count == 0) {
                 self.tableView.lr_handler.state = LRDataLoadStateFailed;
                 [self.tableView reloadData];
             }
             
         }
         
     } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
         @strongify(self);
         [self.tableView endingRefresh];
         [self.tableView endingLoadMore];
         self.tableView.lr_handler.state = LRDataLoadStateFailed;
         [self.tableView reloadData];
         
     }];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_content.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    IllegalCollectListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalCollectListCellID"];
    
    if (_arr_content && _arr_content.count > 0) {
        ExposureCollectListModel *t_model = _arr_content[indexPath.row];
        cell.model_exposure = t_model;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_arr_content && _arr_content.count > 0) {
        
        ExposureCollectListModel *t_model = _arr_content[indexPath.row];
        IllegalExposureDetailVC *t_vc = [[IllegalExposureDetailVC alloc] init];
        t_vc.exposureCollectId = t_model.exposureCollectId;
        [self.navigationController pushViewController:t_vc animated:YES];
            
    }
    
}


- (IBAction)handleIllegalAdd:(id)sender {
    
    IllegalExposureVC * vc = [[IllegalExposureVC alloc] init];
    NSRange range = [self.title rangeOfString:@"列表"];
    NSLog(@"rang:%@",NSStringFromRange(range));
    vc.title =  [self.title substringToIndex:range.location];
    [self.navigationController pushViewController:vc animated:YES];

}



- (void)dealloc{

    
    
    LxPrintf(@"IllegalList dealloc");
    
}

@end
