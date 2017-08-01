//
//  IllegalSecSaveVC.m
//  trafficPolice
//
//  Created by hcat on 2017/6/5.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalSecSaveVC.h"

#import "AccidentAddHeadView.h"
#import "BaseImageCollectionCell.h"
#import "IllegalParkAddFootView.h"
#import "IllegalThroughSecAddView.h"

#import "LRCameraVC.h"

#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"

#import "IllegalThroughAPI.h"
#import <UIImageView+WebCache.h>
#import "NetWorkHelper.h"


@interface IllegalSecSaveVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IllegalParkAddFootView *footView;

@property (nonatomic,strong) NSMutableArray *arr_upImages; //用于存储即将上传的图片

@property (nonatomic,strong) IllegalThroughSecDetailModel * secDetailModel;//第一次提交数据
@property (nonatomic,strong) IllegalThroughSecSaveParam *param;

@property(nonatomic,assign) BOOL isCanCommit; //是否可以上传

@end

@implementation IllegalSecSaveVC


static NSString *const headId = @"IllegalThroughSecAddViewID";
static NSString *const cellId = @"BaseImageCollectionCellID";
static NSString *const headTitleId = @"IllegalSecSavHeadTitleID";
static NSString *const footId = @"IllegalSecSavFootViewID";


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"闯禁令二次采集";
    
    self.arr_upImages = [NSMutableArray array];
    self.param = [[IllegalThroughSecSaveParam alloc] init];
    self.param.illegalThroughId = _illegalThroughId;
    self.isCanCommit = NO;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"IllegalThroughSecAddView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headId];
    [_collectionView registerClass:[BaseImageCollectionCell class] forCellWithReuseIdentifier:cellId];
    [_collectionView registerNib:[UINib nibWithNibName:@"IllegalParkAddFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footId];
    [_collectionView registerNib:[UINib nibWithNibName:@"AccidentAddHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headTitleId];
    
    [self loadSecIllegalThroughData:_illegalThroughId];
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        if (!strongSelf.secDetailModel) {
            [strongSelf loadSecIllegalThroughData:strongSelf.illegalThroughId];
        }
    };

}

#pragma mark - set && get

- (void)setIsCanCommit:(BOOL)isCanCommit{
    
    _isCanCommit = isCanCommit;
    
    if (_isCanCommit) {
        _footView.btn_commit.enabled = YES;
        [_footView.btn_commit setBackgroundColor:DefaultBtnColor];
        
    }else{
        _footView.btn_commit.enabled = NO;
        [_footView.btn_commit setBackgroundColor:DefaultBtnNuableColor];
    }
    
}

#pragma mark - 数据请求

- (void)loadSecIllegalThroughData:(NSNumber *)throughId{
    WS(weakSelf);
    
    IllegalThroughSecAddManger *manger = [[IllegalThroughSecAddManger alloc] init];
    manger.illegalThroughId = throughId;
    [manger configLoadingTitle:@"加载"];
    
    SW(strongSelf,weakSelf);
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.secDetailModel = manger.illegalThroughSecDetailModel;
            [strongSelf.collectionView reloadData];
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}


#pragma mark - UICollectionView Data Source

//返回多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView   *)collectionView
{
    return 2;
}

//返回每组多少个视图
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_secDetailModel && _secDetailModel.pictures && _secDetailModel.pictures.count > 0) {
            return _secDetailModel.pictures.count;
        }

        return 0;
        
    }else{
        
        return [self.arr_upImages count] + 1;
    }
    
}

