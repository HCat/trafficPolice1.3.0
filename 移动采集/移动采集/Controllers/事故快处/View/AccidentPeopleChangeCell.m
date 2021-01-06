//
//  AccidentPeopleChangeCell.m
//  移动采集
//
//  Created by hcat on 2018/7/20.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "AccidentPeopleChangeCell.h"
#import "FSTextView.h"

#import "UIButton+NoRepeatClick.h"
#import "UIButton+Block.h"
#import "CountAccidentHelper.h"

#import "SRAlertView.h"
#import "BottomPickerView.h"
#import "BottomView.h"
#import "CertificateView.h"
#import "LRCameraVC.h"
#import "AccidentPeopleVC.h"
#import "AccidentMoreAPIs.h"
#import "AccidentHistoryListVC.h"
#import "AccidentPeopleVC.h"

#import <UITableView+YYAdd.h>

@interface AccidentPeopleChangeCell()<UITextViewDelegate>

//当事人信息里面的更多信息按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_moreInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_moreinfo;

//点击当事人信息更多信息将要显示或者隐藏的UILabel 和 UIView
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lb_moreInfos;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btn_moreInfos;

//快处事件的UI处理
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_InsuranceCompany;
@property (weak, nonatomic) IBOutlet UILabel *lb_illegalBehavior;

@property (weak, nonatomic) IBOutlet UITextField *tf_name;              //姓名(1号必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_identityCard;      //身份证号
@property (weak, nonatomic) IBOutlet UITextField *tf_carType;           //汽车类型
@property (weak, nonatomic) IBOutlet UITextField *tf_carNumber;         //车牌号码
@property (weak, nonatomic) IBOutlet UITextField *tf_phone;             //电话号码(1号必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_drivingState;      //行驶状态
@property (weak, nonatomic) IBOutlet UITextField *tf_illegalBehavior;   //违法行为
@property (weak, nonatomic) IBOutlet UITextField *tf_insuranceCompany;  //保险公司
@property (weak, nonatomic) IBOutlet UITextField *tf_policyNo;          //保险单号
@property (weak, nonatomic) IBOutlet UITextField *tf_responsibility;    //责任

@property (weak, nonatomic) IBOutlet UIButton *btn_temporaryCar;
@property (weak, nonatomic) IBOutlet UIButton *btn_temporaryDrivelib;
@property (weak, nonatomic) IBOutlet UIButton *btn_temporarylib;
@property (weak, nonatomic) IBOutlet UIButton *btn_temporaryIdentityCard;


@property (weak, nonatomic) IBOutlet UIButton *btn_userNumber;
@property (weak, nonatomic) IBOutlet UIImageView *image_userNumber;


@property (weak, nonatomic) IBOutlet UIButton *btn_userNumber2;
@property (weak, nonatomic) IBOutlet UIImageView *image_userNumber2;

@property (nonatomic, copy) RACCommand * command_identNoCount;

@property (nonatomic, copy) RACCommand * command_carCount;


@property (weak, nonatomic) IBOutlet FSTextView *tv_describe;           //简述

@property (weak, nonatomic) IBOutlet UILabel *lb_textCount;             //用于显示简述输入多少文字


@property (nonatomic, strong) AccidentGetCodesResponse *codes; //

@end

