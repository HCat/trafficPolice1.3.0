//
//  MotorbikeAddVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/22.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "MotorbikeAddVC.h"
#import "MotorbikeAddViewModel.h"
#import "AlertView.h"
#import "SRAlertView.h"


#import "IllegalRecordVC.h"
#import "PersonLocationVC.h"
#import "SearchLocationVC.h"
#import "UserModel.h"
#import "BaseImageCollectionCell.h"
#import "ParkCameraVC.h"

#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"
#import <UIImageView+WebCache.h>
#import <math.h>


@interface MotorbikeAddVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *v_images;

@property (weak, nonatomic) IBOutlet UITextField *tf_carNo;

@property (weak, nonatomic) IBOutlet UITextField *tf_roadName;

@property (weak, nonatomic) IBOutlet UITextField *tf_address;
@property (weak, nonatomic) IBOutlet UIButton *btn_userLocation;
@property (weak, nonatomic) IBOutlet UIImageView *image_userLocation;

@property (weak, nonatomic) IBOutlet UITextField *tf_addressRemark;
@property (weak, nonatomic) IBOutlet UIButton *btn_commit;

@property (assign, nonatomic) BOOL btnType;
@property (nonatomic,strong) RACDisposable * disposable;

@property (strong, nonatomic) MotorbikeAddViewModel * viewModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_scrollView_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_images_height;



@property(nonatomic,strong) UICollectionView * collectionView;  //图片的collectionView

@end

@implementation MotorbikeAddVC

- (instancetype)init{
    
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChange) name:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil];
        self.viewModel = [[MotorbikeAddViewModel alloc] init];
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)lr_configUI{
    
    @weakify(self);
    

    self.layout_scrollView_top.constant = Height_NavBar;
    
    self.btn_commit.layer.cornerRadius = 5.f;
    self.btn_commit.layer.masksToBounds = YES;
    
    
    [self.tf_roadName setDelegate:(id<UITextFieldDelegate> _Nullable)self];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置item的行间距和列间距
    layout.minimumInteritemSpacing = 12.5f;
    layout.minimumLineSpacing = 10;
    
    // 设置item的大小
    float width=(SCREEN_WIDTH - 12.5f*2 - 10.0f*2)/3.f;
    layout.itemSize = CGSizeMake(width, width+27);
    
    // 设置每个分区的 上左下右 的内边距
    layout.sectionInset = UIEdgeInsetsMake(5, 10 ,15, 10);
    
    // 设置区头和区尾的大小
    layout.headerReferenceSize = CGSizeMake(0, 0);
    layout.footerReferenceSize = CGSizeMake(0, 0);
    
    // 设置分区的头视图和尾视图 是否始终固定在屏幕上边和下边
    layout.sectionFootersPinToVisibleBounds = YES;
    
    // 设置滚动条方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    
    collectionView.showsHorizontalScrollIndicator = NO;   //是否显示滚动条
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.scrollEnabled = NO;  //滚动使能
    //3、添加到控制器的view
    [self.v_images addSubview:collectionView];
    self.v_images.clipsToBounds = YES;
    self.collectionView = collectionView;
    //4、布局
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.v_images);
    }];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[BaseImageCollectionCell class] forCellWithReuseIdentifier:@"BaseImageCollectionCellID"];
    
    [self zx_leftClickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
        @strongify(self);
        [self handleBtnBackClicked];
    }];
    
    
#pragma mark - 初始化所做的操作
    self.btnType = [LocationStorage sharedDefault].isMotorBike;
    
#pragma mark - 提交按钮事件
    [[self.btn_commit rac_signalForControlEvents:UIControlEventTouchUpInside ] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        if ([UserModel isPermissionForMotorBikeAdd] == NO) {
            [LRShowHUD showError:@"请联系管理员授权" duration:1.5f];
            return;
        }
        
        [NetworkStatusMonitor StartWithBlock:^(NSInteger NetworkStatus) {
            
            //大类 : 0没有网络 1为WIFI网络 2/6/7为2G网络  3/4/5/8/9/11/12为3G网络
            //10为4G网络
            [NetworkStatusMonitor StopMonitor];
            if (NetworkStatus != 10 && NetworkStatus != 1) {
                [ShareFun showTipLable:@"当前非4G网络,传输速度受影响"];
            }
            
        }];
        
        [self.viewModel configParamInFilesAndRemarksAndTimes];
        [self.viewModel.command_commit execute:nil];
        
    }];
    

#pragma mark - 手动定位按钮事件
    [[self.btn_userLocation rac_signalForControlEvents:UIControlEventTouchUpInside ] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        PersonLocationVC *t_personLocationVc = [PersonLocationVC new];
        t_personLocationVc.block = ^(LocationStorageModel *model) {
            
            [self stopLocationAction:model];

        };
        [self.navigationController pushViewController:t_personLocationVc animated:YES];
        
        
    }];
    
    
}


