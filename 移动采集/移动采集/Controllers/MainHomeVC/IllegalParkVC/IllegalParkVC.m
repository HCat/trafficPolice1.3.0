//
//  IllegalParkVC.m
//  trafficPolice
//
//  Created by hcat on 2017/5/31.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalParkVC.h"

#import "BaseImageCollectionCell.h"
#import "IllegalParkAddHeadView.h"
#import "IllegalParkAddFootView.h"
#import "LRCameraVC.h"
#import "NetWorkHelper.h"

#import <Photos/Photos.h>
#import <UIImageView+WebCache.h>

#import "IllegalParkAPI.h"
#import "IllegalThroughAPI.h"

#import "SRAlertView.h"
#import "AlertView.h"
#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"

#import "IllegalSecSaveVC.h"

@interface IllegalParkVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak)   IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) IllegalParkAddHeadView *headView;
@property (nonatomic,strong) IllegalParkAddFootView *footView;

@property (nonatomic,strong) IllegalParkSaveParam *param; //请求参数

@property (nonatomic,assign) BOOL isObserver;   //用于注册isCanCommit的KVC,如果注册了设置YES，防止重复注册
@property (nonatomic,assign) BOOL isCanCommit;  //需要可以上传的条件有两个，一个是需要车牌近照和违停照片，还有就是headView中的必填字段

@property (nonatomic,strong) NSMutableArray *arr_upImages; //用于存储即将上传的图片


@end

@implementation IllegalParkVC

static NSString *const cellId = @"BaseImageCollectionCellID";
static NSString *const footId = @"IllegalParkAddFootViewID";
static NSString *const headId = @"IllegalParkAddHeadViewID";


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (_illegalType == IllegalTypePark) {
        if (_subType == ParkTypePark) {
            self.title = @"违停采集";
        }else if (_subType == ParkTypeReversePark){
            self.title = @"不按朝向";
        }else if (_subType == ParkTypeLockPark){
            self.title = @"违停锁车";
        }
        
    }else if(_illegalType == IllegalTypeThrough){
        self.title = @"闯禁令采集";
        self.subType = ParkTypeThrough;
    }
    
    self.isObserver = NO;

    //初始化请求参数
    self.param = [[IllegalParkSaveParam alloc] init];
    
    //初始化图片数据，加入两个空对象，分别对应车牌近照，违停照片
    //如果有了车牌近照和违停照片则替换掉这两个空对象，如果没有则替换回来空对象
    self.arr_upImages =  [NSMutableArray array];
    [self.arr_upImages addObject:[NSNull null]];
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
    if ([_collectionView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
    
}

#pragma mark - 返回按钮事件

-(void)handleBtnBackClicked{
    
    if (_headView.param.addressRemark || _headView.param.carNo || (_arr_upImages.count > 0 && ![self.arr_upImages[0] isKindOfClass:[NSNull class]] && ![self.arr_upImages[1] isKindOfClass:[NSNull class]])) {
        
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

#pragma mark -  请求网络数据

//如果类型为闯禁令，输入或者识别车牌号的时候需要请求是否需要二次采集，如果需要二次采集则跳到二次采集页面
- (void)judgeNeedSecondCollection:(NSString *)carNumber{
    
    if (carNumber && carNumber.length > 0 && [ShareFun validateCarNumber:carNumber]) {
        
        WS(weakSelf);

        [_headView getRoadId];
        
        IllegalThroughQuerySecManger *manger = [[IllegalThroughQuerySecManger alloc] init];
        manger.carNo = carNumber;
        manger.roadId = _param.roadId;
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        /*code:0 超过90秒有一次采集记录，返回一次采集ID、采集时间，提示“同路段该车于yyyy-MM-dd已被拍照采集”，跳转至二次采集页面
          code:110 提示“同路段当天已有违章行为，请不要重复采集！”
          code:13 提示“同路段该车1分30秒内有采集记录，是否重新采集？”
          code:999 无采集记录,不用任何提示
         */
        SW(strongSelf, weakSelf);
        LxPrintf(@"%ld",(long)manger.responseModel.code);
            
        if (manger.responseModel.code == 0) {
            
            NSNumber * illegalThroughId = manger.responseModel.data[@"id"];
            IllegalSecSaveVC *t_vc = [[IllegalSecSaveVC alloc] init];
            t_vc.illegalThroughId = illegalThroughId;
            if ([_arr_upImages[0] isKindOfClass:[NSMutableDictionary class]]) {
                t_vc.illegal_image = _arr_upImages[0];
            };
            t_vc.saveSuccessBlock = ^{
                [strongSelf handleBeforeCommit];
                
            };
            [strongSelf.navigationController pushViewController:t_vc animated:YES];
            
        }else if (manger.responseModel.code == 13){
            
            [strongSelf showAlertViewWithcontent:manger.responseModel.msg leftTitle:@"取消" rightTitle:@"重新录入" block:^(AlertViewActionType actionType) {
                
                if (actionType == AlertViewActionTypeRight) {
                    
                    [strongSelf judgeIsCanCommit];
                    
                    if (strongSelf.isCanCommit == YES) {
                        [strongSelf handleCommitClicked];
                    }
                    
                }else if (actionType == AlertViewActionTypeLeft){
                
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                
                }
                
            }];
            
        
        }else if (manger.responseModel.code == 110){
        
           [strongSelf showAlertViewWithcontent:manger.responseModel.msg leftTitle:nil rightTitle:@"确定" block:nil];
            
        }else if (manger.responseModel.code == 999){
            //不做处理
            //无任何记录，无需做处理
        }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }

}

// 查询是否有违停记录

- (void)judgeNeedJudgeIllegalRecord:(NSString *)carNumber{
    
    if (carNumber && carNumber.length > 0 && [ShareFun validateCarNumber:carNumber]) {
        
        WS(weakSelf);
    
        [_headView getRoadId];
        IllegalParkQueryRecordManger *manger = [[IllegalParkQueryRecordManger alloc] init];
        manger.carNo = carNumber;
        manger.roadId = _param.roadId;
        manger.type = @(_subType);
        
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf, weakSelf);
            LxPrintf(@"%ld",(long)manger.responseModel.code);
            
            if (manger.responseModel.code == 110) {
                
                [strongSelf showAlertViewWithcontent:manger.responseModel.msg leftTitle:nil rightTitle:@"确定" block:^(AlertViewActionType actionType) {
                    if (actionType == AlertViewActionTypeRight) {
                
                        [strongSelf handleBeforeCommit];

                    }
                }];
                
            }
        
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];

    }


}

//获取道路ID
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
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView   *)collectionView{
    return 1;
}