@implementation AccidentPeopleChangeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //设置扩展按钮的点击范围
    
    @weakify(self);
    
    [_btn_temporaryCar setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [_btn_temporaryDrivelib setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [_btn_temporarylib setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [_btn_temporaryIdentityCard setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    
    
    [self.btn_userNumber setTitle:@"历史0" forState:UIControlStateNormal];
    [self.btn_userNumber2 setTitle:@"历史0" forState:UIControlStateNormal];
    
    //设置更多设置下划线，直接设置不想用别人的子类，可以说我懒，觉得没有必要
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"更多信息"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFF8B33) range:strRange];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [self.btn_moreInfo setAttributedTitle:str forState:UIControlStateNormal];
    
    //当事人信息里面添加对UITextField的监听
    [self addChangeForEventEditingChanged:self.tf_name];
    [self addChangeForEventEditingChanged:self.tf_identityCard];
    [self addChangeForEventEditingChanged:self.tf_carNumber];
    [self addChangeForEventEditingChanged:self.tf_phone];
    [self addChangeForEventEditingChanged:self.tf_policyNo];
    
    //配置点击UITextField
    
    [self setUpClickUITextField:self.tf_carType];
    [self setUpClickUITextField:self.tf_drivingState];
    [self setUpClickUITextField:self.tf_illegalBehavior];
    [self setUpClickUITextField:self.tf_insuranceCompany];
    [self setUpClickUITextField:self.tf_responsibility];
    
    
    //配置通用UITextField

    [self setUpCommonUITextField:self.tf_name];
    [self setUpCommonUITextField:self.tf_identityCard];
    [self setUpCommonUITextField:self.tf_carNumber];
    [self setUpCommonUITextField:self.tf_phone];
    [self setUpCommonUITextField:self.tf_policyNo];
    
    //配置FSTextView
    [self.tv_describe setDelegate:(id<UITextViewDelegate> _Nullable)self];
    self.tv_describe.placeholder = @"请输入简述";
    self.tv_describe.maxLength = 150;   //最大输入字数
    
    [self.tv_describe addTextDidChangeHandler:^(FSTextView *textView) {
        // 文本改变后的相应操作.
        self.lb_textCount.text =
        [NSString stringWithFormat:@"%ld/%ld",textView.text.length,textView.maxLength];
        
    }];
    // 添加到达最大限制Block回调.
    [self.tv_describe addTextLengthDidMaxHandler:^(FSTextView *textView) {
        // 达到最大限制数后的相应操作.
    }];
    
    
    [[self.btn_userNumber rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        
        if (self.model.idNo && self.model.idNo.length > 17) {
            
            AccidentHistoricalListViewmodel * viewModel = [[AccidentHistoricalListViewmodel alloc] init];
            if (self.accidentType == AccidentTypeAccident) {
                viewModel.param.accidentType = @"1";
                viewModel.param.queryType = @"2";
                viewModel.param.cardNo = self.model.idNo;
            }else if (self.accidentType == AccidentTypeFastAccident){
                viewModel.param.accidentType = @"2";
                viewModel.param.queryType = @"2";
                viewModel.param.cardNo = self.model.idNo;
            }
            
            
            AccidentHistoryListVC * vc = [[AccidentHistoryListVC alloc] initWithViewModel:viewModel];
            
            AccidentPeopleVC * t_vc = (AccidentPeopleVC *)[ShareFun findViewController:self withClass:[AccidentPeopleVC class]];
            
            [t_vc.navigationController pushViewController:vc animated:YES];
            
        }
        
    }];
    
    
    [[self.btn_userNumber2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        
        if (self.model.carNo && self.model.carNo.length > 6) {
            
            AccidentHistoricalListViewmodel * viewModel = [[AccidentHistoricalListViewmodel alloc] init];
            if (self.accidentType == AccidentTypeAccident) {
                viewModel.param.accidentType = @"1";
                viewModel.param.queryType = @"1";
                viewModel.param.carNo = self.model.carNo;
            }else if (self.accidentType == AccidentTypeFastAccident){
                viewModel.param.accidentType = @"2";
                viewModel.param.queryType = @"1";
                viewModel.param.carNo = self.model.carNo;
            }
            
            AccidentHistoryListVC * vc = [[AccidentHistoryListVC alloc] initWithViewModel:viewModel];
            
            AccidentPeopleVC * t_vc = (AccidentPeopleVC *)[ShareFun findViewController:self withClass:[AccidentPeopleVC class]];
            
            [t_vc.navigationController pushViewController:vc animated:YES];
            
        }
        
    }];
    
    
}

#pragma mark - set && get

- (void)setModel:(AccidentPeopleMapModel *)model{
    
    _model = model;
    
    if (_model) {
        
        self.tf_name.text = _model.name;
        self.tf_identityCard.text = _model.idNo;
        self.tf_carType.text =  _model.vehicle;
        self.tf_carNumber.text = _model.carNo;
        self.tf_phone.text = _model.phone;
        self.tf_policyNo.text = _model.policyNo;
        self.tf_drivingState.text = _model.direct;
        self.tf_illegalBehavior.text = _model.behaviour;
        self.tf_insuranceCompany.text = _model.insuranceCompany;
        self.tf_responsibility.text = _model.responsibility;
        self.btn_temporaryCar.selected = [_model.isZkCl boolValue];
        self.btn_temporaryDrivelib.selected = [_model.isZkXsz boolValue];
        self.btn_temporarylib.selected = [_model.isZkJsz boolValue];
        self.btn_temporaryIdentityCard.selected = [_model.isZkSfz boolValue];
        self.tv_describe.text = _model.resume;
        
        
        @weakify(self);
        
        [[RACObserve(self.model, idNo) distinctUntilChanged] subscribeNext:^(NSString * x) {
            @strongify(self);
            if (x && x.length > 17) {
                [self.command_identNoCount execute:x];
            }
        }];
        
        
        [[RACObserve(self.model, carNo) distinctUntilChanged] subscribeNext:^(NSString * x) {
            @strongify(self);
            if (x && x.length > 6) {
                [self.command_carCount execute:x];
            }
        }];
        
        
        [self.command_identNoCount.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            
            if ([x isKindOfClass:[NSNumber class]]) {
                NSNumber * t_x = (NSNumber *)x;
                self.btn_userNumber.hidden = NO;
                self.image_userNumber.hidden = NO;
                [self.btn_userNumber setTitle:[NSString stringWithFormat:@"历史%d",[t_x intValue]] forState:UIControlStateNormal];
            }
        
        }];
        
        [self.command_carCount.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            
            if ([x isKindOfClass:[NSNumber class]]) {
                NSNumber * t_x = (NSNumber *)x;
                self.btn_userNumber2.hidden = NO;
                self.image_userNumber2.hidden = NO;
                [self.btn_userNumber2 setTitle:[NSString stringWithFormat:@"历史%d",[t_x intValue]] forState:UIControlStateNormal];
            }
        
        }];
        
        
    }

}



