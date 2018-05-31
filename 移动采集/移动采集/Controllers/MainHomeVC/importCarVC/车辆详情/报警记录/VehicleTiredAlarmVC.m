//
//  VehicleTiredAlarmVC.m
//  移动采集
//
//  Created by hcat on 2018/5/24.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleTiredAlarmVC.h"
#import "VehicleAPI.h"
#import <MJRefresh.h>
#import "UICollectionView+Lr_Placeholder.h"
#import "NetWorkHelper.h"
#import "VehicleTiredListCell.h"
#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"

@interface VehicleTiredAlarmVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *arr_content;

@end

@implementation VehicleTiredAlarmVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"疲劳驾驶";
    
    _collectionView.isNeedPlaceholderView = YES;
    
    _collectionView.firstReload = YES;
    self.arr_content = [NSMutableArray array];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"VehicleTiredListCell" bundle:nil] forCellWithReuseIdentifier:@"VehicleTiredListCellID"];
    [self initRefresh];
    
    [self.collectionView.mj_header beginRefreshing];
    
    WS(weakSelf);
    
    //点击重新加载之后的处理
    [_collectionView setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.collectionView.isNetAvailable = NO;
        [strongSelf.collectionView.mj_header beginRefreshing];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    WS(weakSelf);
    
    //网络断开之后重新连接之后的处理
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.collectionView.isNetAvailable = NO;
        [strongSelf.collectionView.mj_header beginRefreshing];
    };
    
}

#pragma mark - 创建下拉刷新，以及上拉加载更多

- (void)initRefresh{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [header setTitle:@"下拉查询" forState:MJRefreshStateIdle];
    [header setTitle:@"松手开始查询" forState:MJRefreshStatePulling];
    [header setTitle:@"查询中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = header;
    
}

- (void)loadData{
    
    WS(weakSelf);
    
    if (_arr_content && _arr_content.count > 0) {
        [_arr_content removeAllObjects];
    }
    
    VehicleTiredImageListParam *param = [[VehicleTiredImageListParam alloc] init];
    param.plateNo = _plateNo;
    param.startTime = _startTime;
    param.endTime = _endTime;
    
    VehicleTiredImageListManger *manger = [[VehicleTiredImageListManger alloc] init];
    manger.param = param;
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        [strongSelf.collectionView.mj_header endRefreshing];
       
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            [strongSelf.arr_content addObjectsFromArray:manger.imageList];
            [strongSelf.collectionView reloadData];
        }else{
            NSString *t_errString = [NSString stringWithFormat:@"网络错误:code:%ld msg:%@",manger.responseModel.code,manger.responseModel.msg];
            [LRShowHUD showError:t_errString duration:1.5 inView:strongSelf.view config:nil];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf,weakSelf);
        [strongSelf.collectionView.mj_header endRefreshing];

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
    VehicleTiredListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VehicleTiredListCellID" forIndexPath:indexPath];
    
    if (_arr_content && _arr_content.count > 0) {
        VehicleTiredImageModel *model = _arr_content[indexPath.row];
        cell.model = model;
    }
    
    return cell;
}

#pragma mark - UICollectionView Delegate method

//选中某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LxPrintf(@"选中 : %ld--%ld",(long)indexPath.section,(long)indexPath.item);

    VehicleTiredListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VehicleTiredListCellID" forIndexPath:indexPath];
    
    NSMutableArray *t_arr = [NSMutableArray array];
    VehicleTiredImageModel *model = _arr_content[indexPath.row];
    NSString *url = url = [model.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:cell.imageV_preview imageUrl:[NSURL URLWithString:url]];
    [t_arr addObject:item];
    
    KSPhotoBrowser *browser     = [KSPhotoBrowser browserWithPhotoItems:t_arr selectedIndex:0];
    [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
    [browser setDelegate:(id<KSPhotoBrowserDelegate> _Nullable)self];
    browser.dismissalStyle      = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle     = KSPhotoBrowserBackgroundStyleBlur;
    browser.loadingStyle        = KSPhotoBrowserImageLoadingStyleIndeterminate;
    browser.pageindicatorStyle  = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces             = NO;
    browser.isShowDeleteBtn     = NO;
    [browser showFromViewController:self];
    
    
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
    return CGSizeMake(width, 155);
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



#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
    LxPrintf(@"VehicleTiredAlarmVC dealloc");
    
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