//返回每组多少个视图
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.arr_upImages count] + 1;
}

//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
   
    [cell setCommonConfig];

    if (indexPath.row == self.arr_upImages.count) {
        
        cell.lb_title.text = @"更多照片";
        cell.imageView.image = [UIImage imageNamed:@"btn_updatePhoto"];
    }else{
        
        if(indexPath.row == 0){
            
            if (_illegalType == IllegalTypePark) {
                
                if (_subType == ParkTypePark) {
                    cell.lb_title.text = @"违停照片";
                }else if (_subType == ParkTypeReversePark){
                    cell.lb_title.text = @"不按朝向照片";
                }else if (_subType == ParkTypeLockPark){
                    cell.lb_title.text = @"违停锁车照片";
                }
                
                //cell.lb_title.text = @"违停照片";
            }else if(_illegalType == IllegalTypeThrough){
                cell.lb_title.text = @"闯禁令照片";
            }
            
        }else if(indexPath.row == 1){
        
            cell.lb_title.text = @"车牌近照";
            
        }else {
            
            if (_illegalType == IllegalTypePark) {
                if (_subType == ParkTypePark) {
                    cell.lb_title.text = [NSString stringWithFormat:@"违停照片%ld",indexPath.row];
                }else if (_subType == ParkTypeReversePark){
                    cell.lb_title.text = [NSString stringWithFormat:@"不按朝向照片%ld",indexPath.row];
                }else if (_subType == ParkTypeLockPark){
                    cell.lb_title.text = [NSString stringWithFormat:@"违停锁车照片%ld",indexPath.row];
                }
                
            }else if(_illegalType == IllegalTypeThrough){
                cell.lb_title.text = [NSString stringWithFormat:@"闯禁令照片%ld",indexPath.row];
            }
        
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
            }else{
                NSString *t_cutImageUrl = [t_dic objectForKey:@"cutImageUrl"];
                
                if (t_cutImageUrl) {
                    
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:t_cutImageUrl] placeholderImage:[UIImage imageNamed:@"btn_updatePhoto"]];
                    
                }
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
        if (!self.headView) {
            self.headView = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headId forIndexPath:indexPath];
             [_headView setDelegate:(id<IllegalParkAddHeadViewDelegate>)self];
            _headView.param = _param;
            _headView.subType = _subType;
            
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
    
    if (indexPath.row == _arr_upImages.count) {
        
        [self showCameraWithType:5 withFinishBlock:^(LRCameraVC *camera) {
            if (camera) {
                
                SW(strongSelf, weakSelf);
                
                if (camera.type == 5) {
                    
                    [strongSelf addUpImageItemToUpImagesWithImageInfo:camera.imageInfo];
                    [strongSelf.collectionView reloadData];
                    
                }
            }
        } isNeedRecognition:NO];
        
    }else if(indexPath.row == 0){
        
        if ([_arr_upImages[0] isKindOfClass:[NSNull class]]) {
            
            BOOL isNeedRecognition = YES;
            if ((self.param.cutImageUrl && [self.param.cutImageUrl length] > 0 && self.param.taketime && [self.param.taketime length] > 0 )|| [_arr_upImages[1] isKindOfClass:[NSMutableDictionary class]]) {
                isNeedRecognition = NO;
            }
            
            [self showCameraWithType:5 withFinishBlock:^(LRCameraVC *camera) {
                if (camera) {
                    SW(strongSelf, weakSelf);
                    if (camera.type == 5) {
                        //替换违停照片的图片
                        
                        if (strongSelf.illegalType == IllegalTypePark) {
                            [strongSelf replaceUpImageItemToUpImagesWithImageInfo:camera.imageInfo remark:@"违停照片" replaceIndex:0];
                            [strongSelf.collectionView reloadData];
                        }else if(strongSelf.illegalType == IllegalTypeThrough){
                            [strongSelf replaceUpImageItemToUpImagesWithImageInfo:camera.imageInfo remark:@"闯禁令照片" replaceIndex:0];
                            [strongSelf.collectionView reloadData];
                        }
                        
                        if (camera.isIllegal) {
                            //识别之后所做的操作
                            
                            if (camera.commonIdentifyResponse && camera.commonIdentifyResponse.cutImageUrl && [camera.commonIdentifyResponse.cutImageUrl length] > 0) {
                                
                                strongSelf.param.cutImageUrl = camera.commonIdentifyResponse.cutImageUrl;
                                strongSelf.param.taketime = [ShareFun getCurrentTime];
                                
                                [strongSelf replaceUpImageItemToUpImagesWithImageInfo:nil remark:@"车牌近照" replaceIndex:1];
                                
                                [strongSelf.headView takePhotoToDiscernmentWithCarNumber:camera.commonIdentifyResponse.carNo withCarcolor:camera.carColor];
                                
                                [strongSelf listentCarNumber];
                                
                            }
                    
                            
                            [strongSelf.collectionView reloadData];
                            
                        }
                       
                    }
                    
                }
                
            } isNeedRecognition:isNeedRecognition];
            
        }else{
            //当存在车牌近照的时候,弹出图片浏览器
            [self showPhotoBrowserWithIndex:0];
        }
        
    }else if(indexPath.row == 1){
        
        if ([_arr_upImages[1] isKindOfClass:[NSNull class]]) {
            
            [self showCameraWithType:1 withFinishBlock:^(LRCameraVC *camera) {
                if (camera) {
                    
                    SW(strongSelf, weakSelf);
                    
                    if (camera.type == 1) {
                        
                        //替换车牌近照的图片
                        if (camera.commonIdentifyResponse && camera.commonIdentifyResponse.cutImageUrl && [camera.commonIdentifyResponse.cutImageUrl length] > 0) {
                            
                            strongSelf.param.cutImageUrl = camera.commonIdentifyResponse.cutImageUrl;
                            strongSelf.param.taketime = [ShareFun getCurrentTime];
                            
                            [strongSelf replaceUpImageItemToUpImagesWithImageInfo:nil remark:@"车牌近照" replaceIndex:1];
                            
                            //识别之后所做的操作
                            [strongSelf.headView takePhotoToDiscernmentWithCarNumber:camera.commonIdentifyResponse.carNo withCarcolor:camera.carColor];
                            
                            [strongSelf listentCarNumber];
                            
                        }else{
                             [strongSelf replaceUpImageItemToUpImagesWithImageInfo:camera.imageInfo remark:@"车牌近照" replaceIndex:1];
                            
                        }
                        
                        [strongSelf.collectionView reloadData];
                        
                    }
                }
            } isNeedRecognition:NO];
            
        }else{
            
            //当违停照片存在的情况下,弹出图片浏览器,如果车牌近照有的情况下图片索引为1,如果没有则图片索引变成0
            //
            if ([_arr_upImages[0] isKindOfClass:[NSNull class]]) {
                [self showPhotoBrowserWithIndex:0];
            }else {
                [self showPhotoBrowserWithIndex:1];
            }
    
        }
    
    }else {
        //当更多照片存在的情况下,弹出图片浏览器,下面判断图片索引
        if ([_arr_upImages[0] isKindOfClass:[NSNull class]] && [_arr_upImages[1] isKindOfClass:[NSNull class]]) {
            [self showPhotoBrowserWithIndex:indexPath.row-2];
        }else {
            if ([_arr_upImages[0] isKindOfClass:[NSNull class]] || [_arr_upImages[1] isKindOfClass:[NSNull class]]) {
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

#pragma mark - KVO,监听看是否可以提交，用于提交按钮是否可以点击

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"isCanCommit"] && object == _headView) {
        
        [self judgeIsCanCommit];
        
    }

}

