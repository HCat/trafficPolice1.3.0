//
//  CarInfoAddVC.m
//  移动采集
//
//  Created by hcat on 2017/9/15.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "CarInfoAddVC.h"

#import "BaseImageCollectionCell.h"
#import "IllegalParkAddHeadView.h"
#import "IllegalParkAddFootView.h"
#import "LRCameraVC.h"
#import "NetWorkHelper.h"

#import <Photos/Photos.h>
#import <UIImageView+WebCache.h>

#import "IllegalParkAPI.h"

#import "SRAlertView.h"
#import "AlertView.h"
#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"
#import "IllegalNetErrorView.h"
#import "IllegalDBModel.h"
#import "IllegalRecordVC.h"

#import "UserModel.h"
#import "UINavigationBar+BarItem.h"
#import "IllegalListVC.h"

@interface CarInfoAddVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak)   IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) IllegalParkAddHeadView *headView;
@property (nonatomic,strong) IllegalParkAddFootView *footView;

@property (nonatomic,strong) IllegalParkSaveParam *param; //请求参数

@property (nonatomic,assign) BOOL isObserver;   //用于注册isCanCommit的KVC,如果注册了设置YES，防止重复注册
@property (nonatomic,assign) BOOL isCanCommit;  //需要可以上传的条件有两个，一个是需要车牌近照和违停照片，还有就是headView中的必填字段

@property (nonatomic,strong) NSMutableArray *arr_upImages; //用于存储即将上传的图片


@end

@implementation CarInfoAddVC

