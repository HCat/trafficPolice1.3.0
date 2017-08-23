//
//  AccidentChangeVC.m
//  移动采集
//
//  Created by hcat on 2017/8/16.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AccidentChangeVC.h"
#import "AccidentAddFootView.h"
#import "BaseImageCollectionCell.h"

#import "AccidentAPI.h"

#import "NetWorkHelper.h"
#import "SRAlertView.h"

#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"

#import "ZLPhotoActionSheet.h"
#import "ZLPhotoModel.h"

#import "AccidentChangePhotoModel.h"

#import <UIImageView+WebCache.h>



@interface AccidentChangeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *arr_photos;    //图片数据，包括已经上传的图片还有新增图片

@property (nonatomic,strong) NSMutableArray *arr_delPhotos; //已经上传的图片的删除的图片

@property (nonatomic, strong) AccidentAddFootView *footView;

@property (nonatomic,assign) BOOL isFirstLoad;  //判断collectionView是不是第一次load

@property (nonatomic,assign) BOOL isObserver;   //判断是否添加了kvo监听,如果添加了不需要重复添加


@end

@implementation AccidentChangeVC

static NSString *const cellId = @"BaseImageCollectionCellID";
static NSString *const footId = @"AccidentAddFootViewID";
static NSString *const headId = @"AccidentAddHeadViewID";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (_accidentType == AccidentTypeAccident) {
        self.title = @"事故详情修改";
    }else if (_accidentType == AccidentTypeFastAccident){
        self.title = @"快处详情修改";
    }
    
    _arr_photos = [NSMutableArray array];
    _arr_delPhotos = [NSMutableArray array];
    
    if (self.picList && self.picList.count > 0 ) {
        
        for (AccidentPicListModel *t_model in self.picList) {
            
            AccidentChangePhotoModel * photo = [AccidentChangePhotoModel new];
            photo.modelId = @([_arr_photos count]);
            photo.picModel = t_model;
            [_arr_photos addObject:photo];
            
        }
    
    }
    
    [_collectionView registerClass:[BaseImageCollectionCell class] forCellWithReuseIdentifier:cellId];
    [_collectionView registerNib:[UINib nibWithNibName:@"AccidentAddFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footId];
    [_collectionView registerNib:[UINib nibWithNibName:@"AccidentAddHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headId];
    self.isFirstLoad = YES;
    self.isObserver = NO;
    
    [[ShareValue sharedDefault] accidentCodes];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        [[ShareValue sharedDefault] accidentCodes];
    };
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
    return [self.arr_photos count] + 1;
}
//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BaseImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.isNeedTitle = NO;
    
    if (indexPath.row == self.arr_photos.count) {
        cell.imageView.image = [UIImage imageNamed:@"btn_updatePhoto"];
    } else {
        AccidentChangePhotoModel *photo = _arr_photos[indexPath.row];
        
        if (photo.picModel) {
             [cell.imageView sd_setImageWithURL:[NSURL URLWithString:photo.picModel.imgUrl] placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
        }
        
        if (photo.photo) {
            cell.imageView.image = photo.photo;
        }
    
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        
        UICollectionReusableView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headId forIndexPath:indexPath];
        if(headerView == nil)
        {
            headerView = [[UICollectionReusableView alloc] init];
        }
        
        return headerView;
        
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        self.footView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footId forIndexPath:indexPath];
    
        PartyFactory *t_partyFactory = [PartyFactory new];
        t_partyFactory.param = self.param;
        
        _footView.partyFactory = t_partyFactory;
        
        _footView.isModificationStatus = YES;
        _footView.accidentType = _accidentType;
    
        if (!_isObserver && _footView.accidentType == AccidentTypeAccident) {
            [_footView addObserver:self forKeyPath:@"isShowMoreAccidentInfo" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
            [_footView addObserver:self forKeyPath:@"isShowMoreInfo" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
            self.isObserver = YES;
        }
        
        return _footView;
        
    }
    
    return nil;
}

#pragma mark - UICollectionView Delegate method


//选中某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _arr_photos.count) {
        
        [[self getPhotoActionSheet] showPhotoLibrary];
        
    } else {
        
        [self showPhotoBrowserWithIndex:indexPath.row];
        
    }
    
}

#pragma mark - UICollectionView Delegate FlowLayout

// cell 尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width=(self.view.bounds.size.width - 13.1f*2 - 13.0f*2)/3.f;
    return CGSizeMake(width, width);
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
    return (CGSize){ScreenWidth,32};
}


