//
//  ThroughManageVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/10.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ThroughManageVC.h"
#import "ThroughManageViewModel.h"
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
#import "IllegalSecSaveVC.h"
#import "CertificateView.h"
#import "BottomView.h"
#import "LRCameraVC.h"
#import "ThroughManageShowList.h"
#import "VehicleTypeVC.h"

@interface ThroughManageVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *v_images;

@property (weak, nonatomic) IBOutlet UIButton *btn_carNoNumer;
@property (weak, nonatomic) IBOutlet UIImageView *image_carNoNumber;

@property (weak, nonatomic) IBOutlet UITextField *tf_carNo;
@property (weak, nonatomic) IBOutlet UIButton *btn_carNo;

@property (weak, nonatomic) IBOutlet UITextField *tf_userName;
@property (weak, nonatomic) IBOutlet UIButton *btn_userName;



@property (weak, nonatomic) IBOutlet UITextField *tf_userNumber;
@property (weak, nonatomic) IBOutlet UIButton *btn_userNumber;
@property (weak, nonatomic) IBOutlet UIImageView *image_userNumber;

@property (weak, nonatomic) IBOutlet UITextField *tf_roadName;

@property (weak, nonatomic) IBOutlet UITextField *tf_address;
@property (weak, nonatomic) IBOutlet UIButton *btn_userLocation;
@property (weak, nonatomic) IBOutlet UIImageView *image_userLocation;

@property (weak, nonatomic) IBOutlet UITextField *tf_addressRemark;

@property (weak, nonatomic) IBOutlet UIButton *btn_commit;

@property (assign, nonatomic) BOOL btnType;
@property (nonatomic,strong) RACDisposable * disposable;

@property (strong, nonatomic) ThroughManageViewModel * viewModel;


@property (weak, nonatomic) IBOutlet UILabel *lb_vehicleType_tip;
@property (weak, nonatomic) IBOutlet UILabel *lb_vehicleType_title;
@property (weak, nonatomic) IBOutlet UITextField *tf_vehicleType;
@property (weak, nonatomic) IBOutlet UIImageView *image_vehicleType;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_addressRemark_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_view_height;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_scrollView_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_images_height;



@property(nonatomic,strong) UICollectionView * collectionView;  //图片的collectionView

@end

@implementation ThroughManageVC

- (instancetype)init{
    
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChange) name:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil];
        self.viewModel = [[ThroughManageViewModel alloc] init];
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
    
//    self.btn_carNoNumer.hidden = YES;
//    self.image_carNoNumber.hidden = YES;
//
//    self.btn_userNumber.hidden = YES;
//    self.image_userNumber.hidden = YES;
    
    self.btn_carNo.layer.cornerRadius = 5.f;
    self.btn_carNo.layer.masksToBounds = YES;
    
    self.btn_userName.layer.cornerRadius = 5.f;
    self.btn_userName.layer.masksToBounds = YES;
    
    self.btn_commit.layer.cornerRadius = 5.f;
    self.btn_commit.layer.masksToBounds = YES;
    
    if ([[UserModel getUserModel].orgCode isEqualToString:@"000000"] || [[UserModel getUserModel].orgCode isEqualToString:@"ZPJJ"] ){
        
        self.lb_vehicleType_tip.hidden = NO;
        self.lb_vehicleType_title.hidden = NO;
        self.tf_vehicleType.hidden = NO;
        self.image_vehicleType.hidden = NO;
        self.layout_addressRemark_top.constant = 110;
        self.layout_view_height.constant = 708.5;
        
    }else{
        
        self.lb_vehicleType_tip.hidden = YES;
        self.lb_vehicleType_title.hidden = YES;
        self.tf_vehicleType.hidden = YES;
        self.image_vehicleType.hidden = YES;
        self.layout_addressRemark_top.constant = 20;
        self.layout_view_height.constant = 628.5;
        
    }
    
    
    [self.tf_roadName setDelegate:(id<UITextFieldDelegate> _Nullable)self];
    [self.tf_vehicleType setDelegate:(id<UITextFieldDelegate> _Nullable)self];
    
    
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
    self.btnType = [LocationStorage sharedDefault].isThroughManage;
    