- (RACCommand *)command_identNoCount{
    
    if (_command_identNoCount == nil) {
        
        @weakify(self);
        _command_identNoCount = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
                
                AccidentMoreCountParam * param = [[AccidentMoreCountParam alloc] init];
                param.queryType = @"2";
                param.cardNo = input;
                if (self.accidentType == AccidentTypeAccident) {
                    param.accidentType = @"1";
                }else if (self.accidentType == AccidentTypeFastAccident){
                    param.accidentType = @"2";
                }
                
                
                AccidentMoreCountManger * manger = [[AccidentMoreCountManger alloc] init];
                manger.param = param;
                manger.isNoShowFail = YES;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        [subscriber sendNext:manger.carNoNumber];
                    }else{
                        [subscriber sendNext:@"加载失败"];
                    }
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@"加载失败"];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
        
    }
    
    return _command_identNoCount;
    
}



- (RACCommand *)command_carCount{
    
    if (_command_carCount == nil) {
        
        @weakify(self);
        _command_carCount = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
                
                AccidentMoreCountParam * param = [[AccidentMoreCountParam alloc] init];
                param.queryType = @"1";
                param.carNo = input;
                if (self.accidentType == AccidentTypeAccident) {
                    param.accidentType = @"1";
                }else if (self.accidentType == AccidentTypeFastAccident){
                    param.accidentType = @"2";
                }
                
                
                AccidentMoreCountManger * manger = [[AccidentMoreCountManger alloc] init];
                manger.param = param;
                manger.isNoShowFail = YES;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        [subscriber sendNext:manger.carNoNumber];
                    }else{
                        [subscriber sendNext:@"加载失败"];
                    }
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@"加载失败"];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
        
    }
    
    return _command_carCount;
    
}




- (AccidentGetCodesResponse *)codes{
    
    _codes = [ShareValue sharedDefault].accidentCodes;
    
    return _codes;
}

- (void)setAccidentType:(AccidentType)accidentType{
    
    _accidentType = accidentType;
   
    if (_accidentType == AccidentTypeAccident) {
        [CountAccidentHelper sharedDefault].state = @1;
    }else if (_accidentType == AccidentTypeFastAccident){
        [CountAccidentHelper sharedDefault].state = @9;
    }
    
    //快处事故的UI处理
    if (_accidentType == AccidentTypeFastAccident){
        
        self.isShowMoreInfo               = NO;
        self.btn_moreInfo.hidden          = YES;
        _layout_InsuranceCompany.constant = 26.f;
        self.lb_illegalBehavior.hidden    = YES;
        self.tf_illegalBehavior.hidden    = YES;
        [self layoutIfNeeded];
    }
    
}

- (void)setIsShowMoreInfo:(BOOL)isShowMoreInfo{
    
    _isShowMoreInfo = isShowMoreInfo;
    
    if (_isShowMoreInfo == NO) {
        for (UILabel *t_label in _lb_moreInfos) {
            t_label.hidden = YES;
        }
        for (UIButton *t_btn in _btn_moreInfos) {
            t_btn.hidden = YES;
        }
        _layout_moreinfo.constant = 12.5f;
        [self layoutIfNeeded];
        
    }else{
        for (UILabel *t_label in _lb_moreInfos) {
            t_label.hidden = NO;
        }
        for (UIButton *t_btn in _btn_moreInfos) {
            t_btn.hidden = NO;
        }
        _layout_moreinfo.constant = 135.5f;
        [self layoutIfNeeded];
    }
    
}

#pragma mark - 配置UITextField