//footer底部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (_footView.isShowMoreAccidentInfo && _footView.isShowMoreInfo) {
        return (CGSize){ScreenWidth,1224-88-124};
    }else{
        if (_footView.isShowMoreAccidentInfo) {
            return (CGSize){ScreenWidth,1224-88};
        }else if(_footView.isShowMoreInfo){
            return (CGSize){ScreenWidth,1224-124};
        }
        
    }
    if (_isFirstLoad) {
        
        _isFirstLoad = NO;
        
        if (_accidentType == AccidentTypeAccident) {
            
            return (CGSize){ScreenWidth,1224-88-124};
            
        }else{
            
            return (CGSize){ScreenWidth,1224-88-124-24-20};
            
        }
        
    }else{
        
        if (_accidentType == AccidentTypeAccident) {
            
            return (CGSize){ScreenWidth,1224};
            
        }else{
            
            return (CGSize){ScreenWidth,1224-88-124-24-20};
            
        }
    }
    
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

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"isShowMoreAccidentInfo"] && object == _footView) {
        [_collectionView reloadData];
    }
    
    if ([keyPath isEqualToString:@"isShowMoreInfo"] && object == _footView) {
        [_collectionView reloadData];
    }
    
}


#pragma mark - 调用图片选择器

- (ZLPhotoActionSheet *)getPhotoActionSheet{
    
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.sortAscending = NO;
    actionSheet.allowSelectImage = YES;
    actionSheet.allowSelectGif = NO;
    actionSheet.allowSelectVideo = NO;
    actionSheet.allowSelectLivePhoto = NO;
    actionSheet.allowForceTouch = NO;
    actionSheet.allowEditImage = NO;
    actionSheet.allowTakePhotoInLibrary = YES;
    actionSheet.showCaptureImageOnTakePhotoBtn = YES;
    //设置照片最大预览数
    actionSheet.maxPreviewCount = kmaxPreviewCount;
    actionSheet.maxSelectCount = kmaxSelectCount;
    actionSheet.cellCornerRadio = 0;
    actionSheet.showSelectBtn = NO;
    actionSheet.sender = self;
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (AccidentChangePhotoModel *photo in _arr_photos) {
        if (photo.asset) {
            if (photo.asset.mediaType == PHAssetMediaTypeImage) {
                [arr addObject:photo.asset];
            }
        }
    }
    
    actionSheet.arrSelectedAssets =  actionSheet.maxSelectCount > 1 ? arr : nil;
    
    WS(weakSelf);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        SW(strongSelf, weakSelf);
        
        strongSelf.footView.arr_photes = images;
        
        for (NSInteger i = strongSelf.arr_photos.count - 1; i >= 0; i--) {
            AccidentChangePhotoModel *photo  = strongSelf.arr_photos[i];
            if (photo.photo) {
                [strongSelf.arr_photos removeObject:photo];
            }
        }
        
        for (int i = 0 ; i < [images count] ; i++) {
            
            UIImage *t_image = images[i];
            PHAsset *t_asset = assets[i];
            AccidentChangePhotoModel *photo = [AccidentChangePhotoModel new];
            photo.modelId = @([_arr_photos count]);
            photo.photo = t_image;
            photo.asset = t_asset;
            [strongSelf.arr_photos addObject:photo];
        }
        
        [strongSelf.collectionView reloadData];
        
        LxPrintf(@"image:%@", images);
    }];
    
    return actionSheet;
}

#pragma mark - 调用图片浏览器

-(void)showPhotoBrowserWithIndex:(NSInteger)index{
    
    //将arr_upImages中有图片的赋值到t_arr中用于LLPhotoBrowser中
    
    NSMutableArray *t_arr = [NSMutableArray array];
    
    for (int i = 0; i < [_arr_photos count]; i++) {
        
        BaseImageCollectionCell *cell = (BaseImageCollectionCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    
        AccidentChangePhotoModel *photo = _arr_photos[i];

        if (photo.picModel) {
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:cell.imageView imageUrl:[NSURL URLWithString:photo.picModel.imgUrl] withPhotoModel:photo];
            [t_arr addObject:item];
        }
        
        if (photo.photo) {
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:cell.imageView image:photo.photo withPhotoModel:photo];
            [t_arr addObject:item];

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

#pragma mark - 图片浏览器Delegate

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didDeleteItem:(KSPhotoItem *)item{
    
    AccidentChangePhotoModel * photo = item.photo;
    
    if ([photo isUploadImage]) {
        [_arr_delPhotos addObject:photo.picModel.picId];
    }
    
    _footView.partyFactory.param.delImageIds = [_arr_delPhotos componentsJoinedByString:@","];
    
    [_arr_photos removeObject:photo];
    
    NSMutableArray *t_arr = [NSMutableArray array];
    for (AccidentChangePhotoModel *t_model in _arr_photos) {
        if (![t_model isUploadImage]) {
            
            [t_arr addObject:t_model.photo];
        }
    }
    
    self.footView.arr_photes = [t_arr copy];
    
    [_collectionView reloadData];
    
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    LxPrintf(@"AccidentChangeVC dealloc");
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
    
    @try {
        [_footView removeObserver:self forKeyPath:@"isShowMoreAccidentInfo"];
        [_footView removeObserver:self forKeyPath:@"isShowMoreInfo"];
    }
    @catch (NSException *exception) {
        LxPrintf(@"多次删除了");
    }
    
}


@end