- (void)lr_bindViewModel{
    
    
    @weakify(self);
    
#pragma mark - 判断是否可以提交
    
    [RACObserve(self.viewModel, isCanCommit) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            self.btn_commit.enabled = YES;
            [self.btn_commit setBackgroundColor:DefaultBtnColor];
            
        }else{
            self.btn_commit.enabled = NO;
            [self.btn_commit setBackgroundColor:DefaultBtnNuableColor];
            
        }
        
    }];
 
#pragma mark - 提交成功之后所做的处理
    [self.viewModel.command_commit.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
    
        if ([x isEqualToString:@"提交成功"]) {
        
             if ([self.viewModel.param.roadId isEqualToNumber:@0]) {
                 [ShareValue sharedDefault].roadModels = nil;
                 [[ShareValue sharedDefault] roadModels];
            }
            
            [self.viewModel handleBeforeCommit];
            [self.collectionView reloadData];
            [self handleAfterCommitForUI];
            [[LocationHelper sharedDefault] startLocation];
            
        }
        
    }];
    
#pragma mark - 检查违停采集是否拥有违停记录
    
    [self.viewModel.command_illegalRecord.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        if ([x isKindOfClass:[RACTuple class]]) {
            RACTupleUnpack(NSNumber * code,IllegalParkCarNoRecordReponse * reponse,NSString * msg) = x;
            
            NSLog(@"%@",msg);
            
            if ([code isEqualToNumber:@110]){
                //提示“同路段当天已有违章行为，请不要重复采集！”
                [self.tf_carNo resignFirstResponder];
                IllegalListView *view = [IllegalListView initCustomView];
                view.block = ^(ParkAlertActionType actionType) {
                    @strongify(self);
                    if (actionType == ParkAlertActionTypeLeft){
                        [self.navigationController popViewControllerAnimated:YES];
                    }else if (actionType == ParkAlertActionTypeRight){
                        [self.viewModel handleBeforeCommit];
                        [self.collectionView reloadData];
                        [self handleAfterCommitForUI];
                        [[LocationHelper sharedDefault] startLocation];
                    }
                    
                };
                view.btnTitleString = @"重新采集";
                view.illegalList = reponse.illegalList;
                view.deckCarNo = reponse.deckCarNo;
                view.selectedBlock = ^(NSNumber *illegalId) {
                    //单条违章数据查看
                    @strongify(self);
                    IllegalRecordVC *vc =[[IllegalRecordVC alloc] init];
                    vc.illegalId = illegalId;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                };
                [AlertView showWindowWithIllegalListViewWith:view inView:self.view];
                
            
            }else if ([code isEqualToNumber:@1]){
                //提示24小时到48小时内违章的提醒，如果无违章则为套牌提醒
                if (reponse.illegalList && reponse.illegalList.count > 0) {
                    [self.tf_carNo resignFirstResponder];
                    IllegalListView *view = [IllegalListView initCustomView];
                    view.block = ^(ParkAlertActionType actionType) {
                        @strongify(self);
                        if (actionType == ParkAlertActionTypeLeft){
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
                    //套牌提醒
                    [self.tf_carNo resignFirstResponder];
                    [self showAlertViewWithcontent:reponse.deckCarNo leftTitle:@"退出" rightTitle:@"继续采集" block:^(AlertViewActionType actionType) {
                        
                        if (actionType == AlertViewActionTypeLeft){
                            
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        }
                        
                    }];
                    
                }
            }
            
        }
        
    }];



#pragma mark - 判断定位功能是否开启做相应的UI操作
    [RACObserve(self, btnType) subscribeNext:^(NSNumber * x) {
        @strongify(self);
        self.viewModel.param.isManualPos = @(!x);
        if ([x boolValue]) {
            self.zx_navRightBtn.isTintColor = YES;
            [self.zx_navRightBtn setImage:[UIImage imageNamed:@"btn_dailyPatrol_on"] forState:UIControlStateNormal];
            [self.zx_navRightBtn setTitle:@"定位" forState:UIControlStateNormal];
            self.btn_userLocation.enabled = NO;
            [self.btn_userLocation setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            [self zx_rightClickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
                @strongify(self);
                
                [[LocationStorage sharedDefault] closeLocation:ParkTypeMotorbikeAdd];
                [self stopLocationAction:[LocationStorage sharedDefault].motorBike];

                [[LocationHelper sharedDefault] startLocation];
                
                self.btnType = NO;
            }];
            
            
        }else{
            
            self.zx_navRightBtn.isTintColor = YES;
            [self.zx_navRightBtn setImage:[UIImage imageNamed:@"btn_dailyPatrol_off"] forState:UIControlStateNormal];
            [self.zx_navRightBtn setTitle:@"定位" forState:UIControlStateNormal];
            self.btn_userLocation.enabled = YES;
            [self.btn_userLocation setTitleColor:UIColorFromRGB(0x3396FC) forState:UIControlStateNormal];
            [self zx_rightClickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
                @strongify(self);
            
                [[LocationStorage sharedDefault] startLocation:ParkTypeMotorbikeAdd];
                
                self.tf_roadName.text = nil;
                self.tf_address.text = nil;
                
                self.viewModel.param.longitude      = nil;
                self.viewModel.param.latitude       = nil;
                self.viewModel.param.roadId         = nil;
                self.viewModel.param.roadName       = nil;
                self.viewModel.param.address        = nil;
                
                [[LocationHelper sharedDefault] startLocation];
                
                self.btnType = YES;
                
            }];
            
        }
        
        
        
    }];
    
    [self paramRACObserver];
    
    [[LocationHelper sharedDefault] startLocation];
    
    if ([LocationStorage sharedDefault].isMotorBike == NO) {
        [self stopLocationAction:[LocationStorage sharedDefault].motorBike];
    }
    

}


