//
//  AccidentAddFootView.m
//  trafficPolice
//
//  Created by hcat on 2017/5/23.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AccidentAddFootView.h"

#import "YUSegment.h"
#import "FSTextView.h"
#import "AccidentVC.h"
#import "LRCameraVC.h"
#import "SearchLocationVC.h"

#import "CertificateView.h"
#import "BottomView.h"
#import "BottomPickerView.h"


#import "ShareFun.h"
#import "UserModel.h"
#import "CommonAPI.h"
#import "FastAccidentAPI.h"

#import "UIButton+NoRepeatClick.h"
#import "UIButton+Block.h"
#import "CountAccidentHelper.h"

#import "SRAlertView.h"




@interface AccidentAddFootView()<UITextViewDelegate>

//分段控件，分别为甲方，乙方，丙方
@property (weak, nonatomic) IBOutlet YUSegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UILabel *lb_accidentCauses;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_accidentCauses;



 //事故信息里面的更多信息按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_moreAccidentInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_accidentInfo;

//点击事故信息更多信息将要显示或者隐藏的UILabel 和 UIView
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lb_moreAccidentInfos;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *v_moreAccidentInfos;

//当事人信息里面的更多信息按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_moreInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_moreinfo;

//点击当事人信息更多信息将要显示或者隐藏的UILabel 和 UIView
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lb_moreInfos;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn_moreInfos;

//快处事件的UI处理
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_InsuranceCompany;
@property (weak, nonatomic) IBOutlet UILabel *lb_illegalBehavior;


//事故信息里面用到的textField
@property (weak, nonatomic) IBOutlet UITextField *tf_accidentCauses;    //事故成因
@property (weak, nonatomic) IBOutlet UITextField *tf_accidentTime;      //事故时间(必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_location;          //所在位置(必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_accidentAddress;   //事故地址(必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_weather;           //天气情况
@property (weak, nonatomic) IBOutlet UITextField *tf_injuriesNumber;    //受伤人数
@property (weak, nonatomic) IBOutlet UITextField *tf_roadType;          //道路类型

//当事人信息里面用到的textField
@property (weak, nonatomic) IBOutlet UITextField *tf_name;              //姓名(甲方必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_identityCard;      //身份证号(甲方必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_carType;           //汽车类型(甲方必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_carNumber;         //车牌号码(甲方必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_phone;             //电话号码(甲方必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_drivingState;      //行驶状态
@property (weak, nonatomic) IBOutlet UITextField *tf_illegalBehavior;   //违法行为
@property (weak, nonatomic) IBOutlet UITextField *tf_insuranceCompany;  //保险公司
@property (weak, nonatomic) IBOutlet UITextField *tf_responsibility;    //责任

@property (weak, nonatomic) IBOutlet UIButton *btn_temporaryCar;
@property (weak, nonatomic) IBOutlet UIButton *btn_temporaryDrivelib;
@property (weak, nonatomic) IBOutlet UIButton *btn_temporarylib;
@property (weak, nonatomic) IBOutlet UIButton *btn_temporaryIdentityCard;

@property (weak, nonatomic) IBOutlet FSTextView *tv_describe;           //简述

@property (weak, nonatomic) IBOutlet UILabel *lb_textCount;             //用于显示简述输入多少文字

@property (weak, nonatomic) IBOutlet UIButton *btn_commit;

@property(nonatomic,assign) BOOL isCanCommit;
@property(nonatomic,assign) BOOL isUpLoading;



@property (nonatomic, strong) AccidentGetCodesResponse *codes; //

@end

@implementation AccidentAddFootView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //添加对定位的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChange) name:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil];
        
    }
    return self;
}


- (void)awakeFromNib {
    
    [super awakeFromNib];
    //默认设置是否显示更多信息，这里预先设置是为了调用UICollectionView可以刷新下数据
    //这里待优化
    self.isUpLoading = NO;
    
    self.partyFactory = [[PartyFactory alloc] init];
    //配置视图页面
    [self configView];
    
    self.isShowMoreInfo = YES;
    self.isShowMoreAccidentInfo = YES;
    
    if ([UserModel getUserModel].isInsurance) {
        self.lb_accidentCauses.hidden = YES;
        self.tf_accidentCauses.hidden = YES;
        self.layout_accidentCauses.constant = 45.f;
        [self layoutIfNeeded];
    }
    
    //异步请求即将用到数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getServerData];
    });
    
    //重新定位下
    [[LocationHelper sharedDefault] startLocation];
    
    //获取当前事故时间
    _tf_accidentTime.text = [ShareFun getCurrentTime];
    self.partyFactory.param.happenTimeStr = [ShareFun getCurrentTime];
    
    self.isCanCommit = NO;
    
}

#pragma mark - 配置视图页面