- (void)setUpClickUITextField:(UITextField *)textField{
    
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 5)];
    imageView.image = [UIImage imageNamed:@"icon_dropDownArrow.png"];
    imageView.contentMode = UIViewContentModeCenter;
    
    UIView * t_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 5)];
    [t_view addSubview:imageView];
    
    textField.rightView = t_view;
    textField.rightViewMode = UITextFieldViewModeAlways;
    [textField setDelegate:(id<UITextFieldDelegate> _Nullable)self];
    
}

- (void)setUpCommonUITextField:(UITextField *)textField{
    
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    
}


#pragma mark - 当事人信息的更多信息按钮点击

- (IBAction)handleBtnMoreInfoClicked:(id)sender {
    
    [[ShareFun getTableView:self] beginUpdates];
    self.isShowMoreInfo = !_isShowMoreInfo;
    if (self.block) {
        self.block(_isShowMoreInfo);
    }
    
    [[ShareFun getTableView:self] endUpdates];
    
    [[ShareFun getTableView:self] scrollToRow:0 inSection:0 atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
   
}

#pragma mark - 车辆类型按钮点击

- (IBAction)handleBtnCarTypeClicked:(id)sender {
    
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"车辆类型" items:self.codes.vehicle block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        SW(strongSelf, weakSelf);
        strongSelf.tf_carType.text = title;
        strongSelf.model.vehicleId =  @(itemId);
        
        [BottomView dismissWindow];
        
    }];
    
}

#pragma mark - 行驶状态按钮点击

- (IBAction)handleBtnTrafficStateClicked:(id)sender {
    
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"行驶状态" items:self.codes.driverDirect block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        
        SW(strongSelf, weakSelf);
        strongSelf.tf_drivingState.text = title;
        strongSelf.model.directId =  @(itemType);
        [BottomView dismissWindow];
        
    }];
    
}

#pragma mark - 违法行为按钮点击

- (IBAction)handleBtnIllegalBehaviorClicked:(id)sender {
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"违法行为" items:self.codes.behaviour block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        
        SW(strongSelf, weakSelf);
        strongSelf.tf_illegalBehavior.text = title;
        strongSelf.model.behaviourId =  @(itemId);
        [BottomView dismissWindow];
        
    }];
    
}

#pragma mark - 保险公司按钮点击

- (IBAction)handleBtnInsuranceCompanyClicked:(id)sender {
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"保险公司" items:self.codes.insuranceCompany block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        
        SW(strongSelf, weakSelf);
        strongSelf.tf_insuranceCompany.text = title;
        strongSelf.model.insuranceCompanyId =  @(itemId);
        
        [BottomView dismissWindow];
        
    }];
}

#pragma mark - 责任按钮点击

- (IBAction)handleBtnResponsibilityClicked:(id)sender {
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"事故责任" items:self.codes.responsibility block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        
        SW(strongSelf, weakSelf);
        strongSelf.tf_responsibility.text = title;
        strongSelf.model.responsibilityId =  @(itemId);
        [BottomView dismissWindow];
        
    }];
    
}


#pragma mark - 是否暂扣车辆按钮点击

- (IBAction)handleBtnTemporaryCarClicked:(id)sender {
    _btn_temporaryCar.selected = !_btn_temporaryCar.selected;
    _model.isZkCl = @(_btn_temporaryCar.selected);
}

#pragma mark - 是否暂扣行驶证按钮点击


- (IBAction)handleBtnTemporaryDrivingLicenseClicked:(id)sender {
    _btn_temporaryDrivelib.selected = !_btn_temporaryDrivelib.selected;
    _model.isZkXsz = @(_btn_temporaryDrivelib.selected);
    
}

#pragma mark - 是否暂扣驾驶证按钮点击

- (IBAction)handleBtnTemporaryLicenseClicked:(id)sender {
    _btn_temporarylib.selected = !_btn_temporarylib.selected;
    _model.isZkJsz = @(_btn_temporarylib.selected);
}


#pragma mark - 是否暂扣身份证按钮点击