#pragma mark - FootViewDelegate 点击提交按钮事件

- (void)handleCommitClicked{
    
    if (_param.carNo) {
        
        if([ShareFun validateCarNumber:_param.carNo] == NO){
            [LRShowHUD showError:@"车牌号格式错误" duration:1.f];
            return;
        }
        
    }
    
    [NetworkStatusMonitor StartWithBlock:^(NSInteger NetworkStatus) {
        
        //大类 : 0没有网络 1为WIFI网络 2/6/7为2G网络  3/4/5/8/9/11/12为3G网络
        //10为4G网络
        if (NetworkStatus != 0 && NetworkStatus != 10 && NetworkStatus != 1) {
            [ShareFun showTipLable:@"当前非4G网络,传输速度受影响"];
        }
        
        [_param saveInDB];
    }];
    
    
    [self configParamInFilesAndRemarksAndTimes];
    
    LxDBObjectAsJson(_param);
    WS(weakSelf);
    
    if (_illegalType == IllegalTypePark) {
        
        //违停请求
        _param.type = @(_subType);
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
                
                if (manger.responseModel.msg && manger.responseModel.msg.length > 0 && ![manger.responseModel.msg isEqualToString:@"success"]) {
                    [strongSelf showAlertViewWithcontent:manger.responseModel.msg leftTitle:nil rightTitle:@"确定" block:^(AlertViewActionType actionType) {
                        
                    }];
                }
                
                [strongSelf handleBeforeCommit];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ILLEGALPARK_SUCCESS object:nil];
                
            }else if (manger.responseModel.code == CODE_FAILED){
                
                [strongSelf showAlertViewWithcontent:manger.responseModel.msg leftTitle:nil rightTitle:@"确定" block:^(AlertViewActionType actionType) {
                    if (actionType == AlertViewActionTypeRight) {
                        
                        [strongSelf handleBeforeCommit];
                        
                    }
                }];
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            if ([request.error.localizedDescription isEqualToString:@"请求超时。"]) {
                [LRShowHUD showError:@"请重新提交!" duration:1.5f];
            }
        }];
        
    }else if (_illegalType == IllegalTypeThrough){
        
        //违禁令请求
        IllegalThroughSaveManger *manger = [[IllegalThroughSaveManger alloc] init];
        manger.param = _param;
        [manger configLoadingTitle:@"提交"];
        
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            SW(strongSelf, weakSelf);
            
            //异步请求通用路名ID,这里需要请求的原因是当传入的roadID为0的情况下，需要重新去服务器里面拉取路名来匹配
            if ([strongSelf.param.roadId isEqualToNumber:@0]) {
               [ShareValue sharedDefault].roadModels = nil;
               [strongSelf getCommonRoad];
            }
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                
                [strongSelf handleBeforeCommit];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ILLEGALTHROUGH_SUCCESS object:nil];
                
            }else if (manger.responseModel.code == 110){
            
                [strongSelf showAlertViewWithcontent:manger.responseModel.msg leftTitle:nil rightTitle:@"确定" block:^(AlertViewActionType actionType) {
                    
                    if (actionType == AlertViewActionTypeRight) {
                        NSNumber * illegalThroughId = manger.responseModel.data[@"id"];
                        IllegalSecSaveVC *t_vc = [[IllegalSecSaveVC alloc] init];
                        t_vc.illegalThroughId = illegalThroughId;
                        t_vc.saveSuccessBlock = ^{
                            
                            [strongSelf handleBeforeCommit];
                        };
                        [strongSelf.navigationController pushViewController:t_vc animated:YES];
                    }
                }];
               
            }else if (manger.responseModel.code == 100){
            
                [strongSelf showAlertViewWithcontent:manger.responseModel.msg leftTitle:nil rightTitle:@"确定" block:nil];
               
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            if ([request.error.localizedDescription isEqualToString:@"请求超时。"]) {
                [LRShowHUD showError:@"请重新提交!" duration:1.5f];
            }
        }];
    }

}