//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    [cell setCommonConfig];
    cell.lb_title.textColor = UIColorFromRGB(0xe6504a);
    
    if (indexPath.section == 0) {
        
        AccidentPicListModel *t_model = self.secDetailModel.pictures[indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:t_model.imgUrl] placeholderImage:[UIImage imageNamed:@"btn_updatePhoto"]];
        cell.lb_title.text = [ShareFun timeWithTimeInterval:t_model.uploadTime dateFormat:@"HH:mm:ss"];
        
    }else{
    
        if (indexPath.row == self.arr_upImages.count) {
            
            cell.imageView.image = [UIImage imageNamed:@"btn_updatePhoto"];
            
        }else{
            
            if (_arr_upImages){
                
                NSMutableDictionary *t_dic = _arr_upImages[indexPath.row];
                ImageFileInfo *imageInfo = [t_dic objectForKey:@"files"];
                cell.imageView.image = imageInfo.image;
                cell.lb_title.text = imageInfo.imageTime;
                
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
        
            IllegalThroughSecAddView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headId forIndexPath:indexPath];
            if (_secDetailModel) {
                headerView.carNumber = _secDetailModel.illegalCollect.carNo;
                headerView.roadName = _secDetailModel.roadName;
            }
            
            return headerView;
            
                      
        }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
            
        
            
        }
        
    } else {
        
        if([kind isEqualToString:UICollectionElementKindSectionHeader])
        {
            AccidentAddHeadView *headerView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headTitleId forIndexPath:indexPath];
            headerView.lb_title.text = @"二次采集照片";
            
            return headerView;
            
        }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
            
            self.footView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footId forIndexPath:indexPath];
            
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
        
        if (_secDetailModel && _secDetailModel.pictures.count > 0) {
            
            for (int i = 0; i < self.secDetailModel.pictures.count; i++) {
                
                NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
                BaseImageCollectionCell *currentCell = (BaseImageCollectionCell *)[_collectionView cellForItemAtIndexPath:currentIndexPath];
                AccidentPicListModel *t_model = self.secDetailModel.pictures[i];
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
        
        if (indexPath.row == _arr_upImages.count) {
            
            [self showCameraWithType:5 withFinishBlock:^(LRCameraVC *camera) {
                if (camera) {
                    
                    SW(strongSelf, weakSelf);
                    
                    if (camera.type == 5) {
                        [strongSelf addUpImageItemToUpImagesWithImageInfo:camera.imageInfo];
                        [strongSelf.collectionView reloadData];
                        
                    }
                }
            }];
            
        }else {
            
            //当存在车牌近照的时候,弹出图片浏览器
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

#pragma mark - 管理上传图片

//添加图片到arr_upImages数组中
- (void)addUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo{
    
    imageFileInfo.name = key_files;
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    [t_dic setObject:imageFileInfo forKey:@"files"];
    [t_dic setObject:imageFileInfo.fileName forKey:@"remarks"];
    [t_dic setObject:[ShareFun getCurrentTime] forKey:@"taketimes"];
    [self.arr_upImages addObject:t_dic];
    
    if (self.arr_upImages.count > 0) {
        self.isCanCommit = YES;
    }else{
        self.isCanCommit = NO;
    }
    
}

- (void)configParamInFilesAndRemarksAndTimes{
    
    if (_arr_upImages && _arr_upImages.count > 0) {
        
        LxDBObjectAsJson(_arr_upImages);
        
        NSMutableArray *t_arr_files = [NSMutableArray array];
        NSMutableArray *t_arr_remarks = [NSMutableArray array];
        NSMutableArray *t_arr_taketimes = [NSMutableArray array];
        
        NSInteger j = 1;
        
        for (int i = 0; i < _arr_upImages.count; i++) {
            
            if([_arr_upImages[i] isKindOfClass:[NSMutableDictionary class]]){
                
                NSMutableDictionary *t_dic = _arr_upImages[i];
                ImageFileInfo *imageInfo = [t_dic objectForKey:@"files"];
                
                if (imageInfo) {
                    
                    NSString *t_title = [NSString stringWithFormat:@"二次采集照%ld",j];
                    NSString *t_taketime = [t_dic objectForKey:@"taketimes"];
                    [t_arr_files addObject:imageInfo];
                    [t_arr_remarks addObject:t_title];
                    [t_arr_taketimes addObject:t_taketime];
                    j++;
                }
                
            }
            
        }
        if (t_arr_files.count > 0) {
            _param.files = t_arr_files;
        }
        
        if (t_arr_remarks.count > 0) {
            _param.remarks = [t_arr_remarks componentsJoinedByString:@","];
        }
        
        if (t_arr_taketimes.count > 0) {
            _param.taketimes = [t_arr_taketimes componentsJoinedByString:@","];
        }
    }
}

#pragma mark - FootViewDelegate 点击提交按钮事件

- (void)handleCommitClicked{

    [self configParamInFilesAndRemarksAndTimes];
    
    LxDBObjectAsJson(_param);
    WS(weakSelf);
    
    IllegalThroughSecSaveManger *manger = [[IllegalThroughSecSaveManger alloc] init];
    manger.param =_param;
    [manger configLoadingTitle:@"提交"];

    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            [strongSelf.navigationController popViewControllerAnimated:YES];
            if (strongSelf.saveSuccessBlock) {
                strongSelf.saveSuccessBlock();
            }
        }
    
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}

#pragma mark - 弹出照相机

-(void)showCameraWithType:(NSInteger)type withFinishBlock:(void(^)(LRCameraVC *camera))finishBlock{
    
    LRCameraVC *home = [[LRCameraVC alloc] init];
    home.type = type;
    home.fininshCaptureBlock = finishBlock;
    [self presentViewController:home
                       animated:YES
                     completion:^{
                     }];
    
}

#pragma mark - 调用图片浏览器

-(void)showPhotoBrowserWithIndex:(NSInteger)index {
    
    NSMutableArray *t_arr = [NSMutableArray array];

    for (int i = 0; i < [_arr_upImages count]; i++) {
        
        if ([_arr_upImages[i] isKindOfClass:[NSMutableDictionary class]]) {
            
            BaseImageCollectionCell *cell = (BaseImageCollectionCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            
            NSDictionary *t_dic = [NSDictionary dictionaryWithDictionary:_arr_upImages[i]];
            ImageFileInfo *info = t_dic[@"files"];
            
            if (info) {
                
                KSPhotoItem *item = [KSPhotoItem itemWithSourceView:cell.imageView image:info.image withDic:t_dic];
                [t_arr addObject:item ];
                
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
    
    for (int i = 0; i < [_arr_upImages count]; i++) {
        
        if ([self.arr_upImages[i] isKindOfClass:[NSMutableDictionary class]]) {
            
            NSMutableDictionary *t_dic = self.arr_upImages[i];
            
            NSString *t_str = [t_dic objectForKey:@"remarks"];
            
            if ([t_str isEqualToString:[itemDic objectForKey:@"remarks"]]) {
                
                [self.arr_upImages removeObject:t_dic];
                
                [self.collectionView reloadData];
                
                //替换之后做是否可以上传判断
                if (self.arr_upImages.count > 0) {
                    
                    self.isCanCommit = YES;
                    
                }else{
                    
                    self.isCanCommit = NO;
                    
                }
                
                break;
            }
            
        }
        
    }
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    LxPrintf(@"IllegalSecSaveVC dealloc");

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