- (void)configView{
    
    //设置btn可以连续点击，这里这样写是因为有method+swizzing的分类中定义了不可重复点击btn,设置isIgnore忽略点击
    //详情请查看UIButton+NoRepeatClick
    self.btn_moreInfo.isIgnore = YES;
    self.btn_moreAccidentInfo.isIgnore = YES;
    self.btn_commit.isIgnore = NO;
    
    //设置UITextField的Placeholder高亮来提示哪些是需要输入的
    _tf_accidentTime.attributedPlaceholder = [ShareFun highlightInString:@"请输入事故时间(必填)" withSubString:@"(必填)"];
    _tf_location.attributedPlaceholder = [ShareFun highlightInString:@"请选择位置(必选)" withSubString:@"(必选)"];
    _tf_accidentAddress.attributedPlaceholder = [ShareFun highlightInString:@"请输入事故地点(必填)" withSubString:@"(必填)"];
    
    //设置扩展按钮的点击范围
    [_btn_temporaryCar setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [_btn_temporaryDrivelib setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [_btn_temporarylib setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [_btn_temporaryIdentityCard setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    
    //设置更多设置下划线，直接设置不想用别人的子类，可以说我懒，觉得没有必要
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"更多信息"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFF8B33) range:strRange];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [self.btn_moreAccidentInfo setAttributedTitle:str forState:UIControlStateNormal];
    [self.btn_moreInfo setAttributedTitle:str forState:UIControlStateNormal];
    
    //配置SegmentedControl分段
    [self setUpSegmentedControl];
    
    //事故信息里面添加对UITextField的监听
    [self addChangeForEventEditingChanged:self.tf_accidentTime];
    [self addChangeForEventEditingChanged:self.tf_accidentAddress];
    [self addChangeForEventEditingChanged:self.tf_weather];
    
    //当事人信息里面添加对UITextField的监听
    [self addChangeForEventEditingChanged:self.tf_name];
    [self addChangeForEventEditingChanged:self.tf_identityCard];
    [self addChangeForEventEditingChanged:self.tf_carNumber];
    [self addChangeForEventEditingChanged:self.tf_phone];
    
    //配置点击UITextField
    [self setUpClickUITextField:self.tf_accidentCauses];
    [self setUpClickUITextField:self.tf_location];
    [self setUpClickUITextField:self.tf_injuriesNumber];
    [self setUpClickUITextField:self.tf_roadType];
    
    [self setUpClickUITextField:self.tf_carType];
    [self setUpClickUITextField:self.tf_drivingState];
    [self setUpClickUITextField:self.tf_illegalBehavior];
    [self setUpClickUITextField:self.tf_insuranceCompany];
    [self setUpClickUITextField:self.tf_responsibility];
    
    //配置通用UITextField
    [self setUpCommonUITextField:self.tf_accidentTime];
    [self setUpCommonUITextField:self.tf_accidentAddress];
    [self setUpCommonUITextField:self.tf_weather];
    
    [self setUpCommonUITextField:self.tf_name];
    [self setUpCommonUITextField:self.tf_identityCard];
    [self setUpCommonUITextField:self.tf_carNumber];
    [self setUpCommonUITextField:self.tf_phone];
    
    
    
    
    //配置FSTextView
    [self.tv_describe setDelegate:(id<UITextViewDelegate> _Nullable)self];
    self.tv_describe.placeholder = @"请输入简述";
    self.tv_describe.maxLength = 150;   //最大输入字数
    WS(weakSelf);
    [self.tv_describe addTextDidChangeHandler:^(FSTextView *textView) {
        // 文本改变后的相应操作.
        weakSelf.lb_textCount.text =
        [NSString stringWithFormat:@"%d/%d",textView.text.length,textView.maxLength];
        
    }];
    // 添加到达最大限制Block回调.
    [self.tv_describe addTextLengthDidMaxHandler:^(FSTextView *textView) {
        // 达到最大限制数后的相应操作.
    }];
    
}

#pragma mark - 数据请求部分

- (void) getServerData{
    
    //获取当前天气
    WS(weakSelf);
    CommonGetWeatherManger *manger = [CommonGetWeatherManger new];
    manger.location = [[NSString stringWithFormat:@"%f,%f",[LocationHelper sharedDefault].longitude,[LocationHelper sharedDefault].latitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    manger.isNeedShowHud = NO;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.tf_weather.text = manger.weather;
            strongSelf.partyFactory.param.weather = manger.weather;
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];

}

#pragma mark - set && get

- (AccidentGetCodesResponse *)codes{

    _codes = [ShareValue sharedDefault].accidentCodes;

    return _codes;
}

- (void)setAccidentType:(AccidentType)accidentType{

    _accidentType = accidentType;
    _partyFactory.accidentType = _accidentType;
    
    if (_accidentType == AccidentTypeAccident) {
        
        [CountAccidentHelper sharedDefault].state = @1;
    }else if (_accidentType == AccidentTypeFastAccident){
        [CountAccidentHelper sharedDefault].state = @9;
    }
    
    //快处事故的UI处理
    if (_accidentType == AccidentTypeFastAccident){
        
        self.isShowMoreInfo = YES;
        self.isShowMoreAccidentInfo = YES;
        self.btn_moreAccidentInfo.hidden = YES;
        self.btn_moreInfo.hidden = YES;
        _layout_InsuranceCompany.constant = 14.f;
        _layout_moreinfo.constant = 10.f;
        [self layoutIfNeeded];
        self.lb_illegalBehavior.hidden = YES;
        self.tf_illegalBehavior.hidden = YES;
        
    }
    
}


- (void)setArr_photes:(NSArray *)arr_photes{
    
    if (arr_photes) {
        _arr_photes = arr_photes;
        NSMutableArray *t_arr = [NSMutableArray array];
        for (UIImage *t_image in _arr_photes) {
            ImageFileInfo *t_imageFileInfo = [[ImageFileInfo alloc] initWithImage:t_image withName:key_files];
            [t_arr addObject:t_imageFileInfo];
        }
        _partyFactory.param.files = t_arr;
        
    }
    
}

-(void)setIsCanCommit:(BOOL)isCanCommit{
    _isCanCommit = isCanCommit;
    if (_isCanCommit == NO) {
        _btn_commit.enabled = NO;
        [_btn_commit setBackgroundColor:UIColorFromRGB(0xe6e6e6)];
    }else{
        _btn_commit.enabled = YES;
        [_btn_commit setBackgroundColor:UIColorFromRGB(0x4281E8)];
    }
}

- (void)setIsShowMoreInfo:(BOOL)isShowMoreInfo{

    _isShowMoreInfo = isShowMoreInfo;
    
    if (_isShowMoreInfo) {
        for (UILabel *t_label in _lb_moreInfos) {
            t_label.hidden = YES;
        }
        for (UIButton *t_btn in _btn_moreInfos) {
            t_btn.hidden = YES;
        }
        _layout_moreinfo.constant = 34.f;
        [self layoutIfNeeded];
        
    }else{
        for (UILabel *t_label in _lb_moreInfos) {
            t_label.hidden = NO;
        }
        for (UIButton *t_btn in _btn_moreInfos) {
            t_btn.hidden = NO;
        }
        _layout_moreinfo.constant = 158.f;
        [self layoutIfNeeded];
    }
    
}


- (void)setIsShowMoreAccidentInfo:(BOOL)isShowMoreAccidentInfo{
    
    _isShowMoreAccidentInfo = isShowMoreAccidentInfo;
    
    if (_isShowMoreAccidentInfo) {
        for (UILabel *t_label in _lb_moreAccidentInfos) {
            t_label.hidden = YES;
        }
        for (UIView *t_v in _v_moreAccidentInfos) {
            t_v.hidden = YES;
        }
        _layout_accidentInfo.constant = 20.f;
        [self layoutIfNeeded];
        
    }else{
        for (UILabel *t_label in _lb_moreAccidentInfos) {
            t_label.hidden = NO;
        }
        for (UIView *t_v in _v_moreAccidentInfos) {
            t_v.hidden = NO;
        }
        _layout_accidentInfo.constant = 108.f;
        [self layoutIfNeeded];
    }
    
}


#pragma mark - 按钮事件

#pragma mark - 事故信息的更多信息按钮点击

- (IBAction)handleBtnMoreAccidentInfoClicked:(id)sender {
    self.isShowMoreAccidentInfo = !_isShowMoreAccidentInfo;
}

#pragma mark - 当事人信息的更多信息按钮点击

- (IBAction)handleBtnMoreInfoClicked:(id)sender {
    self.isShowMoreInfo = !_isShowMoreInfo;
}

#pragma mark - 姓名识别按钮点击

- (IBAction)handleBtnNameIdentifyClicked:(id)sender {
    
    WS(weakSelf);
    //调用身份证和驾驶证模态视图
    CertificateView *t_view = [CertificateView initCustomView];
    [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 103)];
    t_view.identityCardBlock = ^(){
        LxPrintf(@"身份证点击");
        SW(strongSelf, weakSelf);
        
        //UIView获取UIViewController,来弹出LRCameraVC拍照，拍照完之后调用fininshCaptureBlock
        AccidentVC *t_vc = (AccidentVC *)[ShareFun findViewController:self];
        LRCameraVC *home = [[LRCameraVC alloc] init];
        home.type = 2;
        home.fininshCaptureBlock = ^(LRCameraVC *camera) {
            if (camera) {
                if (camera.type == 2) {
                    strongSelf.tf_name.text = camera.commonIdentifyResponse.name;
                    strongSelf.tf_identityCard.text = camera.commonIdentifyResponse.idNo;
                    strongSelf.partyFactory.partModel.partyName =camera.commonIdentifyResponse.name;
                    strongSelf.partyFactory.partModel.partyIdNummber = camera.commonIdentifyResponse.idNo;
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        ImageFileInfo *imageFileInfo = camera.imageInfo;
                        imageFileInfo.name = key_certFiles;
                        [strongSelf.partyFactory addCredentialItemsByImageInfo:imageFileInfo withType:@"身份证"];
                    });
                    
                    //用于请求是否有违规行为
                    [[CountAccidentHelper sharedDefault] setIdNo:camera.commonIdentifyResponse.idNo];
                }
            }
        };
        [t_vc presentViewController:home
                           animated:NO
                         completion:^{
                         }];
        
        [BottomView dismissWindow];
        
    };
    t_view.drivingLicenceBlock = ^(){
        
        LxPrintf(@"驾驶证点击");
        SW(strongSelf, weakSelf);
        //UIView获取UIViewController,来弹出LRCameraVC拍照，拍照完之后调用fininshCaptureBlock
        AccidentVC *t_vc = (AccidentVC *)[ShareFun findViewController:self];
        LRCameraVC *home = [[LRCameraVC alloc] init];
        home.type = 3;
        home.fininshCaptureBlock = ^(LRCameraVC *camera) {
            if (camera) {
                if (camera.type == 3) {
                    strongSelf.tf_name.text = camera.commonIdentifyResponse.name;
                    strongSelf.tf_identityCard.text = camera.commonIdentifyResponse.idNo;
                    strongSelf.partyFactory.partModel.partyName = camera.commonIdentifyResponse.name;
                    strongSelf.partyFactory.partModel.partyIdNummber = camera.commonIdentifyResponse.idNo;
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        ImageFileInfo *imageFileInfo = camera.imageInfo;
                        imageFileInfo.name = key_certFiles;
                        [strongSelf.partyFactory addCredentialItemsByImageInfo:imageFileInfo withType:@"驾驶证"];
                    });
                    
                    //用于请求是否有违规行为
                    [[CountAccidentHelper sharedDefault] setIdNo:camera.commonIdentifyResponse.idNo];
                }
            }
        };
        [t_vc presentViewController:home
                           animated:NO
                         completion:^{
                         }];
        
        [BottomView dismissWindow];
        
    };
    [BottomView showWindowWithBottomView:t_view];
    
}
#pragma mark - 车牌号码识别按钮点击

