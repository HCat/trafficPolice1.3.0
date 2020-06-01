//
//  IllegalAddVC.m
//  移动采集
//
//  Created by hcat-89 on 2020/2/15.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "IllegalAddVC.h"
#import "BaseImageCollectionCell.h"
#import "IllegalAddHeadView.h"
#import "IllegalParkAddFootView.h"

#import "IllegalAddViewModel.h"

#import "NetWorkHelper.h"

#import "ParkCameraVC.h"
#import "IllegalListView.h"
#import "AlertView.h"

#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"
#import <UIImageView+WebCache.h>
#import "UINavigationBar+BarItem.h"
#import "SRAlertView.h"

#import "IllegalRecordVC.h"
#import "IllegalSecAddVC.h"
#import "IllegalAddListVC.h"

#import "UserModel.h"

@interface IllegalAddVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak)   IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) IllegalAddHeadView *headView;
@property (nonatomic,strong) IllegalParkAddFootView *footView;

@property(nonatomic, strong) IllegalAddViewModel * viewModel;

@end

@implementation IllegalAddVC

- (instancetype)init{
    
    if (self = [super init]) {
        self.viewModel = [[IllegalAddViewModel alloc] init];
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
    self.title = @"违停采集";
    
    //注册collection格式
    [_collectionView registerClass:[BaseImageCollectionCell class] forCellWithReuseIdentifier:@"BaseImageCollectionCellID"];
    [_collectionView registerNib:[UINib nibWithNibName:@"IllegalParkAddFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"IllegalAddFootViewID"];
    [_collectionView registerNib:[UINib nibWithNibName:@"IllegalAddHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"IllegalAddHeadViewID"];
    
    [self showRightBarButtonItemWithImage:@"btn_illegalAdd_list" target:self action:@selector(handleBtnShowListClicked:)];
    
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
    
    [self.viewModel.command_commit.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
    
        if ([x isEqualToString:@"提交成功"]) {
        
             if ([self.viewModel.param.roadId isEqualToNumber:@0]) {
                 [ShareValue sharedDefault].roadModels = nil;
                 [[ShareValue sharedDefault] roadModels];
            }
            
            [self.viewModel handleBeforeCommit];
            [self.collectionView reloadData];
            
        }
        
    }];
    
    [self.viewModel.command_identifyCarNo.executionSignals.switchToLatest subscribeNext:^(id _Nullable x) {
        @strongify(self);
    
        if ([x isKindOfClass:[ImageFileInfo class]]) {
            ImageFileInfo * cutImageInfo = (ImageFileInfo *)x;
            [self.viewModel replaceUpImageItemToUpImagesWithImageInfo:cutImageInfo remark:@"车牌近照" replaceIndex:1];
            [self.collectionView reloadData];
        }
        
    }];
    
    //检查是否需要二次采集工作
    [self.viewModel.command_carNoSect.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        if ([x isKindOfClass:[RACTuple class]]) {
            RACTupleUnpack(NSNumber * code,IllegalCarNoSecReponse * reponse,NSString * msg) = x;
            
            if ([code isEqualToNumber:@0]) {
                
                IllegalSecAddViewModel * t_viewModel = [[IllegalSecAddViewModel alloc] init];
                if ([self.viewModel.arr_upImages[0] isKindOfClass:[NSMutableDictionary class]]) {
                    t_viewModel.illegal_image = self.viewModel.arr_upImages[0];
                };
                t_viewModel.param.illegalId = reponse.illegalId;
                IllegalSecAddVC * vc = [[IllegalSecAddVC alloc] initWithViewModel:t_viewModel];
                vc.saveSuccessBlock = ^{
                    @strongify(self);
                    [self.viewModel handleBeforeCommit];
                    [self.collectionView reloadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([code isEqualToNumber:@13]){
                
                [self showAlertViewWithcontent:msg leftTitle:@"取消" rightTitle:@"确定" block:^(AlertViewActionType actionType) {
                    @strongify(self);
                    if (actionType == AlertViewActionTypeRight) {
                        
                        IllegalSecAddViewModel * t_viewModel = [[IllegalSecAddViewModel alloc] init];
                        if ([self.viewModel.arr_upImages[0] isKindOfClass:[NSMutableDictionary class]]) {
                            t_viewModel.illegal_image = self.viewModel.arr_upImages[0];
                        };
                        t_viewModel.param.illegalId = reponse.illegalId;
                        IllegalSecAddVC * vc = [[IllegalSecAddVC alloc] initWithViewModel:t_viewModel];
                        vc.saveSuccessBlock = ^{
                            @strongify(self);
                            [self.viewModel handleBeforeCommit];
                            [self.collectionView reloadData];
                        };
                        [self.navigationController pushViewController:vc animated:YES];
                        
            
//                        if (self.viewModel.isCanCommit == YES) {
//                            [self submitIllegalData];
//                        }
                        
                    }else if (actionType == AlertViewActionTypeLeft){
                    
                        [self.navigationController popViewControllerAnimated:YES];
                    
                    }
                    
                }];
                
            
            }else if ([code isEqualToNumber:@110]){
            
                IllegalListView *view = [IllegalListView initCustomView];
                view.block = ^(ParkAlertActionType actionType) {
                    @strongify(self);
                    if (actionType == AlertViewActionTypeLeft){
                        [self.navigationController popViewControllerAnimated:YES];
                    }else if (actionType == AlertViewActionTypeRight){
                        [self.viewModel handleBeforeCommit];
                        [self.collectionView reloadData];
                    }
                    
                };
                view.btnTitleString = @"重新采集";
                view.illegalList = reponse.illegalList;
                view.deckCarNo = reponse.deckCarNo;
                view.selectedBlock = ^(NSNumber *illegalId) {
                    @strongify(self);
                    IllegalRecordVC *vc =[[IllegalRecordVC alloc] init];
                    vc.illegalId = illegalId;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                };
                [AlertView showWindowWithIllegalListViewWith:view inView:self.view];
                
                
                
            }else if ([code isEqualToNumber:@999]){
                //不做处理
                //无任何记录，无需做处理
            }else if ([code isEqualToNumber:@1]){
                
                if (reponse.illegalList && reponse.illegalList.count > 0) {
                    
                    IllegalListView *view = [IllegalListView initCustomView];
                    view.block = ^(ParkAlertActionType actionType) {
                        @strongify(self);
                        if (actionType == AlertViewActionTypeLeft){
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    };
                    view.btnTitleString = @"继续采集";
                    view.illegalList = reponse.illegalList;
                    view.deckCarNo = reponse.deckCarNo;
                    view.selectedBlock = ^(NSNumber *illegalId) {
                        @strongify(self);
                        IllegalRecordVC *vc =[[IllegalRecordVC alloc] init];
                        vc.illegalId = illegalId;
                        [self.navigationController pushViewController:vc animated:YES];
                    };
                    [AlertView showWindowWithIllegalListViewWith:view inView:self.view];
                    
                    
                }else{
                    
                    [self showAlertViewWithcontent:reponse.deckCarNo leftTitle:@"退出" rightTitle:@"继续采集" block:^(AlertViewActionType actionType) {
                        
                        if (actionType == AlertViewActionTypeLeft){
                            
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        }
                        
                    }];
                    
                }
            }
            
        }
        
    }];
    
    
}

#pragma mark - buttonAction

- (void)handleBtnShowListClicked:(id)sender{
    if ([UserModel isPermissionForIllegalAddList]) {
        IllegalAddListVC * vc = [[IllegalAddListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        [ShareFun showTipLable:@"您暂无权限查看"];
    }
    
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
        
        cell.lb_title.text = @"更多照片";
        cell.imageView.image = [UIImage imageNamed:@"btn_updatePhoto"];
    }else{
        
        if(indexPath.row == 0){
            cell.lb_title.text = @"违法照片";
        }else if(indexPath.row == 1){
            cell.lb_title.text = @"车牌近照";
        }else {
            cell.lb_title.text = [NSString stringWithFormat:@"违法照片%ld",indexPath.row];
        }
        
        //判断是否拥有图片，如果拥有则显示图片，如果没有则显示@“updataPhoto.png”的图片
        //主要用于分辨车牌近照，和违停照片有没有图片
        if ([self.viewModel.arr_upImages[indexPath.row] isKindOfClass:[NSNull class]]) {
            cell.imageView.image = [UIImage imageNamed:@"btn_updatePhoto"];
        }else{
            NSMutableDictionary *t_dic = self.viewModel.arr_upImages[indexPath.row];
            ImageFileInfo *imageInfo = [t_dic objectForKey:@"files"];
            if (imageInfo) {
                cell.imageView.image = imageInfo.image;
            }
            
        }
        
    }
    
    return cell;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        self.headView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"IllegalAddHeadViewID" forIndexPath:indexPath];
        [_headView setDelegate:(id<IllegalAddHeadViewDelegate>)self];
        _headView.param = self.viewModel.param;
        
        return _headView;
        
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        self.footView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"IllegalAddFootViewID" forIndexPath:indexPath];
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
        
        [self showCameraWithType:2 withFinishBlock:^(ImageFileInfo * imageInfo) {
            @strongify(self);
            [self.viewModel addUpImageItemToUpImagesWithImageInfo:imageInfo remark:@"0"];
            [self.collectionView reloadData];
        }];
        
    }else if(indexPath.row == 0){
        
        if ([self.viewModel.arr_upImages[0] isKindOfClass:[NSNull class]]) {
            
            [self showCameraWithType:3 withCutFinishBlock:^(ImageFileInfo *imageInfo, ImageFileInfo *cutImageInfo) {
                @strongify(self);
                [self.viewModel replaceUpImageItemToUpImagesWithImageInfo:imageInfo remark:@"违法照片" replaceIndex:0];
                [self.viewModel.command_identifyCarNo execute:cutImageInfo];
                [self.collectionView reloadData];
            }];
            
        }else{
            //当存在车牌近照的时候,弹出图片浏览器
            [self showPhotoBrowserWithIndex:0];
        }
        
    }else if(indexPath.row == 1){
        
        if ([self.viewModel.arr_upImages[1] isKindOfClass:[NSNull class]]) {
            
            [self showCameraWithType:1 withFinishBlock:^(ImageFileInfo * imageInfo) {
                //TODO : 车牌识别
                [self.viewModel getParkingIdentifyRequest:imageInfo];
                [self.viewModel replaceUpImageItemToUpImagesWithImageInfo:imageInfo remark:@"车牌近照" replaceIndex:1];
                [self.collectionView reloadData];
                
            }];
            
        }else{
            
            //当违停照片存在的情况下,弹出图片浏览器,如果车牌近照有的情况下图片索引为1,如果没有则图片索引变成0
            //
            if ([self.viewModel.arr_upImages[0] isKindOfClass:[NSNull class]]) {
                [self showPhotoBrowserWithIndex:0];
            }else {
                [self showPhotoBrowserWithIndex:1];
            }
            
        }
        
    }else {
        //当更多照片存在的情况下,弹出图片浏览器,下面判断图片索引
        if ([self.viewModel.arr_upImages[0] isKindOfClass:[NSNull class]] && [self.viewModel.arr_upImages[1] isKindOfClass:[NSNull class]]) {
            [self showPhotoBrowserWithIndex:indexPath.row-2];
        }else {
            if ([self.viewModel.arr_upImages[0] isKindOfClass:[NSNull class]] || [self.viewModel.arr_upImages[1] isKindOfClass:[NSNull class]]) {
                [self showPhotoBrowserWithIndex:indexPath.row-1];
            }else{
                [self showPhotoBrowserWithIndex:indexPath.row];
            }
            
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
    return (CGSize){ScreenWidth,230};
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

-(void)showCameraWithType:(NSInteger)type withFinishBlock:(void(^)(ImageFileInfo * imageInfo))finishBlock {
    
    ParkCameraVC *home = [[ParkCameraVC alloc] init];
    home.type = type;
    home.fininshCaptureBlock = finishBlock;
    [self presentViewController:home
                       animated:YES
                     completion:^{
                     }];
    
}

-(void)showCameraWithType:(NSInteger)type withCutFinishBlock:(void(^)(ImageFileInfo * imageInfo,ImageFileInfo * cutImageInfo))finishBlock{
    
    ParkCameraVC *home = [[ParkCameraVC alloc] init];
    home.type = type;
    home.fininshCaptureWithCutImageBlock = finishBlock;
    [self presentViewController:home
                       animated:YES
                     completion:^{
                     }];
    
}

     
     
#pragma mark - 弹出提示框
-(void)showAlertViewWithcontent:(NSString *)content leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle block:(AlertViewDidSelectAction)selectAction{

    SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:content
                                                leftActionTitle:leftTitle
                                               rightActionTitle:rightTitle
                                                animationStyle:AlertViewAnimationNone
                                                   selectAction:selectAction];
    alertView.blurCurrentBackgroundView = NO;
    [alertView show];

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
                
                if ([t_str isEqualToString:@"车牌近照"] || [t_str isEqualToString:@"违法照片"]) {
                    
                    [self.viewModel.arr_upImages replaceObjectAtIndex:i withObject:[NSNull null]];
                    
                    if (i == 0) {
                        self.viewModel.first = self.viewModel.arr_upImages[0];
                    }else{
                        self.viewModel.secend = self.viewModel.arr_upImages[1];
                    }
                    
                    
                }else{
                    
                    [self.viewModel.arr_upImages removeObject:t_dic];
                    
                }
                
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

    [self.viewModel.command_commit execute:nil];
}

#pragma mark - HeadViewDelegate点击识别按钮返回回来的数据

- (void)recognitionCarNumber:(ImageFileInfo * )imageInfo{

    [self.viewModel getParkingIdentifyRequest:imageInfo];
    [self.viewModel replaceUpImageItemToUpImagesWithImageInfo:imageInfo remark:@"车牌近照" replaceIndex:1];
    [_collectionView reloadData];
    
}


#pragma mark - dealloc

- (void)dealloc{
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
    
    LxPrintf(@"IllegalAddVC dealloc");
}


@end