#pragma mark - 返回按钮事件

-(void)handleBtnBackClicked{
    
    if (self.viewModel.param.addressRemark || self.viewModel.param.carNo || (self.viewModel.arr_upImages.count > 0 && ![self.viewModel.arr_upImages[0] isKindOfClass:[NSNull class]] )) {
        
        WS(weakSelf);
        
        [AlertView showWindowWithIllegalParkAlertViewSelectAction:^(ParkAlertActionType actionType) {
            if(actionType == ParkAlertActionTypeRight) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
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

#pragma mark - 选择路段按钮事件
- (void)handlebtnChoiceLocationClicked{
    
    @weakify(self);
    
    SearchLocationVC *t_searchLocationvc = [SearchLocationVC new];
    t_searchLocationvc.searchType = SearchLocationTypeIllegal;
    t_searchLocationvc.arr_content = self.viewModel.codes;
    t_searchLocationvc.arr_temp = self.viewModel.codes;
    t_searchLocationvc.search_text = self.viewModel.param.roadName;
    
    t_searchLocationvc.getRoadBlock = ^(CommonGetRoadModel *model) {
        @strongify(self);
        self.tf_roadName.text = model.getRoadName;
        self.viewModel.param.roadId = model.getRoadId;
        self.viewModel.param.roadName = model.getRoadName;

    };
    [self.navigationController pushViewController:t_searchLocationvc animated:YES];
    
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
                
                if ([t_str isEqualToString:@"摩托车照片"]) {
                    
                    [self.viewModel.arr_upImages replaceObjectAtIndex:i withObject:[NSNull null]];
                    
                    if (i == 0) {
                        self.viewModel.first = self.viewModel.arr_upImages[0];
                    }
                    
                    
                }else{
                    
                    [self.viewModel.arr_upImages removeObject:t_dic];
                    
                }
                
                [self.collectionView reloadData];
                
            }
            
        }
        
    }
    
}


#pragma mark - 关闭定位之后所做的赋值操作

- (void)stopLocationAction:(LocationStorageModel *)model{
    
    self.tf_roadName.text = model.streetName;
    self.tf_address.text     = model.address;
    
    self.viewModel.param.roadName      = model.streetName;
    self.viewModel.param.address       = model.address;
    [self.viewModel getRoadId];
        
}

#pragma mark - 提交之后的UI处理

- (void)handleAfterCommitForUI{
    
    //采集之后的UI处理
    self.tf_roadName.text    = nil;
    self.tf_address.text     = nil;
    self.tf_carNo.text       = nil;
    
    if (self.btnType != 1) {
        [self stopLocationAction:[LocationStorage sharedDefault].motorBike];
    }
    if (self.tf_addressRemark.text.length > 0) {
        self.viewModel.param.addressRemark = self.tf_addressRemark.text;
    }

    self.viewModel.param.isManualPos = @(!self.btnType);
    
    [self paramRACObserver];
}

- (void)paramRACObserver{
    
    @weakify(self);
#pragma mark - 判断路段是否为电子抓拍路段避免设备重复采集问题
    [[RACObserve(self.viewModel.param, roadId) distinctUntilChanged] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (x && ![x isEqualToNumber:@0]) {
            
            IllegalCheckRoadCollectManger * manger = [[IllegalCheckRoadCollectManger alloc] init];
            manger.roadId = x;
            
            [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                
                if (manger.responseModel.code == CODE_SUCCESS) {
                    if ([manger.illegalResponse.isCollect isEqualToNumber:@0]) {
                
                        SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"温馨提示"
                                                                            message:@"该路段为违法行为电子抓拍路段"
                                                                    leftActionTitle:@"确定"
                                                                   rightActionTitle:@"退出"
                                                                     animationStyle:AlertViewAnimationNone
                                                                       selectAction:^(AlertViewActionType actionType) {
                            if (actionType == AlertViewActionTypeRight) {
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            
                        }];
                        alertView.blurCurrentBackgroundView = NO;
                        [alertView show];
                    }
                }
                
                
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                
            }];
            
        }

    }];
    