- (IBAction)handleBtnCarNumberClicked:(id)sender {
    WS(weakSelf);
    AccidentVC *t_vc = (AccidentVC *)[ShareFun findViewController:self];
    LRCameraVC *home = [[LRCameraVC alloc] init];
    home.type = 4;
    home.fininshCaptureBlock = ^(LRCameraVC *camera) {
        SW(strongSelf, weakSelf);
        if (camera) {
            if (camera.type == 4) {
                strongSelf.tf_carNumber.text = camera.commonIdentifyResponse.carNo;
                strongSelf.tf_carType.text = camera.commonIdentifyResponse.vehicleType;
                
                strongSelf.partyFactory.partModel.partyCarNummber = camera.commonIdentifyResponse.carNo;
                
                NSInteger IdNo = [strongSelf.codes searchNameWithModelName:camera.commonIdentifyResponse.vehicleType WithArray:strongSelf.codes.vehicle];
                strongSelf.partyFactory.partModel.partyVehicleId = @(IdNo);
               
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    ImageFileInfo *imageFileInfo = camera.imageInfo;
                    imageFileInfo.name = key_certFiles;
                    [strongSelf.partyFactory addCredentialItemsByImageInfo:imageFileInfo withType:@"行驶证"];
                });
                
                //用于请求是否有违规行为
                [[CountAccidentHelper sharedDefault] setCarNo:camera.commonIdentifyResponse.carNo];
                
            }
            
        }
    };
    [t_vc presentViewController:home
                       animated:NO
                     completion:^{
                     }];
    
}

