//
//  FeedbackVC.m
//  移动采集
//
//  Created by hcat on 2017/7/25.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "FeedbackVC.h"
#import "BaseImageCollectionCell.h"
#import "FeedbackHeadView.h"
#import "FeedbackFootView.h"

#import "ImageFileInfo.h"

#import "CommonAPI.h"

#import "ZLPhotoActionSheet.h"
#import <Photos/Photos.h>

@interface FeedbackVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) FeedbackHeadView *headView;
@property (nonatomic, strong) FeedbackFootView *footView;
@property (weak, nonatomic)   IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *arr_photos;
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;

@property (nonatomic,assign) BOOL isObserver;   //用于注册isCanCommit的KVC,如果注册了设置YES，防止重复注册

@end

@implementation FeedbackVC

static NSString *const cellId = @"BaseImageCollectionCell";
static NSString *const headId = @"FeedbackHeadViewID";
static NSString *const footId = @"FeedbackFootViewID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.isObserver = NO;
    
    [_collectionView registerClass:[BaseImageCollectionCell class] forCellWithReuseIdentifier:cellId];
    [_collectionView registerNib:[UINib nibWithNibName:@"FeedbackHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headId];
    [_collectionView registerNib:[UINib nibWithNibName:@"FeedbackFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footId];
    
    
}

#pragma mark - set && get 

- (void)setArr_photos:(NSArray<UIImage *> *)arr_photos{

    if (arr_photos) {
        
        NSMutableArray *t_arr = [NSMutableArray array];
        for (UIImage *t_image in arr_photos) {
            ImageFileInfo *t_imageFileInfo = [[ImageFileInfo alloc] initWithImage:t_image withName:key_files];
            [t_arr addObject:t_imageFileInfo];
        }
        _arr_photos = t_arr;
        
    }

}

#pragma mark - 提交请求

- (void)feedbackNetworkRequest{

    WS(weakSelf);
    CommonAdviceParam * param = [[CommonAdviceParam alloc] init];
    param.msg = _headView.textView.text;
    param.files = _arr_photos;

    CommonAdviceManger * manger = [[CommonAdviceManger alloc] init];
    manger.param = param;
    [manger configLoadingTitle:@"提交"];
   
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
       
        
    }];

}

#pragma mark - 图片选择器

- (ZLPhotoActionSheet *)getPhotoActionSheet
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.sortAscending = NO;
    actionSheet.allowSelectImage = YES;
    actionSheet.allowSelectGif = NO;
    actionSheet.allowSelectVideo = NO;
    actionSheet.allowSelectLivePhoto = NO;
    actionSheet.allowForceTouch = NO;
    actionSheet.allowEditImage = NO;
    //设置相册内部显示拍照按钮
    actionSheet.allowTakePhotoInLibrary = YES;
    //设置在内部拍照按钮上实时显示相机俘获画面
    actionSheet.showCaptureImageOnTakePhotoBtn = YES;
    //设置照片最大预览数
    actionSheet.maxPreviewCount = kmaxPreviewCount;
    //设置照片最大选择数
    actionSheet.maxSelectCount = kmaxSelectCount;
    
    actionSheet.cellCornerRadio = 0;
    //单选模式是否显示选择按钮
    actionSheet.showSelectBtn = NO;
    
    //如果调用的方法没有传sender，则该属性必须提前赋值
    actionSheet.sender = self;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (PHAsset *asset in self.lastSelectAssets) {
        if (asset.mediaType == PHAssetMediaTypeImage) {
            
            [arr addObject:asset];
        }
    }
    actionSheet.arrSelectedAssets = actionSheet.maxSelectCount > 1 ? arr : nil;
    
    WS(weakSelf);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        SW(strongSelf, weakSelf);
        strongSelf.arr_photos = images;
        strongSelf.lastSelectAssets = assets.mutableCopy;
        strongSelf.lastSelectPhotos = images.mutableCopy;
        [strongSelf.collectionView reloadData];
        
    }];
    
     return actionSheet;
    
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
    
    if (indexPath.row == self.arr_photos.count) {
        [cell setMoreImageView];
        
    } else {
        cell.isNeedTitle = NO;
        cell.layer.cornerRadius = 5.0f;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        ImageFileInfo *imageInfo = _arr_photos[indexPath.row];
        cell.imageView.image = imageInfo.image;
        
    }
    
    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        self.headView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headId forIndexPath:indexPath];
        if (!_isObserver) {
            [_headView addObserver:self forKeyPath:@"isCanCommit" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
            self.isObserver = YES;
            
        }
        return _headView;
        
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        WS(weakSelf);
        self.footView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footId forIndexPath:indexPath];
        _footView.handleCommitBlock = ^{
            SW(strongSelf, weakSelf);
            [strongSelf feedbackNetworkRequest];
            
        };
        return _footView;
        
    }
    
    return nil;
}

#pragma mark - UICollectionView Delegate method

//选中某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLPhotoActionSheet *sheet = [self getPhotoActionSheet];
    if (indexPath.row == _arr_photos.count) {
        [sheet showPhotoLibrary];
    
    }else{
        [sheet previewSelectedPhotos:self.lastSelectPhotos assets:self.lastSelectAssets index:indexPath.row];
        
    }
}

#pragma mark - UICollectionView Delegate FlowLayout

// cell 尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width=(self.view.bounds.size.width - 15.1f*2 - 15.0f*2)/3.f;
    return CGSizeMake(width, width);
}

// 装载内容 cell 的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(13, 15, 20, 15);
}

//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0f;
}

//item最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0f;
}

//header头部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return (CGSize){ScreenWidth,234};
}


//footer底部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return (CGSize){ScreenWidth,110};
    
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

#pragma mark - KVO,监听看是否可以提交，用于提交按钮是否可以点击

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"isCanCommit"] && object == _headView) {
        _footView.isCanCommit = _headView.isCanCommit;
    }
    
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    @try {

        [_headView removeObserver:self forKeyPath:@"isCanCommit"];
    }
    @catch (NSException *exception) {
        LxPrintf(@"多次删除了");
    }
    LxPrintf(@"FeedbackVC dealloc");

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