#pragma mark - 弹出路段选择界面
    if (self.disposable == nil) {
        
        self.disposable = [[RACObserve(self.viewModel.param, roadName) distinctUntilChanged] subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            if (x) {
                
                if (([[UserModel getUserModel].orgCode isEqualToString:@"000000"] || [[UserModel getUserModel].orgCode isEqualToString:@"SSJJ"] ) && [[UserModel getUserModel].secRoadStatus isEqualToNumber:@1] ) {
                    
                    IllegalRoadView *view = [IllegalRoadView initCustomView];
                    view.block = ^(CommonGetRoadModel * model) {
                        @strongify(self);
                        self.tf_roadName.text = model.getRoadName;
                        self.viewModel.param.roadId = model.getRoadId;
                        self.viewModel.param.roadName = model.getRoadName;
                    };
                    view.arr_content = self.viewModel.codes;
                    view.roadName = self.viewModel.param.roadName;
                    [AlertView showWindowWithIllegalRoadViewWith:view inView:self.view];
                    
                }
                
                [self.disposable dispose];
                self.disposable = nil;
                
            }
            
        }];
        
    }
    
    RAC(self.viewModel.param, addressRemark) = [self.tf_addressRemark.rac_textSignal skip:1];
    RAC(self.viewModel.param, carNo) = [self.tf_carNo.rac_textSignal skip:1];
    RAC(self.viewModel.param, address) = [self.tf_address.rac_textSignal skip:1];
    

}




#pragma mark - 重新定位之后的通知

-(void)locationChange{
    
    if (self.btnType == 1) {
        
        self.tf_roadName.text = [LocationHelper sharedDefault].streetName;
        self.tf_address.text     = [LocationHelper sharedDefault].address;
        self.viewModel.param.roadName      = [LocationHelper sharedDefault].streetName;
        self.viewModel.param.address       = [LocationHelper sharedDefault].address;
        
        [self.viewModel getRoadId];
        
    }

    self.viewModel.param.longitude     = @([LocationHelper sharedDefault].longitude);
    self.viewModel.param.latitude      = @([LocationHelper sharedDefault].latitude);
    
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == self.tf_roadName) {
        [self handlebtnChoiceLocationClicked];
        return NO;
    }
    
    return YES;
    
}


#pragma mark - UICollectionView Data Source

//返回多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView   *)collectionView{
    return 1;
}

//返回每组多少个视图
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    float width=(SCREEN_WIDTH - 12.5f*2 - 10.0f*2)/3.f;
    
    int i = ceilf(([self.viewModel.arr_upImages count] + 1)/3.0);
    if (i < 1) {
        i = 1;
    }
    self.layout_images_height.constant = 48+30+(width+27)*i+10*(i-1);
    
    return [self.viewModel.arr_upImages count];
}

//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BaseImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BaseImageCollectionCellID" forIndexPath:indexPath];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 5.f;
    cell.isNeedTitle = YES;
    cell.lb_title.textColor = UIColorFromRGB(0x666666);
    cell.lb_title.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    cell.layout_imageWithLb.constant = 5.f;
    
    cell.lb_title.text = @"摩托车照片";
    
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
    
    return cell;
}

#pragma mark - UICollectionView Delegate method

//选中某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    
    if(indexPath.row == 0){
        
        if ([self.viewModel.arr_upImages[0] isKindOfClass:[NSNull class]]) {
            
            [self showCameraWithType:2 withFinishBlock:^(ImageFileInfo *imageInfo) {
                @strongify(self);
                [self.viewModel replaceUpImageItemToUpImagesWithImageInfo:imageInfo remark:@"摩托车照片" replaceIndex:0];
                
                [self.collectionView reloadData];
            }];
            

        }else{
            //当存在车牌近照的时候,弹出图片浏览器
            [self showPhotoBrowserWithIndex:0];
        }
        
    }
    
}

#pragma mark - scrollViewDelegate

//用于滚动到顶部的时候使得tableView不能再继续下拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView != _collectionView){
        if (scrollView.contentOffset.y < 0) {
            CGPoint position = CGPointMake(0, 0);
            [scrollView setContentOffset:position animated:NO];
            return;
        }
    }
}



- (void)dealloc{
    NSLog(@"MotorbikeAddVC dealloc");
}

@end