#pragma mark - 重新定位按钮点击

- (IBAction)handleBtnLocationClicked:(id)sender {
    _tf_location.text = nil;
    [_partyFactory setRoadId:nil];
    _partyFactory.param.roadName = nil;
    self.isCanCommit =  [_partyFactory juegeCanCommit];
    [[LocationHelper sharedDefault] startLocation];
    
}

#pragma mark - 事故成因按钮点击

- (IBAction)handleBtnAccidentCausesClicked:(id)sender {
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"事故成因" items:self.codes.cause block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        
        SW(strongSelf, weakSelf);
        strongSelf.tf_accidentCauses.text = title;
        strongSelf.partyFactory.param.causesType  = @(itemId);
        
        [BottomView dismissWindow];
        
    }];
    
}

#pragma mark - 所在位置按钮点击

- (IBAction)handleBtnChoiceLocationClicked:(id)sender {
    
    AccidentVC *t_vc = (AccidentVC *)[ShareFun findViewController:self];
    SearchLocationVC *t_searchLocationvc = [SearchLocationVC new];
    t_searchLocationvc.searchType = SearchLocationTypeAccident;
    t_searchLocationvc.arr_content = self.codes.road;
    t_searchLocationvc.arr_temp = self.codes.road;
   
   
    WS(weakSelf);
    t_searchLocationvc.searchLocationBlock = ^(AccidentGetCodesModel *model) {
        SW(strongSelf, weakSelf);
        strongSelf.tf_location.text = model.modelName;
        strongSelf.partyFactory.param.roadId = @(model.modelId);
        strongSelf.isCanCommit =  [strongSelf.partyFactory juegeCanCommit];
    };
    [t_vc.navigationController pushViewController:t_searchLocationvc animated:YES];
    
}