#pragma mark - HeadViewDelegate点击识别按钮返回回来的数据

- (void)recognitionCarNumber:(LRCameraVC *)cameraVC{

    if (cameraVC.commonIdentifyResponse.cutImageUrl) {
        
        _param.cutImageUrl = cameraVC.commonIdentifyResponse.cutImageUrl;
        _param.taketime    = [ShareFun getCurrentTime];
        [self replaceUpImageItemToUpImagesWithImageInfo:nil remark:@"车牌近照" replaceIndex:1];
        
    }else{
        [self replaceUpImageItemToUpImagesWithImageInfo:cameraVC.imageInfo remark:@"车牌近照" replaceIndex:1];
    }
   
    [_collectionView reloadData];
    
    [self listentCarNumber];
    
}

#pragma mark - IllegalParkAddHeadViewDelegate

- (void)listentCarNumber{

    if (_illegalType == IllegalTypeThrough) {
        [self judgeNeedSecondCollection:self.param.carNo];
    }else if(_illegalType == IllegalTypePark){
        [self judgeNeedJudgeIllegalRecord:self.param.carNo];
    }

}

#pragma mark - 上传之后页面处理

- (void)handleBeforeCommit{

    [_headView strogeLocationBeforeCommit];
    
    [_arr_upImages removeAllObjects];
    [_arr_upImages addObject:[NSNull null]];
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
   
    if (index == 1) {
        if (self.param.cutImageUrl) {
            [t_dic setObject:self.param.cutImageUrl forKey:@"cutImageUrl"];
            [t_dic setObject:self.param.taketime    forKey:@"taketime"];
        }
       
    }
    
    [t_dic setObject:@0 forKey:@"isMore"];
    
    [self.arr_upImages  replaceObjectAtIndex:index withObject:t_dic];
    
    //判断是否可以提交
    [self judgeIsCanCommit];
    
}

