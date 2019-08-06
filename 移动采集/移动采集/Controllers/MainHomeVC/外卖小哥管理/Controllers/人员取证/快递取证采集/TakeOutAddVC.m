//
//  TakeOutAddVC.m
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutAddVC.h"
#import "BaseImageCollectionCell.h"
#import "TakeOutAddHeadView.h"
#import "IllegalParkAddFootView.h"

#import "NetWorkHelper.h"

#import "LRCameraVC.h"
#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"

@interface TakeOutAddVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak)   IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) TakeOutAddHeadView *headView;
@property (nonatomic,strong) IllegalParkAddFootView *footView;

@property(nonatomic, strong) TakeOutAddViewModel * viewModel;


@end

@implementation TakeOutAddVC

- (instancetype)initWithViewModel:(TakeOutAddViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel];
    
    [[ShareValue sharedDefault] deliveryCompanyList];
    [self.viewModel.command_illegalList execute:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    @weakify(self);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        @strongify(self);
        [[ShareValue sharedDefault] deliveryCompanyList];
        [self.viewModel.command_illegalList execute:nil];
    };
    
#ifdef __IPHONE_11_0
    if (IS_IPHONE_X_MORE == NO) {
        if ([_collectionView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
#endif
    
}

#pragma mark - configUI

- (void)configUI{
    self.title = @"外卖违法录入";
    
    //注册collection格式
    [_collectionView registerClass:[BaseImageCollectionCell class] forCellWithReuseIdentifier:@"BaseImageCollectionCellID"];
    [_collectionView registerNib:[UINib nibWithNibName:@"IllegalParkAddFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"TakeOutAddFootViewID"];
    [_collectionView registerNib:[UINib nibWithNibName:@"TakeOutAddHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TakeOutAddHeadViewID"];
    
    
    
    
}

#pragma mark - bindViewModel
- (void)bindViewModel{
    
    @weakify(self);
   
    [RACObserve(self.viewModel, isCanCommit) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [RACObserve(self.viewModel, isCanCommit) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if ([x boolValue]) {
                self.footView.btn_commit.enabled = YES;
                [self.footView.btn_commit setBackgroundColor:DefaultBtnColor];
                
            }else{
                self.footView.btn_commit.enabled = NO;
                [self.footView.btn_commit setBackgroundColor:DefaultBtnNuableColor];
                
            }
            
        }];
        
    }];
    
    [self.viewModel.command_commit.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.block) {
            self.block();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [self.viewModel.command_illegalList.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        if ([x isEqualToString:@"加载成功"]) {
            if (self.headView) {
                self.headView.deliveryIllegalList = self.viewModel.deliveryIllegalList;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
                
            }
        }
    
    }];
    
    
    
}

#pragma mark - UICollectionView Data Source

//返回多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView   *)collectionView{
    return 1;
}

//返回每组多少个视图
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.viewModel.arr_upImages count] + 1;
}

//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BaseImageCollectionCellID" forIndexPath:indexPath];
    
    [cell setCommonConfig];
    
    if (indexPath.row == self.viewModel.arr_upImages.count) {
        
        cell.lb_title.text = @"违法照片";
        cell.imageView.image = [UIImage imageNamed:@"btn_updatePhoto"];
    }else{
        
        cell.lb_title.text = [NSString stringWithFormat:@"违法照片%ld",indexPath.row+1];
        
        NSMutableDictionary *t_dic = self.viewModel.arr_upImages[indexPath.row];
        ImageFileInfo *imageInfo = [t_dic objectForKey:@"files"];
        if (imageInfo) {
            cell.imageView.image = imageInfo.image;
        }
        
    }
    
    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        self.headView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TakeOutAddHeadViewID" forIndexPath:indexPath];
        _headView.param = self.viewModel.param;
        
        return _headView;
        
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        self.footView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TakeOutAddFootViewID" forIndexPath:indexPath];
        [_footView setDelegate:(id<IllegalParkAddFootViewDelegate>)self];
        
        return _footView;
        
    }
    
    return nil;
}

#pragma mark - UICollectionView Delegate method

//选中某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    
    if (indexPath.row == self.viewModel.arr_upImages.count) {
        
        [self showCameraWithType:5 withFinishBlock:^(LRCameraVC *camera) {
            if (camera) {
                @strongify(self);
                if (camera.type == 5) {
                    [self.viewModel addUpImageItemToUpImagesWithImageInfo:camera.imageInfo];
                    [self.collectionView reloadData];
                }
            }
        } isNeedRecognition:NO];
        
    }else {
        [self showPhotoBrowserWithIndex:indexPath.row];
    }
    
}

#pragma mark - UICollectionView Delegate FlowLayout

// cell 尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width=(self.view.bounds.size.width - 13.1f*2 - 13.0f*2)/3.f;
    return CGSizeMake(width, width+27);
}

// 装载内容 cell 的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(13, 13, 13, 13);
}