#pragma mark - 受伤人数按钮点击

- (IBAction)handleBtnInjuryNumberClicked:(id)sender {
    WS(weakSelf);
    
    NSArray *items = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    BottomPickerView *t_view = [BottomPickerView initCustomView];
    [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 207)];
    t_view.pickerTitle = @"受伤人数";
    t_view.items = items;
    t_view.selectedBtnBlock = ^(NSArray *items, NSInteger index) {
        SW(strongSelf, weakSelf);
        NSString * number = items[index];
        strongSelf.tf_injuriesNumber.text = number;
        strongSelf.partyFactory.param.injuredNum  = number;
        
        [BottomView dismissWindow];
    };
    
    [BottomView showWindowWithBottomView:t_view];
    
}

#pragma mark - 道路类型按钮点击

- (IBAction)handleBtnRoadTypeClicked:(id)sender {
    
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"道路类型" items:self.codes.roadType block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        SW(strongSelf, weakSelf);
        strongSelf.tf_roadType.text = title;
        strongSelf.partyFactory.param.roadType  = @(itemType);
    
        [BottomView dismissWindow];
        
    }];
    
    
}

#pragma mark - 车辆类型按钮点击

- (IBAction)handleBtnCarTypeClicked:(id)sender {
    
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"车辆类型" items:self.codes.vehicle block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        SW(strongSelf, weakSelf);
        strongSelf.tf_carType.text = title;
        strongSelf.partyFactory.partModel.partyVehicleId =  @(itemId);
        
        strongSelf.isCanCommit =  [strongSelf.partyFactory juegeCanCommit];
        [BottomView dismissWindow];

    }];

}

#pragma mark - 行驶状态按钮点击

- (IBAction)handleBtnTrafficStateClicked:(id)sender {
    
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"行驶状态" items:self.codes.driverDirect block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        
        SW(strongSelf, weakSelf);
        strongSelf.tf_drivingState.text = title;
        strongSelf.partyFactory.partModel.partyDirectId =  @(itemType);
        [BottomView dismissWindow];
        
    }];

}

#pragma mark - 违法行为按钮点击

- (IBAction)handleBtnIllegalBehaviorClicked:(id)sender {
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"违法行为" items:self.codes.behaviour block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        
        SW(strongSelf, weakSelf);
        strongSelf.tf_illegalBehavior.text = title;
        strongSelf.partyFactory.partModel.partyBehaviourId =  @(itemId);
        [BottomView dismissWindow];
        
    }];
    
}

#pragma mark - 保险公司按钮点击

- (IBAction)handleBtnInsuranceCompanyClicked:(id)sender {
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"保险公司" items:self.codes.insuranceCompany block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        
        SW(strongSelf, weakSelf);
        strongSelf.tf_insuranceCompany.text = title;
        strongSelf.partyFactory.partModel.partyInsuranceCompanyId =  @(itemId);
    
        [BottomView dismissWindow];
        
    }];
}

#pragma mark - 责任按钮点击

- (IBAction)handleBtnResponsibilityClicked:(id)sender {
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"事故责任" items:self.codes.responsibility block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        
        SW(strongSelf, weakSelf);
        strongSelf.tf_responsibility.text = title;
        strongSelf.partyFactory.partModel.partyResponsibilityId =  @(itemId);
        [BottomView dismissWindow];
        
    }];

    
}

#pragma mark - 是否暂扣车辆按钮点击

- (IBAction)handleBtnTemporaryCarClicked:(id)sender {
    _btn_temporaryCar.selected = !_btn_temporaryCar.selected;
    _partyFactory.partModel.partyIsZkCl = @(_btn_temporaryCar.selected);
}

#pragma mark - 是否暂扣行驶证按钮点击


- (IBAction)handleBtnTemporaryDrivingLicenseClicked:(id)sender {
    _btn_temporaryDrivelib.selected = !_btn_temporaryDrivelib.selected;
    _partyFactory.partModel.partyIsZkXsz = @(_btn_temporaryDrivelib.selected);
    
}