//添加图片到arr_upImages数组中
- (void)addUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo{

    imageFileInfo.name = key_files;
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    [t_dic setObject:imageFileInfo forKey:@"files"];
    [t_dic setObject:imageFileInfo.fileName forKey:@"remarks"];
    [t_dic setObject:[ShareFun getCurrentTime] forKey:@"taketimes"];
    [t_dic setObject:@1 forKey:@"isMore"];
    [self.arr_upImages addObject:t_dic];
    
}

- (void)configParamInFilesAndRemarksAndTimes{
    
    if (_arr_upImages && _arr_upImages.count > 0) {
        
        LxDBObjectAsJson(_arr_upImages);
        
        NSMutableArray *t_arr_files     = [NSMutableArray array];
        NSMutableArray *t_arr_remarks   = [NSMutableArray array];
        NSMutableArray *t_arr_taketimes = [NSMutableArray array];
        
        NSInteger j = 2;
        
        for (int i = 0; i < _arr_upImages.count; i++) {
            
            if([_arr_upImages[i] isKindOfClass:[NSMutableDictionary class]]){
                
                NSMutableDictionary *t_dic  = _arr_upImages[i];
                ImageFileInfo *imageInfo    = [t_dic objectForKey:@"files"];
                
                if (imageInfo) {
                    
                    NSString *t_title       = nil;
                    if ([[t_dic objectForKey:@"isMore"] isEqualToNumber:@0]) {
                        
                        t_title = [t_dic objectForKey:@"remarks"];
                        
                    }else if([[t_dic objectForKey:@"isMore"] isEqualToNumber:@1]){
                        
                        if (self.illegalType == IllegalTypePark) {
                            if (_subType == ParkTypePark) {
                                t_title = [NSString stringWithFormat:@"违停照片%ld",j];
                            }else if (_subType == ParkTypeReversePark){
                                t_title = [NSString stringWithFormat:@"不按朝向照片%ld",j];
                            }else if (_subType == ParkTypeLockPark){
                                t_title = [NSString stringWithFormat:@"违停锁车照片%ld",j];
                            }
                            
                            
                        }else if(self.illegalType == IllegalTypeThrough){
                            t_title = [NSString stringWithFormat:@"闯禁令照片%ld",j];
                        }
                        
                        j++;
                    }
                    
                    NSString *t_taketime    = [t_dic objectForKey:@"taketimes"];
                    [t_arr_files     addObject:imageInfo];
                    [t_arr_remarks   addObject:t_title];
                    [t_arr_taketimes addObject:t_taketime];
                    
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
    
                if (self.illegalType == IllegalTypePark) {
                            
                    if ([t_str isEqualToString:@"车牌近照"] || [t_str isEqualToString:@"违停照片"]) {
    
                        if ([t_str isEqualToString:@"车牌近照"]) {
                            self.param.cutImageUrl = nil;
                            self.param.taketime = nil;
                        }
    
                        [self.arr_upImages replaceObjectAtIndex:i withObject:[NSNull null]];
    
                    }else{
    
                        [self.arr_upImages removeObject:t_dic];
    
                    }
                            
                    [self.collectionView reloadData];
                            
                }else if (self.illegalType == IllegalTypeThrough){
                            
                    if ([t_str isEqualToString:@"车牌近照"] || [t_str isEqualToString:@"闯禁令照片"]) {
    
                        if ([t_str isEqualToString:@"车牌近照"]) {
                            self.param.cutImageUrl = nil;
                            self.param.taketime = nil;
                        }
    
                        [self.arr_upImages replaceObjectAtIndex:i withObject:[NSNull null]];
    
                    }else{
    
                        [self.arr_upImages removeObject:t_dic];

                    }
    
                    [self.collectionView reloadData];
                    
                }
                
                
                [self judgeIsCanCommit];
                
            }
            
        }
        
    }

}

#pragma mark - 判断违停或者闯禁令是否可以提交

- (void)judgeIsCanCommit{
    
    if (_headView.isCanCommit == YES && ![_arr_upImages[0] isKindOfClass:[NSNull class]] && ![_arr_upImages[1] isKindOfClass:[NSNull class]]) {
        self.isCanCommit = YES;
    }else{
        self.isCanCommit = NO;
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
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
    
    LxPrintf(@"IllegalParkVC dealloc");

}

@end
