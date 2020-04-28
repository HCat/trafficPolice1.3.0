//
//  ElectronicImageVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/4/27.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ElectronicImageVC.h"
#import <MJRefresh.h>
#import "UICollectionView+Lr_Placeholder.h"
#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"
#import <UIImageView+WebCache.h>
#import "NetWorkHelper.h"


@interface ElectronicImageVC ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) ElectronicImageViewModel * viewModel;

@end

@implementation ElectronicImageVC

- (instancetype)initWithViewModel:(ElectronicImageViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self bindViewModel];

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


- (void)configUI{
    
    self.title = @"图片";
    
    _collectionView.isNeedPlaceholderView = YES;
    _collectionView.firstReload = YES;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((self.view.frame.size.width - 40) / 3, (self.view.frame.size.width - 40) / 3);
    layout.minimumLineSpacing = 10.0; // 竖
    layout.minimumInteritemSpacing = 0.0; // 横
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _collectionView.collectionViewLayout = layout;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    
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




- (void)bindViewModel{
    
    @weakify(self);
    [self.viewModel.command_image.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if ([x isEqualToString:@"加载成功"]) {
            [self.collectionView.mj_header endRefreshing];
            
        }else{
            Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
            NetworkStatus status = [reach currentReachabilityStatus];
            if (status == NotReachable) {
                if (self.viewModel.arr_upImages.count > 0) {
                    [self.viewModel.arr_upImages removeAllObjects];
                }
                self.collectionView.isNetAvailable = YES;
                [self.collectionView reloadData];
            }
            
        }
        
        [self.collectionView reloadData];
        
    }];
    
    
}

//返回多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView   *)collectionView
{
    return 1;
}
//返回每组多少个视图
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.viewModel.arr_upImages.count;
}
//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    UIImageView *imageV = [[UIImageView alloc] init];
    CGRect imageFrame = imageV.frame;
    imageFrame.size = CGSizeMake((self.view.frame.size.width - 40) / 3, (self.view.frame.size.width - 40) / 3);;
    imageV.frame = imageFrame;
    ElectronicImageModel *model = self.viewModel.arr_upImages[indexPath.row];
    NSString *url = [model.imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
    imageV.tag = 1101;
    [cell.contentView addSubview:imageV];
    return cell;
}

#pragma mark - UICollectionView Delegate method

//选中某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LxPrintf(@"选中 : %ld--%ld",(long)indexPath.section,(long)indexPath.item);

     UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
    NSMutableArray *t_arr = [NSMutableArray array];
    ElectronicImageModel *model = self.viewModel.arr_upImages[indexPath.row];
    NSString *url = [model.imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    UIImageView * imageView = [cell viewWithTag:1101];
    
    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:url]];
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


- (void)loadData{
    
    [self.viewModel.command_image execute:nil];
    
}


#pragma mark - dealloc

- (void)dealloc{
    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
    LxPrintf(@"%@-dealloc",[self class]);
}

@end