#pragma mark - 是否暂扣驾驶证按钮点击

- (IBAction)handleBtnTemporaryLicenseClicked:(id)sender {
    _btn_temporarylib.selected = !_btn_temporarylib.selected;
    _partyFactory.partModel.partyIsZkJsz = @(_btn_temporarylib.selected);
}


#pragma mark - 是否暂扣身份证按钮点击

- (IBAction)handleBtnIdentityCardClicked:(id)sender {
    _btn_temporaryIdentityCard.selected = !_btn_temporaryIdentityCard.selected;
    _partyFactory.partModel.partyIsZkSfz = @(_btn_temporaryIdentityCard.selected);

}

#pragma mark - 提交按钮事件

- (IBAction)handleBtnUploadClicked:(id)sender {
    
    
    if ([_partyFactory validateNumber] == NO) {
        return;
    }
    
    
    if (_isUpLoading) {
        return;
    }
    
    //如果roadId不为0，则不需要传roadName
    if (![_partyFactory.param.roadId isEqualToNumber:@0]) {
        _partyFactory.param.roadName = nil;
    }
    
    [_partyFactory configParamInCertFilesAndCertRemarks];
    
    LxDBObjectAsJson(_partyFactory.param);
    
    if (self.partyFactory.param.ptbName || self.partyFactory.param.ptbIdNo || self.partyFactory.param.ptbVehicleId || self.partyFactory.param.ptbCarNo || self.partyFactory.param.ptbPhone || self.partyFactory.param.ptbInsuranceCompanyId || self.partyFactory.param.ptbResponsibilityId || self.partyFactory.param.ptbDirect || self.partyFactory.param.ptbBehaviourId) {
        
        [self updateAccident];
        
    }else{
        
        WS(weakSelf);
        SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"乙方信息未录入，是否提交"
                                                    leftActionTitle:@"取消"
                                                   rightActionTitle:@"提交"
                                                     animationStyle:AlertViewAnimationNone
                                                       selectAction:^(AlertViewActionType actionType) {
                                                           
                                                           SW(strongSelf, weakSelf);
                                                           if (actionType == AlertViewActionTypeLeft) {
                                                               
                                                               
                                                           } else if(actionType == AlertViewActionTypeRight) {
                                                               [strongSelf updateAccident];
                                                           }
                                                       }];
        alertView.blurCurrentBackgroundView = NO;
        alertView.actionWhenHighlightedBackgroundColor = UIColorFromRGB(0x4281E8);
        [alertView show];
        
    }
    

}

- (void)updateAccident{
    
   
    
    WS(weakSelf);

    UIWindow * window = [[UIApplication sharedApplication] keyWindow];

    if (_accidentType == AccidentTypeAccident) {
        
        AccidentSaveManger *manger = [[AccidentSaveManger alloc] init];
        manger.param = self.partyFactory.param;
        manger.successMessage = @"提交成功";
        manger.failMessage = @"提交失败";
        
        self.isUpLoading = YES;
        
        ShowHUD *hud = [ShowHUD showWhiteLoadingWithText:@"提交中.." inView:window config:nil];
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [hud hide];
            SW(strongSelf, weakSelf);
            strongSelf.isUpLoading = NO;
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                
                if ([strongSelf.partyFactory.param.roadId isEqualToNumber:@0]) {
                    
                    [ShareValue sharedDefault].accidentCodes = nil;
                    [[ShareValue sharedDefault] accidentCodes];
                    [ShareValue sharedDefault].roadModels = nil;
                    [[ShareValue sharedDefault] roadModels];
                    
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ACCIDENT_SUCCESS object:nil];
                
                AccidentVC *t_vc = (AccidentVC *)[ShareFun findViewController:strongSelf];
                [t_vc.navigationController popViewControllerAnimated:YES];
                
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf, weakSelf);
            [hud hide];
            strongSelf.isUpLoading = NO;
        }];
        
    }else if (_accidentType == AccidentTypeFastAccident){
        
        FastAccidentSaveManger *manger = [[FastAccidentSaveManger alloc] init];
        manger.param = self.partyFactory.param;
        manger.successMessage = @"提交成功";
        manger.failMessage = @"提交失败";
        
        self.isUpLoading = YES;
        ShowHUD *hud = [ShowHUD showWhiteLoadingWithText:@"提交中.." inView:window config:nil];
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [hud hide];
            SW(strongSelf, weakSelf);
            strongSelf.isUpLoading = NO;
            if (manger.responseModel.code == CODE_SUCCESS) {
                
                if ([strongSelf.partyFactory.param.roadId isEqualToNumber:@0]) {
                    
                    [ShareValue sharedDefault].accidentCodes = nil;
                    [[ShareValue sharedDefault] accidentCodes];
                    [ShareValue sharedDefault].roadModels = nil;
                    [[ShareValue sharedDefault] roadModels];
                    
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FASTACCIDENT_SUCCESS object:nil];
                
                AccidentVC *t_vc = (AccidentVC *)[ShareFun findViewController:strongSelf];
                [t_vc.navigationController popViewControllerAnimated:YES];
                
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf, weakSelf);
            [hud hide];
            strongSelf.isUpLoading = NO;
        }];
        
    }


}

