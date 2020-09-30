//
//  IllegalSecAddVC.m
//  移动采集
//
//  Created by hcat-89 on 2020/2/19.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "IllegalSecAddVC.h"

#import "AccidentAddHeadView.h"
#import "BaseImageCollectionCell.h"
#import "IllegalParkAddFootView.h"
#import "IllegalThroughSecAddView.h"


#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"
#import <UIImageView+WebCache.h>
#import "SRAlertView.h"
#import "NetWorkHelper.h"
#import "ParkCameraVC.h"


@interface IllegalSecAddVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IllegalParkAddFootView *footView;

@property(nonatomic, strong) IllegalSecAddViewModel * viewModel;

@end

@implementation IllegalSecAddVC

- (instancetype)initWithViewModel:(IllegalSecAddViewModel *)viewModel{
    
    if (self = [super init]) {
           self.viewModel = viewModel;
       }
       
       return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self bindViewModel];
    
    [self.viewModel.command_load execute:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
#ifdef __IPHONE_11_0
    if (IS_IPHONE_X_MORE == NO) {
        if ([_collectionView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    @weakify(self);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        @strongify(self);
        if (!self.viewModel.secDetailModel) {
            [self.viewModel.command_load execute:nil];
        }
    };
#endif
    
}

#pragma mark - 返回事件

-(void)handleBtnBackClicked{
    
    SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"是否退出二次采集"
                                                leftActionTitle:@"取消"
                                               rightActionTitle:@"确定"
                                                 animationStyle:AlertViewAnimationNone
                                                   selectAction:^(AlertViewActionType actionType) {
                                                       if (actionType == AlertViewActionTypeRight) {
                                                           [self.navigationController popToRootViewControllerAnimated:YES];
                                                           
                                                       }
                                                   }];
    alertView.blurCurrentBackgroundView = NO;
    [alertView show];
    
}


#pragma mark - configUI

- (void)configUI{
    self.title = @"违章二次采集";
    
    //注册collection格式
    [_collectionView registerNib:[UINib nibWithNibName:@"IllegalThroughSecAddView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"IllegalSecAddHeadViewID"];
    [_collectionView registerClass:[BaseImageCollectionCell class] forCellWithReuseIdentifier:@"BaseImageCollectionCellID"];
    [_collectionView registerNib:[UINib nibWithNibName:@"IllegalParkAddFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"IllegalSecAddFootViewID"];
    [_collectionView registerNib:[UINib nibWithNibName:@"AccidentAddHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AccidentAddHeadViewID"];
    
    @weakify(self);
    
    [self zx_leftClickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
        @strongify(self);
        [self handleBtnBackClicked];
    }];
    
}

#pragma mark - bindViewModel
- (void)bindViewModel{

    @weakify(self);
    
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
    
    [self.viewModel.command_add.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
    
        if ([x isEqualToString:@"提交成功"]) {
        
            [self.navigationController popViewControllerAnimated:YES];
             if (self.saveSuccessBlock) {
                 self.saveSuccessBlock();
             }
            
        }
        
    }];
    
    [self.viewModel.command_load.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
    
        if ([x isEqualToString:@"加载成功"]) {
            [self.collectionView reloadData];
        }
        
    }];
    
}

#pragma mark - UICollectionView Data Source

//返回多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

//返回每组多少个视图
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.viewModel.secDetailModel && self.viewModel.secDetailModel.pictures && self.viewModel.secDetailModel.pictures.count > 0) {
            return self.viewModel.secDetailModel.pictures.count;
        }

        return 0;
        
    }else{
        
        return [self.viewModel.arr_upImages count] + 1;
    }
    
}

//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BaseImageCollectionCellID" forIndexPath:indexPath];
    
    [cell setCommonConfig];
    cell.lb_title.textColor = UIColorFromRGB(0xe6504a);
    
    if (indexPath.section == 0) {
        
        AccidentPicListModel *t_model = self.viewModel.secDetailModel.pictures[indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:t_model.imgUrl] placeholderImage:[UIImage imageNamed:@"btn_updatePhoto"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            t_model.picImage = image;
        }];
        cell.lb_title.text = [ShareFun timeWithTimeInterval:t_model.uploadTime dateFormat:@"HH:mm:ss"];
        
    }else{
    
        if (indexPath.row == self.viewModel.arr_upImages.count) {
            
            cell.imageView.image = [UIImage imageNamed:@"btn_updatePhoto"];
            
        }else{
            
            if (self.viewModel.arr_upImages){
                
                NSMutableDictionary *t_dic = self.viewModel.arr_upImages[indexPath.row];
                ImageFileInfo *imageInfo = [t_dic objectForKey:@"files"];
                cell.imageView.image = imageInfo.image;
                cell.lb_title.text = nil;
                
            }
        
        }
        
    }
    
    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if([kind isEqualToString:UICollectionElementKindSectionHeader])
        {
        
            IllegalThroughSecAddView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"IllegalSecAddHeadViewID" forIndexPath:indexPath];
            if (self.viewModel.secDetailModel) {
                headerView.carNumber = self.viewModel.secDetailModel.illegalCollect.carNo;
                headerView.roadName = self.viewModel.secDetailModel.roadName;
            }
            
            return headerView;
            
                      
        }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
            
        }
        
    } else {
        
        if([kind isEqualToString:UICollectionElementKindSectionHeader])
        {
            AccidentAddHeadView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"AccidentAddHeadViewID" forIndexPath:indexPath];
            headerView.lb_title.text = @"二次采集照片";
            
            return headerView;
            
        }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
            
            self.footView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"IllegalSecAddFootViewID" forIndexPath:indexPath];
            
            [_footView setDelegate:(id<IllegalParkAddFootViewDelegate>)self];
            

            return _footView;
            
        }
        
    }
    
    return nil;
}

