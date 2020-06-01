//
//  PhoneLoginVC.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "PhoneLoginVC.h"
#import "LRCountDownButton.h"
#import "LAJIBaseRequest.h"
#import "LoginAPI.h"
#import "JPUSHService.h"
#import "CRBoxInputView.h"

@interface PhoneLoginVC ()

@property (weak, nonatomic) IBOutlet LRCountDownButton *btn_countDown;
@property (weak, nonatomic) IBOutlet UITextField *tf_phone;
@property (weak, nonatomic) IBOutlet UILabel *lb_tip;

@property (weak, nonatomic) IBOutlet UIButton *btn_back;
@property(nonatomic, strong) CRBoxInputView *boxInputView;

@property (nonatomic,copy) NSString * str_code;     //短信验证码
@property (nonatomic,copy) NSString * acId;         //获取验证码得到的短信ID
@property (nonatomic,copy) NSString * userId;       //获取验证码得到的短信ID
@property (nonatomic, strong) NSNumber * codeLength;            //验证码长度
@property (nonatomic, strong) NSNumber * codeType;              //验证码类型

@end

@implementation PhoneLoginVC

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tf_phone becomeFirstResponder];
    
    _btn_countDown.durationOfCountDown = 60;
    _btn_countDown.originalBGColor = [UIColor clearColor];
    _btn_countDown.processBGColor = [UIColor clearColor];
    _btn_countDown.originalColor = UIColorFromRGB(0x315DF1);
    _btn_countDown.processColor = UIColorFromRGB(0x315DF1);
    _btn_countDown.processFont = [UIFont systemFontOfSize:15.f];
    _btn_countDown.originalFont = [UIFont systemFontOfSize:15.f];
    
    WS(weakSelf);
    
    [[_btn_back rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        SW(strongSelf, weakSelf);
        
        [strongSelf.navigationController popViewControllerAnimated:YES];
        
    }];
    
    CRBoxInputCellProperty *cellProperty = [CRBoxInputCellProperty new];
    cellProperty.cellBorderColorNormal = UIColorFromRGB(0xE5E5E5);
    cellProperty.cellBorderColorSelected = UIColorFromRGB(0x315DF1);
    cellProperty.cellBorderColorFilled = UIColorFromRGB(0xF4F4F4);
    cellProperty.borderWidth = 1.0f;
    cellProperty.cellBgColorNormal = UIColorFromRGB(0xF4F4F4);
    cellProperty.cellBgColorSelected = UIColorFromRGB(0xFFFFFF);
    cellProperty.cellBgColorFilled = UIColorFromRGB(0xFFFFFF);
    cellProperty.cellFont = [UIFont systemFontOfSize:30]; //可选
    cellProperty.cellTextColor = UIColorFromRGB(0x333333); //可选