#pragma mark - 添加监听Textfield的变化，用于给参数实时赋值

- (void)addChangeForEventEditingChanged:(UITextField *)textField{
    [textField addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 通用显示模态PickView视图

- (void)showBottomPickViewWithTitle:(NSString *)title items:(NSArray *)items block:(void(^)(NSString *title, NSInteger itemId, NSInteger itemType))block{

    BottomPickerView *t_view = [BottomPickerView initCustomView];
    [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 207)];
    t_view.pickerTitle = title;
    t_view.items = items;
    t_view.selectedAccidentBtnBlock = block;
    
    [BottomView showWindowWithBottomView:t_view];
    
}


#pragma mark - 判断哪些TextFiled是必填项

- (void)judgeTextFieldWithIndex:(NSInteger)index{
    
    if(index == 0){
        
        _tf_name.attributedPlaceholder = [ShareFun highlightInString:@"请输入名字(必填)" withSubString:@"(必填)"];
        _tf_identityCard.attributedPlaceholder = [ShareFun highlightInString:@"请输入身份证号(必填)" withSubString:@"(必填)"];
        _tf_carType.attributedPlaceholder = [ShareFun highlightInString:@"请选择车辆类型(必选)" withSubString:@"(必选)"];
        _tf_phone.attributedPlaceholder = [ShareFun highlightInString:@"请输入联系方式(必填)" withSubString:@"(必填)"];
    }else{
        _tf_name.placeholder = @"请输入名字";
        _tf_identityCard.placeholder = @"请输入身份证号";
        _tf_carType.placeholder = @"请选择车辆类型";
        _tf_phone.placeholder = @"请输入联系方式";
    }
}


#pragma mark - 配置分段选择控件

-(void)setUpSegmentedControl{

    [_segmentedControl setUpWithTitles:@[@"甲方",@"乙方",@"丙方"]];
    [_segmentedControl setTextAttributes:@{
                                           NSFontAttributeName: [UIFont systemFontOfSize:14.0 weight:UIFontWeightLight],
                                           NSForegroundColorAttributeName: UIColorFromRGB(0x444444)
                                           } forState:YUSegmentedControlStateNormal];
    [_segmentedControl setTextAttributes:@{
                                           NSFontAttributeName: [UIFont systemFontOfSize:14.0 weight:UIFontWeightLight],
                                           NSForegroundColorAttributeName: UIColorFromRGB(0x4281e8)
                                           } forState:YUSegmentedControlStateSelected];
    _segmentedControl.indicator.backgroundColor = UIColorFromRGB(0x4281e8);
    [_segmentedControl addTarget:self action:@selector(segmentedControlTapped:) forControlEvents:UIControlEventValueChanged];
    [_segmentedControl setBackgroundColor:UIColorFromRGB(0xf6f6f6)];
    _segmentedControl.showsVerticalDivider = YES;
    _segmentedControl.showsTopSeparator = NO;
    _segmentedControl.showsBottomSeparator = NO;
    [self judgeTextFieldWithIndex:_segmentedControl.selectedSegmentIndex];
    [_partyFactory setIndex:_segmentedControl.selectedSegmentIndex];

}

#pragma mark - 实时监听UITextField内容的变化

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == _tf_accidentCauses) {
        [self handleBtnAccidentCausesClicked:nil];
        return NO;
    }
    
    if (textField == _tf_location) {
        [self handleBtnChoiceLocationClicked:nil];
        return NO;
    }
    
    if (textField == _tf_injuriesNumber) {
        [self handleBtnInjuryNumberClicked:nil];
        return NO;
    }
    
    if (textField == _tf_roadType) {
        [self handleBtnRoadTypeClicked:nil];
        return NO;
    }
    
    if (textField == _tf_carType) {
        [self handleBtnCarTypeClicked:nil];
        return NO;
    }
    
    if (textField == _tf_drivingState) {
        [self handleBtnTrafficStateClicked:nil];
        return NO;
    }
    
    if (textField == _tf_illegalBehavior) {
        [self handleBtnIllegalBehaviorClicked:nil];
        return NO;
    }
    
    if (textField == _tf_insuranceCompany) {
        [self handleBtnInsuranceCompanyClicked:nil];
        return NO;
    }
    
    if (textField == _tf_responsibility) {
        [self handleBtnResponsibilityClicked:nil];
        return NO;
    }
    
    return YES;
}