#pragma mark - 提交按钮事件
    [[self.btn_commit rac_signalForControlEvents:UIControlEventTouchUpInside ] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        if ([UserModel isPermissionForThroughCollect] == NO) {
            [LRShowHUD showError:@"请联系管理员授权" duration:1.5f];
            return;
        }
        
        if ([[UserModel getUserModel].orgCode isEqualToString:@"000000"] || [[UserModel getUserModel].orgCode isEqualToString:@"ZPJJ"] ){
            
            if ([[UserModel getUserModel].checkCollect isEqualToNumber:@0]) {
                [LRShowHUD showError:@"未配置设备编号" duration:1.5f];
                return;
            }
            
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
    
#pragma mark - 车牌识别按钮按钮事件
    [[self.btn_carNo rac_signalForControlEvents:UIControlEventTouchUpInside ] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self showCameraWithType:1 withFinishBlock:^(ImageFileInfo * imageInfo) {
            @strongify(self);
            [self.viewModel.command_identifyCarNo execute:imageInfo];
            [self.viewModel replaceUpImageItemToUpImagesWithImageInfo:imageInfo remark:@"车牌近照" replaceIndex:1];
            [self.collectionView reloadData];
            
        }];
        
    }];
    

#pragma mark - 车牌历史采集记录按钮事件
    [[self.btn_carNoNumer rac_signalForControlEvents:UIControlEventTouchUpInside ] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        if (self.viewModel.param.carNo && self.viewModel.param.carNo.length > 6) {
            ThroughManageShowViewModel * viewModel = [[ThroughManageShowViewModel alloc] init];
            viewModel.param.carNo = self.viewModel.param.carNo;
            ThroughManageShowList * vc = [[ThroughManageShowList alloc] initWithViewModel:viewModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
    
#pragma mark - 身份证按钮事件
    [[self.btn_userNumber rac_signalForControlEvents:UIControlEventTouchUpInside ] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.viewModel.param.identNo && self.viewModel.param.identNo.length > 17) {
            ThroughManageShowViewModel * viewModel = [[ThroughManageShowViewModel alloc] init];
            viewModel.param.identNo = self.viewModel.param.identNo;
            ThroughManageShowList * vc = [[ThroughManageShowList alloc] initWithViewModel:viewModel];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
    
#pragma mark - 车牌识别按钮按钮事件
    [[self.btn_userName rac_signalForControlEvents:UIControlEventTouchUpInside ] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        //调用身份证和驾驶证模态视图
        CertificateView *t_view = [CertificateView initCustomView];
        [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 103)];
        t_view.identityCardBlock = ^(){
            LxPrintf(@"身份证点击");
            @strongify(self);
            LRCameraVC *home = [[LRCameraVC alloc] init];
            home.isAccident = YES;
            home.type = 2;
            home.fininshCaptureBlock = ^(LRCameraVC *camera) {
                @strongify(self);
                if (camera) {
                    
                    if (camera.type == 2) {
                        self.tf_userName.text = camera.commonIdentifyResponse.name;
                        self.tf_userNumber.text = camera.commonIdentifyResponse.idNo;
                        self.viewModel.param.userName =camera.commonIdentifyResponse.name;
                        self.viewModel.param.identNo = camera.commonIdentifyResponse.idNo;
                    }
                }
            };
            [self presentViewController:home
                               animated:NO
                             completion:^{
                             }];
            
            [BottomView dismissWindow];
            
        };
        t_view.drivingLicenceBlock = ^(){
            
            LxPrintf(@"驾驶证点击");
            @strongify(self);
            LRCameraVC *home = [[LRCameraVC alloc] init];
            home.isAccident = YES;
            home.type = 3;
            home.fininshCaptureBlock = ^(LRCameraVC *camera) {
                @strongify(self);
                if (camera) {
                    if (camera.type == 3) {
                        self.tf_userName.text = camera.commonIdentifyResponse.name;
                        self.tf_userNumber.text = camera.commonIdentifyResponse.idNo;
                        self.viewModel.param.userName =camera.commonIdentifyResponse.name;
                        self.viewModel.param.identNo = camera.commonIdentifyResponse.idNo;
                    }
                }
            };
            [self presentViewController:home
                               animated:NO
                             completion:^{
                             }];
            
            [BottomView dismissWindow];
            
        };
        [BottomView showWindowWithBottomView:t_view];
        
        
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
    
#pragma mark - 车牌识别监听
    [self.viewModel.command_identifyCarNo.executionSignals.switchToLatest subscribeNext:^(id _Nullable x) {
        @strongify(self);
    
        if ([x isKindOfClass:[ImageFileInfo class]]) {
            ImageFileInfo * cutImageInfo = (ImageFileInfo *)x;
            [self.viewModel replaceUpImageItemToUpImagesWithImageInfo:cutImageInfo remark:@"车牌近照" replaceIndex:1];
            [self.collectionView reloadData];
            
        }else if ([x isKindOfClass:[NSString class]]){
            
            NSString * t_str = (NSString *)x;
            if (![t_str isEqualToString:@"识别失败"]) {
                self.tf_carNo.text = t_str;
            }
        }
        
    }];
    
#pragma mark - 车牌查询违章次数
    [self.viewModel.command_carCount.executionSignals.switchToLatest subscribeNext:^(id _Nullable x) {
        @strongify(self);
    
        if ([x isKindOfClass:[NSNumber class]]) {
            NSNumber * t_x = (NSNumber *)x;
            self.btn_carNoNumer.hidden = NO;
            self.image_carNoNumber.hidden = NO;
            [self.btn_carNoNumer setTitle:[NSString stringWithFormat:@"历史%d",[t_x intValue]] forState:UIControlStateNormal];
        }
        
        
    }];
    
#pragma mark - 身份证位置次数查询
    [self.viewModel.command_identNoCount.executionSignals.switchToLatest subscribeNext:^(id _Nullable x) {
        @strongify(self);
        if ([x isKindOfClass:[NSNumber class]]) {
            NSNumber * t_x = (NSNumber *)x;
            self.btn_userNumber.hidden = NO;
            self.image_userNumber.hidden = NO;
            [self.btn_userNumber setTitle:[NSString stringWithFormat:@"历史%d",[t_x intValue]] forState:UIControlStateNormal];
        }
        
    
    }];
    

#pragma mark - 检查是否需要二次采集工作
    
    [self.viewModel.command_carNoSecond.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        if ([x isKindOfClass:[RACTuple class]]) {
            RACTupleUnpack(NSNumber * code,ThroughManageCarNoSecReponse * reponse,NSString * msg) = x;
            
            NSLog(@"%@",msg);
            
            
            if ([code isEqualToNumber:@0]) {
                
                [self.tf_carNo resignFirstResponder];
                
                IllegalSecSaveVC *t_vc = [[IllegalSecSaveVC alloc] init];
                t_vc.illegalThroughId = reponse.illegalId;
                t_vc.type = 2;
                if ([self.viewModel.arr_upImages[0] isKindOfClass:[NSMutableDictionary class]]) {
                    t_vc.illegal_image = self.viewModel.arr_upImages[0];
                    [t_vc.illegal_image setObject:[ShareFun getCurrentTime] forKey:@"taketimes"];
                };
                t_vc.saveSuccessBlock = ^{
                    @strongify(self);
                    [self.viewModel handleBeforeCommit];
                    [self.collectionView reloadData];
                    [self handleAfterCommitForUI];
                    [[LocationHelper sharedDefault] startLocation];
                    
                };
                [self.navigationController pushViewController:t_vc animated:YES];
                
            }else if ([code isEqualToNumber:@13]){
                
                [self.tf_carNo resignFirstResponder];
                
                [self showAlertViewWithcontent:msg leftTitle:@"退出" rightTitle:@"重新采集" block:^(AlertViewActionType actionType) {
                    @strongify(self);
                    if (actionType == AlertViewActionTypeRight) {
                        
                        if (self.viewModel.isCanCommit == YES) {
                            [self.viewModel handleBeforeCommit];
                            [self.collectionView reloadData];
                            [self handleAfterCommitForUI];
                            [[LocationHelper sharedDefault] startLocation];
                        }
                        
                    }else if (actionType == AlertViewActionTypeLeft){
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }
                    
                }];
                
                
            }else if ([code isEqualToNumber:@110]){
                
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
                    @strongify(self);
                    IllegalRecordVC *vc =[[IllegalRecordVC alloc] init];
                    vc.illegalId = illegalId;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                };
                [AlertView showWindowWithIllegalListViewWith:view inView:self.view];
                
            }else if ([code isEqualToNumber:@1]){
                
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
                
                [[LocationStorage sharedDefault] closeLocation:ParkTypeThroughManage];
                [self stopLocationAction:[LocationStorage sharedDefault].throughManage];
                
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
            
                [[LocationStorage sharedDefault] startLocation:ParkTypeThroughManage];
                
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
    
    if ([LocationStorage sharedDefault].isThroughManage == NO) {
        [self stopLocationAction:[LocationStorage sharedDefault].throughManage];
    }
    

}


#pragma mark - 返回按钮事件

-(void)handleBtnBackClicked{
    
    if (self.viewModel.param.addressRemark || self.viewModel.param.carNo || self.viewModel.param.userName || self.viewModel.param.identNo || (self.viewModel.arr_upImages.count > 0 && ![self.viewModel.arr_upImages[0] isKindOfClass:[NSNull class]] && ![self.viewModel.arr_upImages[1] isKindOfClass:[NSNull class]])) {
        
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


#pragma mark - 选择车辆类型按钮事件
- (void)handlebtnVehicleTypeClicked{
    
    @weakify(self);
    
    VehicleTypeVC *t_searchLocationvc = [VehicleTypeVC new];
    
    t_searchLocationvc.vehicleTypeBlock = ^(CommonGetVehicleModel *model) {
        @strongify(self);
        self.tf_vehicleType.text = model.vehicleName;
        self.viewModel.param.carTypeName = model.vehicleName;

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
    
    for (int i = 0; i < [self.viewModel.arr_upImages count]; i++) {
        
        if ([self.viewModel.arr_upImages[i] isKindOfClass:[NSMutableDictionary class]]) {
            
            NSMutableDictionary *t_dic = self.viewModel.arr_upImages[i];
            
            NSString *t_str = [t_dic objectForKey:@"remarks"];
            
            if ([t_str isEqualToString:[itemDic objectForKey:@"remarks"]]) {
                
                if ([t_str isEqualToString:@"车牌近照"] || [t_str isEqualToString:@"闯禁令照片"]) {
                    
                    if ([t_str isEqualToString:@"车牌近照"]) {
                        self.viewModel.param.cutImageUrl = nil;
                    }
                    
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

#pragma mark - 关闭定位之后所做的赋值操作

- (void)stopLocationAction:(LocationStorageModel *)model{
    
    self.tf_roadName.text = model.streetName;
    self.tf_address.text     = model.address;
    
    self.viewModel.param.roadName      = model.streetName;
    self.viewModel.param.address       = model.address;
    
    [self.viewModel getRoadId];
        
}

#pragma mark -

- (void)handleAfterCommitForUI{
    
    //采集之后的UI处理
    self.tf_userName.text    = nil;
    self.tf_userNumber.text  = nil;
    self.tf_roadName.text    = nil;
    self.tf_address.text     = nil;
    self.tf_carNo.text       = nil;
    self.tf_vehicleType.text = nil;
    
//    self.btn_userNumber.hidden = YES;
    
//    self.image_userNumber.hidden = YES;
//
//    self.btn_carNoNumer.hidden = YES;
//    self.image_carNoNumber.hidden = YES;
    
    [self.btn_userNumber setTitle:@"历史0" forState:UIControlStateNormal];
    [self.btn_carNoNumer setTitle:@"历史0" forState:UIControlStateNormal];
    
    
    if (self.btnType != 1) {
        [self stopLocationAction:[LocationStorage sharedDefault].throughManage];
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
    
#pragma mark - 监听获取到cutImageUrl之后的操作
    [[RACObserve(self.viewModel.param, cutImageUrl) distinctUntilChanged] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (x && x.length > 0) {
            [self.viewModel replaceUpImageItemToUpImagesWithImageInfo:nil remark:@"车牌近照" replaceIndex:1];
            [self.collectionView reloadData];
            
        }

    }];
    
    RAC(self.viewModel.param, addressRemark) = [self.tf_addressRemark.rac_textSignal skip:1];
    RAC(self.viewModel.param, carNo) = [self.tf_carNo.rac_textSignal skip:1];
    RAC(self.viewModel.param, userName) = [self.tf_userName.rac_textSignal skip:1];
    RAC(self.viewModel.param, identNo) = [self.tf_userNumber.rac_textSignal skip:1];
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
    
    if (textField == self.tf_vehicleType) {
        [self handlebtnVehicleTypeClicked];
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
    
    return [self.viewModel.arr_upImages count] + 1;
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
    
    if (indexPath.row == self.viewModel.arr_upImages.count) {
        cell.lb_title.text = @"其他照片";
        cell.imageView.image = [UIImage imageNamed:@"btn_updatePhoto"];
    }else{
        
        if(indexPath.row == 0){
            cell.lb_title.text = @"闯禁令照片";
        }else if(indexPath.row == 1){
            cell.lb_title.text = @"车牌近照";
        }else {
            cell.lb_title.text = [NSString stringWithFormat:@"其他照片%ld",indexPath.row-1];
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

#pragma mark - UICollectionView Delegate method

//选中某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    
    if (indexPath.row == self.viewModel.arr_upImages.count) {
        
        [self showCameraWithType:2 withFinishBlock:^(ImageFileInfo * imageInfo) {
            @strongify(self);
            [self.viewModel addUpImageItemToUpImagesWithImageInfo:imageInfo remark:[NSString stringWithFormat:@"其他照片%ld",indexPath.row-1]];
            [self.collectionView reloadData];
        }];
        
    }else if(indexPath.row == 0){
        
        if ([self.viewModel.arr_upImages[0] isKindOfClass:[NSNull class]]) {
            
            [self showCameraWithType:3 withCutFinishBlock:^(ImageFileInfo *imageInfo, ImageFileInfo *cutImageInfo) {
                @strongify(self);
                [self.viewModel replaceUpImageItemToUpImagesWithImageInfo:imageInfo remark:@"闯禁令照片" replaceIndex:0];
                [self.viewModel.command_identifyCarNo execute:imageInfo];
                [self.collectionView reloadData];
            }];
            
        }else{
        
            [self showPhotoBrowserWithIndex:0];
        }
        
    }else if(indexPath.row == 1){
        
        if ([self.viewModel.arr_upImages[1] isKindOfClass:[NSNull class]]) {
            
            [self showCameraWithType:1 withFinishBlock:^(ImageFileInfo * imageInfo) {
                @strongify(self);
                [self.viewModel.command_identifyCarNo execute:imageInfo];
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
    NSLog(@"ThroughManageVC dealloc");
}

@end