static NSString *const cellId = @"BaseImageCollectionCellID";
static NSString *const footId = @"IllegalParkAddFootViewID";
static NSString *const headId = @"IllegalParkAddHeadViewID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == ParkTypeMotorbikeAdd) {
        self.title = @"摩托车违章";
    }else{
        self.title = @"车辆录入";
    }
    
    self.isObserver = NO;
    
    [self showRightBarButtonItemWithImage:@"btn_illegalAdd_list" target:self action:@selector(handleBtnShowListClicked:)];
    //初始化请求参数
    self.param = [[IllegalParkSaveParam alloc] init];
    
    //初始化图片数据，加入两个空对象，分别对应车牌近照，违停照片
    //如果有了车牌近照和违停照片则替换掉这两个空对象，如果没有则替换回来空对象
    self.arr_upImages =  [NSMutableArray array];
    [self.arr_upImages addObject:[NSNull null]];
    
    //注册collection格式
    [_collectionView registerClass:[BaseImageCollectionCell class] forCellWithReuseIdentifier:cellId];
    [_collectionView registerNib:[UINib nibWithNibName:@"IllegalParkAddFootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footId];
    [_collectionView registerNib:[UINib nibWithNibName:@"IllegalParkAddHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headId];
    
    [self getCommonRoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        [weakSelf getCommonRoad];
    };
    
#ifdef __IPHONE_11_0
    if (IS_IPHONE_X_MORE == NO) {
        if ([_collectionView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
#endif
    
}

#pragma mark - buttonAction

- (void)handleBtnShowListClicked:(id)sender{
    
    if (self.type == ParkTypeMotorbikeAdd) {
        // self.title = @"摩托车违章";
        if ([UserModel isPermissionForMotorBikeList]) {
            IllegalListVC *t_vc = [[IllegalListVC alloc] init];
            t_vc.type = 1;
            t_vc.illegalType = IllegalTypePark;
            t_vc.subType = ParkTypeMotorbikeAdd;
            t_vc.title = @"摩托车违章列表";
            [self.navigationController pushViewController:t_vc animated:YES];
        }else{
            [ShareFun showTipLable:@"您暂无权限查看"];
        }
    }else{
        //self.title = @"车辆录入";
        if ([UserModel isPermissionForCarInfoList]) {
            IllegalListVC *t_vc = [[IllegalListVC alloc] init];
            t_vc.type = 1;
            t_vc.illegalType = IllegalTypePark;
            t_vc.subType = ParkTypeCarInfoAdd;
            t_vc.title = @"车辆录入列表";
            [self.navigationController pushViewController:t_vc animated:YES];
        }else{
            [ShareFun showTipLable:@"您暂无权限查看"];
        }
    }
   

}

#pragma mark - 返回按钮事件

-(void)handleBtnBackClicked{
    
    if (_headView.param.addressRemark || _headView.param.carNo || (_arr_upImages.count > 0 && ![self.arr_upImages[0] isKindOfClass:[NSNull class]] )) {
        
        WS(weakSelf);
        [AlertView showWindowWithIllegalParkAlertViewSelectAction:^(ParkAlertActionType actionType) {
            if(actionType == ParkAlertActionTypeRight) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
//        SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"温馨提示"
//                                                            message:@"当前已编辑，是否退出编辑"
//                                                    leftActionTitle:@"取消"
//                                                   rightActionTitle:@"退出"
//                                                     animationStyle:AlertViewAnimationNone
//                                                       selectAction:^(AlertViewActionType actionType) {
//                                                           if(actionType == AlertViewActionTypeRight) {
//                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
//                                                           }
//                                                       }];
//        alertView.blurCurrentBackgroundView = NO;
//        [alertView show];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
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


// 查询是否有违停记录

#pragma mark - IllegalParkAddHeadViewDelegate

- (void)listentCarNumber{
    if(_type == ParkTypeMotorbikeAdd){
        [self judgeNeedJudgeIllegalRecord:self.param.carNo];
    }
    
}

- (void)judgeNeedJudgeIllegalRecord:(NSString *)carNumber{
    
    if (carNumber && carNumber.length > 0) {
        
        WS(weakSelf);
        
        [_headView getRoadId];
        IllegalParkCarNoRecordManger *manger = [[IllegalParkCarNoRecordManger alloc] init];
        manger.carNo = carNumber;
        manger.roadId = _param.roadId;
        manger.type = @(ParkTypeMotorbikeAdd);
        
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf, weakSelf);
            LxPrintf(@"%ld",(long)manger.responseModel.code);
            
            if (manger.responseModel.code == 110) {
                [strongSelf.headView takeCarNumberDown];
                
                IllegalListView *view = [IllegalListView initCustomView];
                view.block = ^(ParkAlertActionType actionType) {
                    if (actionType == AlertViewActionTypeLeft){
                        [strongSelf.navigationController popViewControllerAnimated:YES];
                    }else if (actionType == AlertViewActionTypeRight){
                        [strongSelf handleBeforeCommit];
                    }
                    
                };
                view.btnTitleString = @"重新采集";
                view.illegalList = manger.illegalList;
                view.deckCarNo = manger.deckCarNo;
                view.selectedBlock = ^(NSNumber *illegalId) {
                    IllegalRecordVC *vc =[[IllegalRecordVC alloc] init];
                    vc.illegalId = illegalId;
                    [strongSelf.navigationController pushViewController:vc animated:YES];
                };
                [AlertView showWindowWithIllegalListViewWith:view inView:strongSelf.view];
                
            }else if (manger.responseModel.code == 1){
                
                if (manger.illegalList && manger.illegalList.count > 0) {
                    
                    [strongSelf.headView takeCarNumberDown];
                    
                    IllegalListView *view = [IllegalListView initCustomView];
                    view.block = ^(ParkAlertActionType actionType) {
                        if (actionType == AlertViewActionTypeLeft){
                            [strongSelf.navigationController popViewControllerAnimated:YES];
                        }
                    };
                    view.btnTitleString = @"继续采集";
                    view.illegalList = manger.illegalList;
                    view.deckCarNo = manger.deckCarNo;
                    view.selectedBlock = ^(NSNumber *illegalId) {
                        IllegalRecordVC *vc =[[IllegalRecordVC alloc] init];
                        vc.illegalId = illegalId;
                        [strongSelf.navigationController pushViewController:vc animated:YES];
                    };
                    [AlertView showWindowWithIllegalListViewWith:view inView:strongSelf.view];
                    
                    
                }else{
                    
                    [strongSelf showAlertViewWithcontent:manger.deckCarNo leftTitle:@"退出" rightTitle:@"继续采集" block:^(AlertViewActionType actionType) {
                        
                        if (actionType == AlertViewActionTypeLeft){
                            
                            [strongSelf.navigationController popViewControllerAnimated:YES];
                            
                        }
                        
                    }];
                    
                }
                
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            
            
        }];
        
    }
    
    
}


#pragma mark - 网络请求

- (void)getCommonRoad{
    
    WS(weakSelf);
    CommonGetRoadManger *manger = [[CommonGetRoadManger alloc] init];
    manger.isLog = NO;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            [ShareValue sharedDefault].roadModels = manger.commonGetRoadResponse;
            if (strongSelf.headView) {
                [strongSelf.headView getRoadId];
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
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
    return [self.arr_upImages count];
}


//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BaseImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    [cell setCommonConfig];
    
    if (self.type == ParkTypeMotorbikeAdd) {
        cell.lb_title.text = @"摩托车照";
    }else{
        cell.lb_title.text = @"车牌近照";
    }
    
    //判断是否拥有图片，如果拥有则显示图片，如果没有则显示@“updataPhoto.png”的图片
    //主要用于分辨车牌近照，和违停照片有没有图片
    if ([_arr_upImages[indexPath.row] isKindOfClass:[NSNull class]]) {
        
        cell.imageView.image = [UIImage imageNamed:@"btn_updatePhoto"];
        
    }else{
        
        NSMutableDictionary *t_dic = _arr_upImages[indexPath.row];
        
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
        if (!self.headView) {
            self.headView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headId forIndexPath:indexPath];
            [_headView setDelegate:(id<IllegalParkAddHeadViewDelegate>)self];
            _headView.param = _param;
            _headView.subType = self.type;
            
            //监听headView中的isCanCommit来判断是否可以上传
            if (!_isObserver) {
                
                [_headView addObserver:self forKeyPath:@"isCanCommit" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
                self.isObserver = YES;
                
            }
        }
        
        return _headView;
        
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        self.footView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footId forIndexPath:indexPath];
        [_footView setDelegate:(id<IllegalParkAddFootViewDelegate>)self];
        
        return _footView;
        
    }
    
    return nil;
}

#pragma mark - UICollectionView Delegate method

//选中某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    
    if(indexPath.row == 0){
        
        if ([_arr_upImages[0] isKindOfClass:[NSNull class]]) {
            
            if (self.type == ParkTypeMotorbikeAdd) {
                [self showCameraWithType:ParkTypeMotorbikeAdd withFinishBlock:^(LRCameraVC *camera) {
                    if (camera) {
                        
                        SW(strongSelf, weakSelf);
                        
                        if (camera.type == ParkTypeMotorbikeAdd) {
                            
                            [strongSelf replaceUpImageItemToUpImagesWithImageInfo:camera.imageInfo remark:@"摩托车照" replaceIndex:0];
                            
                            [strongSelf.collectionView reloadData];
                            
                        }
                    }
                } isNeedRecognition:NO];
            }else{
                [self showCameraWithType:1 withFinishBlock:^(LRCameraVC *camera) {
                    if (camera) {
                        
                        SW(strongSelf, weakSelf);
                        
                        if (camera.type == 1) {
                            
                            //替换车牌近照的图片
                            if (camera.commonIdentifyResponse && camera.commonIdentifyResponse.cutImageUrl && [camera.commonIdentifyResponse.cutImageUrl length] > 0) {
                                
                                //识别之后所做的操作
                                [strongSelf.headView takePhotoToDiscernmentWithCarNumber:camera.commonIdentifyResponse.carNo withCarcolor:camera.carColor];
                                
                            }
                            
                            [strongSelf replaceUpImageItemToUpImagesWithImageInfo:camera.imageInfo remark:@"车牌近照" replaceIndex:0];
                            
                            [strongSelf.collectionView reloadData];
                            
                        }
                    }
                } isNeedRecognition:NO];
            }
            
            
        }else{
            
            [self showPhotoBrowserWithIndex:0];
            
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

#pragma mark - KVO,监听看是否可以提交，用于提交按钮是否可以点击

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"isCanCommit"] && object == _headView) {
        
        [self judgeIsCanCommit];
        
    }
    
}

#pragma mark - FootViewDelegate 点击提交按钮事件

- (void)handleCommitClicked{
    
    if (_param.carNo) {
        if(self.type != ParkTypeMotorbikeAdd){
            if([ShareFun validateCarNumber:_param.carNo] == NO){
                [LRShowHUD showError:@"车牌号格式错误" duration:1.f];
                return;
            }
        }
    }
    
    WS(weakSelf);
    
    [NetworkStatusMonitor StartWithBlock:^(NSInteger NetworkStatus) {
        
        [NetworkStatusMonitor StopMonitor];
        
        //SW(strongSelf, weakSelf);
        if (NetworkStatus != 10 && NetworkStatus != 1) {
            [ShareFun showTipLable:@"当前非4G网络,传输速度受影响"];

            //[strongSelf showIllegalNetErrorView];
        }else{
            //提交违章数据
            //[strongSelf submitIllegalData];
        }
        
    }];
    
    [self submitIllegalData];
    
}

- (void)submitIllegalData{
    
    [self configParamInFilesAndRemarksAndTimes];
    
    LxDBObjectAsJson(_param);
    WS(weakSelf);
    
    _param.type = @(self.type);
    
    IllegalParkSaveManger *manger = [[IllegalParkSaveManger alloc] init];
    manger.param = _param;
    [manger configLoadingTitle:@"提交"];
    manger.isNoShowFail = YES;
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        
        //异步请求通用路名ID,这里需要请求的原因是当传入的roadID为0的情况下，需要重新去服务器里面拉取路名来匹配
        if ([strongSelf.param.roadId isEqualToNumber:@0]) {
            [ShareValue sharedDefault].roadModels = nil;
            [strongSelf getCommonRoad];
        }
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            [strongSelf handleBeforeCommit];
            
        }else if (manger.responseModel.code == CODE_FAILED){
            
            [strongSelf showAlertViewWithcontent:manger.responseModel.msg leftTitle:nil rightTitle:@"确定" block:nil];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([request.error.localizedDescription isEqualToString:@"请求超时。"]) {
            [LRShowHUD showError:@"请重新提交!" duration:1.5f];
        }

//        SW(strongSelf, weakSelf);
//        [strongSelf showIllegalNetErrorView];
    }];
    
}


#pragma mark - HeadViewDelegate点击识别按钮返回回来的数据

- (void)recognitionCarNumber:(LRCameraVC *)cameraVC{
    
    if (cameraVC.commonIdentifyResponse.cutImageUrl) {
        
       [self.headView takePhotoToDiscernmentWithCarNumber:cameraVC.commonIdentifyResponse.carNo withCarcolor:cameraVC.carColor];
        
    }
    
    [self replaceUpImageItemToUpImagesWithImageInfo:cameraVC.imageInfo remark:@"车牌近照" replaceIndex:0];
    
    [_collectionView reloadData];
    
}

#pragma mark - 上传之后页面处理

- (void)handleBeforeCommit{
    
    [_headView strogeLocationBeforeCommit];
    
    [_arr_upImages removeAllObjects];
    [_arr_upImages addObject:[NSNull null]];
    
    [_collectionView reloadData];
    
    self.param = [[IllegalParkSaveParam alloc] init];
    
    _headView.param = _param;
    [_headView handleBeforeCommit];
}


#pragma mark - 管理上传图片

//替换图片到arr_upImages数组中
- (void)replaceUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo remark:(NSString *)remark replaceIndex:(NSInteger)index{
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    [t_dic setObject:remark                    forKey:@"remarks"];
    
    if (imageFileInfo) {
        imageFileInfo.name = key_files;
        [t_dic setObject:imageFileInfo             forKey:@"files"];
        [t_dic setObject:[ShareFun getCurrentTime] forKey:@"taketimes"];
    }
    
    [self.arr_upImages  replaceObjectAtIndex:index withObject:t_dic];
    
    //判断是否可以提交
    [self judgeIsCanCommit];
    
}

- (void)configParamInFilesAndRemarksAndTimes{
    
    if (_arr_upImages && _arr_upImages.count > 0) {
        
        LxDBObjectAsJson(_arr_upImages);
        
        NSMutableArray *t_arr_files     = [NSMutableArray array];
        NSMutableArray *t_arr_remarks   = [NSMutableArray array];
        NSMutableArray *t_arr_taketimes = [NSMutableArray array];
        
        if([_arr_upImages[0] isKindOfClass:[NSMutableDictionary class]]){
            
            NSMutableDictionary *t_dic  = _arr_upImages[0];
            ImageFileInfo *imageInfo    = [t_dic objectForKey:@"files"];
            
            if (imageInfo) {
                
                NSString* t_title = [t_dic objectForKey:@"remarks"];
                NSString *t_taketime    = [t_dic objectForKey:@"taketimes"];
                [t_arr_files     addObject:imageInfo];
                [t_arr_remarks   addObject:t_title];
                [t_arr_taketimes addObject:t_taketime];
                
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
    
    for (int i = 0; i < [_arr_upImages count]; i++) {
        
        if ([_arr_upImages[i] isKindOfClass:[NSMutableDictionary class]]) {
            
            BaseImageCollectionCell *cell = (BaseImageCollectionCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            NSDictionary *t_dic = [NSDictionary dictionaryWithDictionary:_arr_upImages[i]];
            
            ImageFileInfo *info = t_dic[@"files"];
            if (info) {
                KSPhotoItem *item = [KSPhotoItem itemWithSourceView:cell.imageView image:info.image withDic:t_dic];
                [t_arr addObject:item];
            }else{
                NSString *t_str = t_dic[@"cutImageUrl"];
                if (t_str) {
                    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:cell.imageView imageUrl:[NSURL URLWithString:t_str] withDic:t_dic];
                    [t_arr addObject:item];
                }
                
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
                
                if ([t_str isEqualToString:@"车牌近照"]) {
                    self.param.cutImageUrl = nil;
                    self.param.taketime = nil;
                }
                
                [self.arr_upImages replaceObjectAtIndex:i withObject:[NSNull null]];

                [self.collectionView reloadData];
                
                
                [self judgeIsCanCommit];
                
            }
            
        }
        
    }
    
}

#pragma mark - 判断违停或者闯禁令是否可以提交

- (void)judgeIsCanCommit{
    
    if (_headView.isCanCommit == YES && ![_arr_upImages[0] isKindOfClass:[NSNull class]]) {
        self.isCanCommit = YES;
    }else{
        self.isCanCommit = NO;
    }
    
}

#pragma mark - 显示网络问题时候的选项

- (void)showIllegalNetErrorView{
    
    WS(weakSelf);
    
    IllegalNetErrorView * view = [IllegalNetErrorView initCustomView];
    
    view.saveBlock = ^{
        SW(strongSelf, weakSelf);
        
        strongSelf.param.type = @(ParkTypeCarInfoAdd);
        [strongSelf configParamInFilesAndRemarksAndTimes];
        IllegalDBModel * illegalDBModel = [[IllegalDBModel alloc] initWithIllegalParkParam:strongSelf.param];
        illegalDBModel.isAbnormal = NO;
        [illegalDBModel save];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ILLEGALPARK_ADDCACHE_SUCCESS object:nil];
        [strongSelf handleBeforeCommit];
        
    };
    
    view.upBlock = ^{
        SW(strongSelf, weakSelf);
        [strongSelf submitIllegalData];
        
    };
    
    [view show];
    
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
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
    
    LxPrintf(@"CarInfoAddVC dealloc");
    
}

@end