-(void)passConTextChange:(id)sender{
    UITextField* textField = (UITextField*)sender;
    LxDBAnyVar(textField.text);
    NSInteger length =  textField.text.length;
    if (textField == _tf_accidentTime) {
        _partyFactory.param.happenTimeStr = length > 0 ? _tf_accidentTime.text : nil;
    }
    
    if (textField == _tf_accidentAddress) {
        _partyFactory.param.address = length > 0 ? _tf_accidentAddress.text : nil;
    }
    
    if (textField == _tf_weather) {
        _partyFactory.param.weather = length > 0 ? _tf_weather.text : nil;
    }
    
    if (textField == _tf_name) {
        _partyFactory.partModel.partyName = length > 0 ? _tf_name.text : nil;
        
    }
    if (textField == _tf_identityCard) {
        
        _partyFactory.partModel.partyIdNummber = length > 0 ? _tf_identityCard.text : nil;
        //用于请求是否有违规行为
        [[CountAccidentHelper sharedDefault] setIdNo:_tf_identityCard.text];
    }
    if (textField == _tf_carNumber) {
        
        _partyFactory.partModel.partyCarNummber = length > 0 ? _tf_carNumber.text : nil;
        //用于请求是否有违规行为
        [[CountAccidentHelper sharedDefault] setCarNo:_tf_carNumber.text];
    }
    if (textField == _tf_phone) {
        
        _partyFactory.partModel.partyPhone = length > 0 ? _tf_phone.text : nil;
        //用于请求是否有违规行为
        [[CountAccidentHelper sharedDefault] setTelNum:_tf_phone.text];
    }
    self.isCanCommit = [_partyFactory juegeCanCommit];
    
}

#pragma mark - 实时监听UITextView内容的变化
//只能监听键盘输入时的变化(setText: 方式无法监听),如果想修复可以参考http://www.jianshu.com/p/75355acdd058
- (void)textViewDidChange:(FSTextView *)textView{
    
    _partyFactory.partModel.partyDescribe = textView.formatText;

}

#pragma mark - 重新定位之后的通知

-(void)locationChange{
    //这里待优化
    _tf_location.text = [LocationHelper sharedDefault].streetName;
    [_partyFactory setRoadId:[LocationHelper sharedDefault].streetName];
    _partyFactory.param.roadName = [LocationHelper sharedDefault].streetName;
    self.isCanCommit =  [_partyFactory juegeCanCommit];
}

#pragma mark - 分段控件选中之后的处理

- (void)segmentedControlTapped:(YUSegmentedControl *)sender {
    
   NSUInteger selectedIndex = _segmentedControl.selectedSegmentIndex;
    LxDBAnyVar(selectedIndex);
    [self judgeTextFieldWithIndex:selectedIndex];
    [self.partyFactory setIndex:selectedIndex];
    
    self.tf_name.text = self.partyFactory.partModel.partyName;
    self.tf_identityCard.text = self.partyFactory.partModel.partyIdNummber;
    self.tf_carType.text =  self.partyFactory.partModel.partycarType;
    self.tf_carNumber.text = self.partyFactory.partModel.partyCarNummber;
    self.tf_phone.text = self.partyFactory.partModel.partyPhone;
    self.tf_drivingState.text = self.partyFactory.partModel.partyDriverDirect;
    self.tf_illegalBehavior.text = self.partyFactory.partModel.partyBehaviour;
    self.tf_insuranceCompany.text = self.partyFactory.partModel.partyInsuranceCompany;
    self.tf_responsibility.text = self.partyFactory.partModel.partyResponsibility;
    self.btn_temporaryCar.selected = [self.partyFactory.partModel.partyIsZkCl boolValue];
    self.btn_temporaryDrivelib.selected = [self.partyFactory.partModel.partyIsZkXsz boolValue];
    self.btn_temporarylib.selected = [self.partyFactory.partModel.partyIsZkJsz boolValue];
    self.btn_temporaryIdentityCard.selected = [self.partyFactory.partModel.partyIsZkSfz boolValue];
    self.tv_describe.text = self.partyFactory.partModel.partyDescribe;
}

#pragma mark - 配置UITextField

- (void)setUpClickUITextField:(UITextField *)textField{

    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 5)];
    imageView.image = [UIImage imageNamed:@"三角形.png"];
    imageView.contentMode = UIViewContentModeCenter;
    textField.rightView = imageView;
    textField.rightViewMode = UITextFieldViewModeAlways;
    [textField setDelegate:(id<UITextFieldDelegate> _Nullable)self];

}

- (void)setUpCommonUITextField:(UITextField *)textField{
    
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    
}


#pragma mark - dealloc
- (void)dealloc{
    LxPrintf(@"AccidentAddFootView dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

@end
