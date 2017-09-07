//
//  VideoListVC.m
//  trafficPolice
//
//  Created by hcat on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "VideoListVC.h"
#import "UICollectionView+Lr_Placeholder.h"

#import <MJRefresh.h>
#import "VideoColectAPI.h"
#import "VideoListCell.h"
#import "VideoDetailVC.h"
#import "NetWorkHelper.h"
//#import "SearchListVC.h"

@interface VideoListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *arr_content;

@property (nonatomic,assign) NSInteger index; //加载更多数据索引

@end

@implementation VideoListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.canBack = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoSuccess:) name:NOTIFICATION_VIDEO_SUCCESS object:nil];
    
    _collectionView.isNeedPlaceholderView = YES;
    if (_str_search) {
        _collectionView.str_placeholder = @"暂无搜索内容";
    }
    _collectionView.firstReload = YES;
    
    self.arr_content = [NSMutableArray array];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"VideoListCell" bundle:nil] forCellWithReuseIdentifier:@"VideoListCellID"];
    [self initRefresh];
    
    
    [self.collectionView.mj_header beginRefreshing];
    
    WS(weakSelf);
    
    //点击重新加载之后的处理
    [_collectionView setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.collectionView.isNetAvailable = NO;
        strongSelf.index = 0;
        [strongSelf.collectionView.mj_header beginRefreshing];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    WS(weakSelf);
    
    [ApplicationDelegate.vc_tabBar hideTabBarAnimated:NO];
    
    //网络断开之后重新连接之后的处理
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.collectionView.isNetAvailable = NO;
        strongSelf.index = 0;
        [strongSelf.collectionView.mj_header beginRefreshing];
    };
    
}

#pragma mark - 创建下拉刷新，以及上拉加载更多

- (void)initRefresh{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    [header setTitle:@"下拉查询" forState:MJRefreshStateIdle];
    [header setTitle:@"松手开始查询" forState:MJRefreshStatePulling];
    [header setTitle:@"查询中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = header;
    
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"— 没有更多内容了 —" forState:MJRefreshStateNoMoreData];
    
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    footer.stateLabel.textColor = UIColorFromRGB(0xa6a6a6);
    self.collectionView.mj_footer = footer;
    self.collectionView.mj_footer.automaticallyHidden = YES;
    
}

#pragma mark - 加载新数据

- (void)reloadData{
    self.index = 0;
    [self loadData];
}

- (void)loadData{
    
    WS(weakSelf);
    
    if (_index == 0) {
        if (_arr_content && _arr_content.count > 0) {
            [_arr_content removeAllObjects];
        }
    }
    
    VideoColectListPagingParam *param = [[VideoColectListPagingParam alloc] init];
    param.start = _index;
    param.length = 10;
    VideoColectListPagingManger *manger = [[VideoColectListPagingManger alloc] init];
    manger.param = param;
    manger.isNeedShowHud = NO;
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        [strongSelf.collectionView.mj_header endRefreshing];
        [strongSelf.collectionView.mj_footer endRefreshing];
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            [strongSelf.arr_content addObjectsFromArray:manger.videoColectListPagingReponse.list];
            if (strongSelf.arr_content.count == manger.videoColectListPagingReponse.total) {
                [strongSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                strongSelf.index += param.length;
            }
            [strongSelf.collectionView reloadData];
        }else{
            NSString *t_errString = [NSString stringWithFormat:@"网络错误:code:%ld msg:%@",manger.responseModel.code,manger.responseModel.msg];
            [LRShowHUD showError:t_errString duration:1.5 inView:strongSelf.view config:nil];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf,weakSelf);
        [strongSelf.collectionView.mj_header endRefreshing];
        [strongSelf.collectionView.mj_footer endRefreshing];
        
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            if (strongSelf.arr_content.count > 0) {
                [strongSelf.arr_content removeAllObjects];
            }
            strongSelf.collectionView.isNetAvailable = YES;
            [strongSelf.collectionView reloadData];
        }
    }];
    
}

#pragma mark - UICollectionView Data Source

//返回多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView   *)collectionView
{
    return 1;
}
//返回每组多少个视图
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _arr_content.count;
}
//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoListCellID" forIndexPath:indexPath];
    
    if (_arr_content && _arr_content.count > 0) {
        VideoColectListModel *model = _arr_content[indexPath.row];
        cell.model = model;
    }
    
    return cell;
}

#pragma mark - UICollectionView Delegate method

//选中某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LxPrintf(@"选中 : %ld--%ld",(long)indexPath.section,(long)indexPath.item);
    
    if (_arr_content && _arr_content.count > 0) {
        
        UIViewController *vc_target = self;
        //搜索时候的跳转
        if (_str_search) {
           // vc_target = (SearchListVC *)[ShareFun findViewController:self.view withClass:[SearchListVC class]];
        }
        
        VideoColectListModel *model = _arr_content[indexPath.row];
        VideoDetailVC * t_vc = [[VideoDetailVC alloc] init];
        t_vc.path = model.path;
        [vc_target.navigationController pushViewController:t_vc animated:YES];
    }
    
}

//取消某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LxPrintf(@"取消选中 : %ld--%ld",(long)indexPath.section,(long)indexPath.item);
}


#pragma mark - UICollectionView Delegate FlowLayout

// cell 尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width=(self.view.bounds.size.width-6)/2;
    return CGSizeMake(width, 153);
}

// 装载内容 cell 的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

//item最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

#pragma mark -notification

- (void)videoSuccess:(NSNotification *)notification{
    [_collectionView.mj_header beginRefreshing];
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_VIDEO_SUCCESS object:nil];
    LxPrintf(@"VideoListVC dealloc");
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