#pragma mark - UICollectionView Delegate method

//选中某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    
    if (indexPath.section == 0) {
        
        NSMutableArray *t_arr = [NSMutableArray array];
        
        if (self.viewModel.secDetailModel && self.viewModel.secDetailModel.pictures.count > 0) {
            
            for (int i = 0; i < self.viewModel.secDetailModel.pictures.count; i++) {
                
                NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
                BaseImageCollectionCell *currentCell = (BaseImageCollectionCell *)[_collectionView cellForItemAtIndexPath:currentIndexPath];
                AccidentPicListModel *t_model = self.viewModel.secDetailModel.pictures[i];
                KSPhotoItem *item = [KSPhotoItem itemWithSourceView:currentCell.imageView imageUrl:[NSURL URLWithString:t_model.imgUrl]];
                [t_arr addObject:item];
            }

        }
    
        KSPhotoBrowser *browser     = [KSPhotoBrowser browserWithPhotoItems:t_arr selectedIndex:indexPath.row];
        [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
        [browser setDelegate:(id<KSPhotoBrowserDelegate> _Nullable)self];
        browser.dismissalStyle      = KSPhotoBrowserInteractiveDismissalStyleScale;
        browser.backgroundStyle     = KSPhotoBrowserBackgroundStyleBlur;
        browser.loadingStyle        = KSPhotoBrowserImageLoadingStyleIndeterminate;
        browser.pageindicatorStyle  = KSPhotoBrowserPageIndicatorStyleText;
        browser.bounces             = NO;
        browser.isShowDeleteBtn     = NO;
        [browser showFromViewController:self];

    } else {
        
        if (indexPath.row == self.viewModel.arr_upImages.count) {
            [self showCameraWithType:2 withFinishBlock:^(ImageFileInfo *imageFileInfo) {
                SW(strongSelf, weakSelf);
                if (imageFileInfo) {
                    [strongSelf.viewModel addUpImageItemToUpImagesWithImageInfo:imageFileInfo];
                    [strongSelf.collectionView reloadData];
                }
                
            }];
            
        }else {
            [self showPhotoBrowserWithIndex:indexPath.row];
        }
        
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
    
    if (section == 0) {
        return (CGSize){ScreenWidth,100};
    }else{
        return (CGSize){ScreenWidth,32};
    }
    
}


//footer底部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return (CGSize){0,0};
    }else{
        return (CGSize){ScreenWidth,75};
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

#pragma mark - FootViewDelegate 点击提交按钮事件

- (void)handleCommitClicked{
    
    [NetworkStatusMonitor StartWithBlock:^(NSInteger NetworkStatus) {
        
        //大类 : 0没有网络 1为WIFI网络 2/6/7为2G网络  3/4/5/8/9/11/12为3G网络
        //10为4G网络
        [NetworkStatusMonitor StopMonitor];
        
        if (NetworkStatus != 10 && NetworkStatus != 1) {
            [ShareFun showTipLable:@"当前非4G网络,传输速度受影响"];
        }else{
            //提交违章数据
            //[strongSelf submitIllegalData];
        }
        
    }];
    
    [self.viewModel configParamInFilesAndRemarksAndTimes];
    [self.viewModel.command_add execute:nil];

}


#pragma mark - 弹出照相机

-(void)showCameraWithType:(NSInteger)type withFinishBlock:(void(^)(ImageFileInfo * imageInfo))finishBlock{
    
    ParkCameraVC *home = [[ParkCameraVC alloc] init];
    home.type = type;
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
                self.viewModel.count = self.viewModel.arr_upImages.count;
                [self.collectionView reloadData];
                
                break;
            }
            
        }
        
    }
    
}



#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"IllegalSecAddVC dealloc");
}

@end