- (IBAction)handleBtnIdentityCardClicked:(id)sender {
    _btn_temporaryIdentityCard.selected = !_btn_temporaryIdentityCard.selected;
    _model.isZkSfz = @(_btn_temporaryIdentityCard.selected);
    
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
        AccidentPeopleVC *t_vc = (AccidentPeopleVC *)[ShareFun findViewController:self withClass:[AccidentPeopleVC class]];
        LRCameraVC *home = [[LRCameraVC alloc] init];
        home.isAccident = YES;
        home.type = 2;
        home.fininshCaptureBlock = ^(LRCameraVC *camera) {
            if (camera) {
                if (camera.type == 2) {
                    strongSelf.tf_name.text = camera.commonIdentifyResponse.name;
                    strongSelf.tf_identityCard.text = camera.commonIdentifyResponse.idNo;
                    strongSelf.model.name =camera.commonIdentifyResponse.name;
                    strongSelf.model.idNo = camera.commonIdentifyResponse.idNo;
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        ImageFileInfo *imageFileInfo = camera.imageInfo;
                        imageFileInfo.name = key_certFiles;
                        [strongSelf.model addCertInArrayWithImageInfo:imageFileInfo withType:@"身份证"];
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
        AccidentPeopleVC *t_vc = (AccidentPeopleVC *)[ShareFun findViewController:self withClass:[AccidentPeopleVC class]];
        LRCameraVC *home = [[LRCameraVC alloc] init];
        home.isAccident = YES;
        home.type = 3;
        home.fininshCaptureBlock = ^(LRCameraVC *camera) {
            if (camera) {
                if (camera.type == 3) {
                    strongSelf.tf_name.text = camera.commonIdentifyResponse.name;
                    strongSelf.tf_identityCard.text = camera.commonIdentifyResponse.idNo;
                    strongSelf.model.name = camera.commonIdentifyResponse.name;
                    strongSelf.model.idNo = camera.commonIdentifyResponse.idNo;
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        ImageFileInfo *imageFileInfo = camera.imageInfo;
                        imageFileInfo.name = key_certFiles;
                        [strongSelf.model addCertInArrayWithImageInfo:imageFileInfo withType:@"驾驶证"];
                    
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
    AccidentPeopleVC *t_vc = (AccidentPeopleVC *)[ShareFun findViewController:self withClass:[AccidentPeopleVC class]];
    LRCameraVC *home = [[LRCameraVC alloc] init];
    home.isAccident = YES;
    home.type = 4;
    home.fininshCaptureBlock = ^(LRCameraVC *camera) {
        SW(strongSelf, weakSelf);
        if (camera) {
            if (camera.type == 4) {
                strongSelf.tf_carNumber.text = camera.commonIdentifyResponse.carNo;
                strongSelf.tf_carType.text = camera.commonIdentifyResponse.vehicleType;
                
                strongSelf.model.carNo = camera.commonIdentifyResponse.carNo;
                
                NSInteger IdNo = [strongSelf.codes searchNameWithModelName:camera.commonIdentifyResponse.vehicleType WithArray:strongSelf.codes.vehicle];
                strongSelf.model.vehicleId = @(IdNo);
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    ImageFileInfo *imageFileInfo = camera.imageInfo;
                    imageFileInfo.name = key_certFiles;
                    [strongSelf.model addCertInArrayWithImageInfo:imageFileInfo withType:@"行驶证"];
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


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
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


#pragma mark - 添加监听Textfield的变化，用于给参数实时赋值

- (void)addChangeForEventEditingChanged:(UITextField *)textField{
    [textField addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
}


-(void)passConTextChange:(id)sender{
    UITextField* textField = (UITextField*)sender;
    LxDBAnyVar(textField.text);
    NSInteger length =  textField.text.length;

    if (textField == _tf_name) {
        _model.name = length > 0 ? _tf_name.text : nil;
        
    }
    if (textField == _tf_identityCard) {
        
        _model.idNo = length > 0 ? _tf_identityCard.text : nil;
        //用于请求是否有违规行为
        [[CountAccidentHelper sharedDefault] setIdNo:_tf_identityCard.text];
    }
    if (textField == _tf_carNumber) {
        
        _model.carNo = length > 0 ? _tf_carNumber.text : nil;
        //用于请求是否有违规行为
        [[CountAccidentHelper sharedDefault] setCarNo:_tf_carNumber.text];
    }
    if (textField == _tf_phone) {
        
        _model.phone = length > 0 ? _tf_phone.text : nil;
        //用于请求是否有违规行为
        [[CountAccidentHelper sharedDefault] setTelNum:_tf_phone.text];
    }
    
    if (textField == _tf_policyNo) {
        
        _model.policyNo = length > 0 ? _tf_policyNo.text : nil;
    }
    
}


#pragma mark - 实时监听UITextView内容的变化
//只能监听键盘输入时的变化(setText: 方式无法监听),如果想修复可以参考http://www.jianshu.com/p/75355acdd058
- (void)textViewDidChange:(FSTextView *)textView{
    
    _model.resume = textView.formatText;
    
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



#pragma mark - public







#pragma mark - dealloc
- (void)dealloc{
    LxPrintf(@"AccidentPeopleChangeCell dealloc");

}


@end