//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 13.0f;
}

//item最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 13.0f;
}

//header头部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.viewModel.deliveryIllegalList && self.viewModel.deliveryIllegalList.count > 0) {
       NSInteger index =  self.viewModel.deliveryIllegalList.count/4 + (self.viewModel.deliveryIllegalList.count%4 != 0 ? 1 : 0);
        CGFloat height = 30 * index + 15 * (index + 1);
        return (CGSize){ScreenWidth,242 + height};
    }else{
        return (CGSize){ScreenWidth,272};
    }
}


//footer底部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return (CGSize){ScreenWidth,75};
    
}



#pragma mark - scrollViewDelegate

//用于滚动到顶部的时候使得tableView不能再继续下拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _collectionView){
        if (scrollView.contentOffset.y < 0) {
            CGPoint position = CGPointMake(0, 0);
            [scrollView setContentOffset:position animated:NO];
            return;
        }
    }
}

#pragma mark - 弹出照相机

-(void)showCameraWithType:(NSInteger)type withFinishBlock:(void(^)(LRCameraVC *camera))finishBlock isNeedRecognition:(BOOL)isNeedRecognition{
    
    LRCameraVC *home = [[LRCameraVC alloc] init];
    home.type = type;
    home.isIllegal = isNeedRecognition;
    home.fininshCaptureBlock = finishBlock;
    [self presentViewController:home
                       animated:YES
                     completion:^{
                     }];
    
}


#pragma mark - 调用图片浏览器

-(void)showPhotoBrowserWithIndex:(NSInteger)index{
    
    //将arr_upImages中有图片的赋值到t_arr中用于LLPhotoBrowser中
    
    NSMutableArray *t_arr = [NSMutableArray array];
    
    for (int i = 0; i < [self.viewModel.arr_upImages count]; i++) {
        
        if ([self.viewModel.arr_upImages[i] isKindOfClass:[NSMutableDictionary class]]) {
            
            BaseImageCollectionCell *cell = (BaseImageCollectionCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            NSDictionary *t_dic = [NSDictionary dictionaryWithDictionary:self.viewModel.arr_upImages[i]];
            ImageFileInfo *info = t_dic[@"files"];
            if (info) {
                KSPhotoItem *item = [KSPhotoItem itemWithSourceView:cell.imageView image:info.image withDic:t_dic];
                [t_arr addObject:item];
            }
        }
        
    }
    
    KSPhotoBrowser *browser     = [KSPhotoBrowser browserWithPhotoItems:t_arr selectedIndex:index];
    [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
    [browser setDelegate:(id<KSPhotoBrowserDelegate> _Nullable)self];
    browser.dismissalStyle      = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle     = KSPhotoBrowserBackgroundStyleBlur;
    browser.loadingStyle        = KSPhotoBrowserImageLoadingStyleIndeterminate;
    browser.pageindicatorStyle  = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces             = NO;
    browser.isShowDeleteBtn     = YES;
    [browser showFromViewController:self];
    
}

#pragma mark - KSPhotoBrowserDelegate

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didDeleteItem:(KSPhotoItem *)item{
    
    NSDictionary *itemDic = item.illegalDic;
    
    for (int i = 0; i < [self.viewModel.arr_upImages count]; i++) {
        
        if ([self.viewModel.arr_upImages[i] isKindOfClass:[NSMutableDictionary class]]) {
            
            NSMutableDictionary *t_dic = self.viewModel.arr_upImages[i];
            
            NSString *t_str = [t_dic objectForKey:@"remarks"];
            
            if ([t_str isEqualToString:[itemDic objectForKey:@"remarks"]]) {
                
                [self.viewModel.arr_upImages removeObject:t_dic];
                
                [self.collectionView reloadData];
            
            }
            
        }
        
    }
    
}

#pragma mark - FootViewDelegate 点击提交按钮事件

- (void)handleCommitClicked{
    
    [NetworkStatusMonitor StartWithBlock:^(NSInteger NetworkStatus) {
        
        //大类 : 0没有网络 1为WIFI网络 2/6/7为2G网络  3/4/5/8/9/11/12为3G网络
        //10为4G网络
        [NetworkStatusMonitor StopMonitor];
        
        if (NetworkStatus != 10 && NetworkStatus != 1) {
            //[strongSelf showIllegalNetErrorView];
            [ShareFun showTipLable:@"当前非4G网络,传输速度受影响"];
            
        }else{
            //提交违章数据
            
        }
        
    }];
    
    [self submitIllegalData];
    
    
}

- (void)submitIllegalData{
    
    [self.viewModel configParamInFilesAndRemarksAndTimes];
    
    LxDBObjectAsJson(self.viewModel.param);
    
    [self.viewModel.command_commit execute:nil];
}


#pragma mark - dealloc

- (void)dealloc{
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
    
    LxPrintf(@"TakeOutAddVC dealloc");
}

@end
