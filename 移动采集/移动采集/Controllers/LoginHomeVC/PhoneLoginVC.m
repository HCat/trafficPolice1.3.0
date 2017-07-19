//
//  PhoneLoginVC.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "PhoneLoginVC.h"
#import "LRCountDownButton.h"
#import "LoginAPI.h"
#import "JPUSHService.h"


@interface PhoneLoginVC ()

@property (weak, nonatomic) IBOutlet LRCountDownButton *btn_countDown;
@property (weak, nonatomic) IBOutlet UITextField *tf_phone;
@property (weak, nonatomic) IBOutlet UITextField *tf_code;

@property (weak, nonatomic) IBOutlet UIButton *btn_commit;

@property (nonatomic,copy) NSString *acId; //获取验证码得到的短信ID

@property (nonatomic,assign) BOOL isCanCommit;

@end

@implementation PhoneLoginVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"短信验证";
    self.isCanCommit = NO;
    
    _tf_phone.text = _phone;
    
    _btn_countDown.durationOfCountDown = 60;
    _btn_countDown.originalBGColor = UIColorFromRGB(0x467AE3);
    _btn_countDown.processBGColor = UIColorFromRGB(0xe2e2e2);
    _btn_countDown.processFont = [UIFont systemFontOfSize:12.f];
    _btn_countDown.originalFont = [UIFont systemFontOfSize:15.f];
    WS(weakSelf);

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
        
        LoginTakeCodeManger *manger = [LoginTakeCodeManger new];
        manger.openId = [ShareValue sharedDefault].unionid;
       
        [strongSelf.btn_countDown startCountDown];
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                strongSelf.acId = manger.acId;
            }else{
                [strongSelf.btn_countDown endCountDown];
            
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {

            [strongSelf.btn_countDown endCountDown];
        }];
    
    };
    
    //事故信息里面添加对UITextField的监听
    [self addChangeForEventEditingChanged:self.tf_phone];
    //事故信息里面添加对UITextField的监听
    [self addChangeForEventEditingChanged:self.tf_code];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
}


#pragma mark - set && get

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


#pragma mark - ButtonAction


- (IBAction)handleBtnLoginClicked:(id)sender {
    
    if (self.tf_phone.text.length == 0) {
        [LRShowHUD showError:@"请输入手机号" duration:1.0f inView:self.view config:nil];
        return ;
    }
    
    if (![ShareFun validatePhoneNumber:self.tf_phone.text]) {
        [LRShowHUD showError:@"手机号码格式错误!" duration:1.0f inView:self.view config:nil];
        return ;
    }
    
    if (self.tf_code.text.length == 0) {
        [LRShowHUD showError:@"请输入验证码!" duration:1.0f inView:self.view config:nil];
        return ;
    }
    
    if (self.acId.length == 0 || self.acId == nil) {
        [LRShowHUD showError:@"没有获取验证码!" duration:1.0f inView:self.view config:nil];
        return ;
    }
    

    LoginCheckParam *param = [[LoginCheckParam alloc] init];
    param.openId = [ShareValue sharedDefault].unionid;
    param.acId = self.acId;
    param.authCode = _tf_code.text;
    param.equipmentId = [ShareFun getUniqueDeviceIdentifierAsString];
    param.platform = @"ios";
    
    LRShowHUD * hud = [LRShowHUD showActivityLoading:@"登录中..." inView:self.view config:nil];
    
    LoginCheckManger *manger = [LoginCheckManger new];
    manger.param = param;
    manger.isNeedShowHud = YES;
    manger.successMessage = @"登录成功!";
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
    
        [hud hide];
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            /*********** 归档用户 ************/
            [UserModel setUserModel:manger.userModel];
            [JPUSHService setAlias:[UserModel getUserModel].userId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
            } seq:0];
            /*********** 存储token值用于后面的请求 ************/
            [ShareValue sharedDefault].token = manger.userModel.token;
            /*********** 全局为统一的Url添加token ************/
            [LRBaseRequest setupRequestFilters:@{@"token": [ShareValue sharedDefault].token}];
            
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1.5f *NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                /*********** 切换到首页界面 ************/
                [ApplicationDelegate initAKTabBarController];
                ApplicationDelegate.window.rootViewController = ApplicationDelegate.vc_tabBar;
         });
        
     }
    
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [hud hide];
        
    }];
    
}

#pragma mark - 添加监听Textfield的变化，用于给参数实时赋值

- (void)addChangeForEventEditingChanged:(UITextField *)textField{
    [textField addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 实时监听UITextField内容的变化

-(void)passConTextChange:(id)sender{
    if (_tf_phone.text.length > 0 && _tf_code.text.length > 0) {
        self.isCanCommit = YES;
    }else{
        self.isCanCommit = NO;
    }
    
}



#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    LxPrintf(@"PhoneLoginVC dealloc");

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
