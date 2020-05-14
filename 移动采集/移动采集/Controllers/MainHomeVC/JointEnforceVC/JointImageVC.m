//
//  JointImageVC.m
//  移动采集
//
//  Created by hcat on 2018/1/15.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "JointImageVC.h"
#import "BaseImageCollectionCell.h"
#import "ZLPhotoActionSheet.h"
#import "ZLPhotoModel.h"
#import <PureLayout.h>


@interface JointImageVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *v_bottom;
@property (weak, nonatomic) IBOutlet UIButton *btn_bottom;

@property (nonatomic,strong)  NSMutableArray *arr_photos;
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;



@end

@implementation JointImageVC

static NSString *const cellId = @"BaseImageCollectionCellID";

#pragma mark - viewLife

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"添加图片";
    self.view.backgroundColor = [UIColor whiteColor];
     [_collectionView registerClass:[BaseImageCollectionCell class] forCellWithReuseIdentifier:cellId];

    _v_bottom.layer.shadowColor = UIColorFromRGB(0x444444).CGColor;//shadowColor阴影颜色
    _v_bottom.layer.shadowOffset = CGSizeMake(0,-2);
    _v_bottom.layer.shadowOpacity = 0.1;
    _v_bottom.layer.shadowRadius = 2;
    
    _btn_bottom.enabled = NO;
    [_btn_bottom setBackgroundColor:DefaultBtnNuableColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
#ifdef __IPHONE_11_0
    if (IS_IPHONE_X_MORE == NO) {
        if ([_collectionView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
#endif

}

#pragma mark - initPhotoActionSheet

- (ZLPhotoActionSheet *)getPhotoActionSheet
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.configuration.sortAscending = NO;
    actionSheet.configuration.allowSelectImage = YES;
    actionSheet.configuration.allowSelectGif = NO;
    actionSheet.configuration.allowSelectVideo = NO;
    actionSheet.configuration.allowSelectLivePhoto = NO;
    actionSheet.configuration.allowForceTouch = NO;
    actionSheet.configuration.allowEditImage = NO;
    actionSheet.configuration.allowTakePhotoInLibrary = YES;
    actionSheet.configuration.showCaptureImageOnTakePhotoBtn = YES;
    //设置照片最大预览数
    actionSheet.configuration.maxPreviewCount = 9;
    actionSheet.configuration.maxSelectCount = 9;
    actionSheet.configuration.cellCornerRadio = 0;
    actionSheet.configuration.showSelectBtn = NO;
    
    actionSheet.sender = self;
    
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for (PHAsset *asset in self.lastSelectAssets) {
        if (asset.mediaType == PHAssetMediaTypeImage) {
            [arr addObject:asset];
        }
    }
    actionSheet.arrSelectedAssets =  actionSheet.configuration.maxSelectCount > 1 ? arr : nil;
    
    WS(weakSelf);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        SW(strongSelf, weakSelf);
        strongSelf.arr_photos          = images.mutableCopy;
        strongSelf.lastSelectAssets = assets.mutableCopy;
        strongSelf.lastSelectPhotos = images.mutableCopy;
        [strongSelf.collectionView reloadData];
        [self judgeCanComit];
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
    if ([self.arr_photos count] >= 9) {
        return 9;
    }else{
        return [self.arr_photos count] + 1;
    }
    
}

//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BaseImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.isNeedTitle = NO;
    
    if (indexPath.row == self.arr_photos.count && self.arr_photos.count < 9) {
        cell.imageView.image = [UIImage imageNamed:@"btn_jointImageAdd"];
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.imageView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        cell.btn_delete.hidden = YES;
    } else {
        cell.imageView.image = _arr_photos[indexPath.row];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageView.layer.borderWidth = 0.5f;
        cell.imageView.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = 0.f;
        cell.btn_delete.hidden = NO;
        cell.btn_delete.tag = indexPath.row;
        [cell.btn_delete addTarget:self action:@selector(handleBtnDeleteImageClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    return nil;
}


#pragma mark - UICollectionView Delegate method


//选中某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _arr_photos.count) {
        [[self getPhotoActionSheet] showPhotoLibrary];
    }else{
        [[self getPhotoActionSheet] previewSelectedPhotos:self.lastSelectPhotos assets:self.lastSelectAssets index:indexPath.row isOriginal:NO];
    }
    
}


#pragma mark - UICollectionView Delegate FlowLayout

// cell 尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width=(self.view.bounds.size.width - 29.1f*2 - 13.0f*2)/3.f;
    return CGSizeMake(width, width);
}

// 装载内容 cell 的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 29, 0, 29);
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

#pragma mark - 删除图片

- (void)handleBtnDeleteImageClicked:(id)sender{
    UIButton *t_btn = (UIButton *)sender;
    NSInteger tag = t_btn.tag;
    
    [_arr_photos enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(tag == idx){
            *stop = YES;
            [_arr_photos removeObject:obj];
        }
    }];
    
    [_lastSelectAssets enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(tag == idx){
            *stop = YES;
            [_lastSelectAssets removeObject:obj];
        }
    }];
    
    [_lastSelectPhotos enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(tag == idx){
            *stop = YES;
            [_lastSelectPhotos removeObject:obj];
        }
    }];
    
    [_collectionView reloadData];
    
    [self judgeCanComit];
}

#pragma mark - KVO

- (void)judgeCanComit{
        
    if (_arr_photos.count == 0) {
        _btn_bottom.enabled = NO;
        [_btn_bottom setBackgroundColor:DefaultBtnNuableColor];
    }else{
        _btn_bottom.enabled = YES;
        [_btn_bottom setBackgroundColor:DefaultBtnColor];
    }
}


#pragma mark - 提交按钮事件

- (IBAction)handleBtnComitClicked:(id)sender{
    
    WS(weakSelf);
    
    NSMutableArray *t_arr = [NSMutableArray array];
    for (UIImage *t_image in _arr_photos) {
        ImageFileInfo *t_imageFileInfo = [[ImageFileInfo alloc] initWithImage:t_image withName:key_files];
        [t_arr addObject:t_imageFileInfo];
    }
    
    JointLawImgUploadManger * manager = [[JointLawImgUploadManger alloc] init];
    manager.files = t_arr;
    if (_oldIds) {
        manager.oldImgIds = [_oldIds componentsJoinedByString:@","];  ;
    }else{
        manager.oldImgIds = @"";
    }
    
    [manager configLoadingTitle:@"上传"];
    
    [manager startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        
        if (manager.responseModel.code == CODE_SUCCESS) {
            
            strongSelf.block(manager.list);
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
    
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        
    }];
    
    
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


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    NSLog(@"JointImageVC dealloc");
    
}

@end