//    cellProperty.configCellShadowBlock = ^(CALayer * _Nonnull layer) {
//        layer.shadowColor = [UIColorFromRGB(0x313340) colorWithAlphaComponent:0.2].CGColor;
//        layer.shadowOpacity = 1;
//        layer.shadowOffset = CGSizeMake(0, 2);
//        layer.shadowRadius = 4;
//    };
    
    self.boxInputView = [CRBoxInputView new];
    self.boxInputView.boxFlowLayout.itemSize = CGSizeMake(60, 60);
    
    self.boxInputView.ifNeedCursor = NO;
    self.boxInputView.customCellProperty = cellProperty;
    [self.boxInputView loadAndPrepareViewWithBeginEdit:NO];
    
    if (@available(iOS 12.0, *)) {
        _boxInputView.textContentType = UITextContentTypeOneTimeCode;
    }else if (@available(iOS 10.0, *)) {
        _boxInputView.textContentType = @"one-time-code";
    }
    
    
    if (!_boxInputView.textDidChangeblock) {
        _boxInputView.textDidChangeblock = ^(NSString *text, BOOL isFinished) {
            
            SW(strongSelf, weakSelf);
            NSLog(@"您输入的验证码是%@",text);
            
            strongSelf.str_code = text;
            if (strongSelf.str_code.length == 4) {
                [strongSelf handleBtnLoginClicked:nil];
            }
        };
    }
    
    [self.view addSubview:_boxInputView];
    [_boxInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        make.leading.mas_equalTo(34);
        make.trailing.mas_equalTo(-34);
        make.height.mas_equalTo(60);
        make.top.equalTo(strongSelf.lb_tip.mas_bottom).offset(20);
    }];
    
    _btn_countDown.beginBlock = ^{
        
        SW(strongSelf, weakSelf);
    
        if (strongSelf.tf_phone.text.length == 0) {
            
            [LRShowHUD showError:@"请输入手机号" duration:1.0f inView:strongSelf.view config:nil];
            [strongSelf.btn_countDown endCountDown];
            
            return ;
        }
        
        if (![ShareFun validatePhoneNumber:strongSelf.tf_phone.text]) {
            
            [LRShowHUD showError:@"手机号码格式错误!" duration:1.0f inView:strongSelf.view config:nil];
            [strongSelf.btn_countDown endCountDown];
            
            return ;
        }
        
        [strongSelf.tf_phone resignFirstResponder];
        
        
        LoginMobileManger *manger = [LoginMobileManger new];
        manger.mobile = strongSelf.tf_phone.text;
        manger.orgId = [ShareValue sharedDefault].orgId;
       
        [strongSelf.btn_countDown startCountDown];
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                strongSelf.acId = manger.mobileModel.acId;
                strongSelf.userId = manger.mobileModel.userId;
                strongSelf.codeLength = manger.mobileModel.codeLength;
                strongSelf.codeType = manger.mobileModel.codeType;
                
//                strongSelf.tf_codeInput.inputType = [strongSelf.codeLength integerValue];
//                [strongSelf.tf_codeInput initSubviews];

                if ([strongSelf.codeType isEqualToNumber:@0]) {
                    [ShareFun showTipLable:@"短信验证码已发送到您的手机，请注意查收"];
                }else{
                    [ShareFun showTipLable:@"微信验证码已发送到您的微信，请注意查收"];
                }
                
                NSString *server_url = [NSString stringWithFormat:@"http://%@",manger.mobileModel.interfaceUrl];
                NSString *webSocket_url = [NSString stringWithFormat:@"ws://%@/websocket",manger.mobileModel.interfaceUrl];
                
                [ShareValue sharedDefault].server_url = server_url;
                [ShareValue sharedDefault].webSocket_url = webSocket_url;
                
                //配置统一的网络基地址
                YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
                NSLog(@"%@",Base_URL);
                config.baseUrl = Base_URL;
                
            }else{
                
                //[LRShowHUD showError:@"获取验证码失败" duration:1.5f];
                [strongSelf.btn_countDown endCountDown];
            
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            [LRShowHUD showError:@"获取验证码失败" duration:1.5f];
            
            [strongSelf.btn_countDown endCountDown];
        }];
    
    };
    
}

- (void)viewWillAppear:(BOOL)animated{
//    [self.navigationController.navigationBar setBackgroundColor:DefaultNavColor];
//    self.navigationController.navigationBarHidden = NO;
    
}

- (IBAction)handleBtnLoginClicked:(id)sender {
    
    if (self.tf_phone.text.length == 0) {
        [LRShowHUD showError:@"请输入手机号" duration:1.0f inView:self.view config:nil];
        return ;
    }
    
    if (![ShareFun validatePhoneNumber:self.tf_phone.text]) {
        [LRShowHUD showError:@"手机号码格式错误!" duration:1.0f inView:self.view config:nil];
        return ;
    }
    
    LoginCheck2Param *param = [[LoginCheck2Param alloc] init];
    param.acId = self.acId;
    param.authCode = self.str_code;
    param.equipmentId = [ShareFun getUniqueDeviceIdentifierAsString];
    param.platform = @"ios";
    param.userId = self.userId;
    param.mobile = _tf_phone.text;
    
    LoginCheck2Manger *manger = [LoginCheck2Manger new];
    manger.param = param;
    [manger configLoadingTitle:@"登录"];
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (manger.responseModel.code == CODE_SUCCESS) {
            /*********** 归档用户 ************/
            [UserModel setUserModel:manger.userModel];
            [ShareValue sharedDefault].phone = [UserModel getUserModel].phone;
            [ShareFun LoginInbeforeDone];
            [JPUSHService setAlias:[UserModel getUserModel].userId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
            } seq:0];
            /*********** 初始化定位存储 *************/
            [[LocationStorage sharedDefault] initializationSwitchLocation];
            /*********** 存储token值用于后面的请求 ************/
            [ShareValue sharedDefault].token = manger.userModel.token;
            /*********** 全局为统一的Url添加token ************/
            [LRBaseRequest setupRequestFilters:@{@"token": [ShareValue sharedDefault].token}];
            //[LAJIBaseRequest setupRequestFilters:@{@"token": [ShareValue sharedDefault].token}];
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.5f *NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                /*********** 切换到首页界面 ************/
                [ApplicationDelegate initAKTabBarController];
                ApplicationDelegate.window.rootViewController = ApplicationDelegate.vc_tabBar;
                
            });
        
        }
    
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    LxPrintf(@"PhoneLoginVC dealloc");

}

@end


