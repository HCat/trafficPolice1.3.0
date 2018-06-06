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

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic , assign) NSInteger count;
@property (strong , nonatomic) NSMutableArray *textArr;
@property (nonatomic , assign) NSString *saveTextStr;


@property (weak, nonatomic) IBOutlet UIButton *btn_commit;

@property (nonatomic,copy) NSString *acId; //获取验证码得到的短信ID

@property (nonatomic,assign) BOOL isCanCommit;

@end

@implementation PhoneLoginVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"短信验证";
    self.isCanCommit = NO;
    
    self.textArr = [NSMutableArray array];
    self.count = 6;
    self.saveTextStr = @"";
    
    _tf_phone.text = _phone;
    [self.tf_code setDelegate:(id<UITextFieldDelegate> _Nullable)self];
    [self.tf_code addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _btn_countDown.durationOfCountDown = 60;
    _btn_countDown.originalBGColor = UIColorFromRGB(0x1DBE7E);
    _btn_countDown.processBGColor = DefaultBtnNuableColor;
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
                
                [LRShowHUD showError:@"获取验证码失败" duration:1.5f];
                [strongSelf.btn_countDown endCountDown];
            
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            [LRShowHUD showError:@"获取验证码失败" duration:1.5f];
            
            [strongSelf.btn_countDown endCountDown];
        }];
    
    };
    
    //事故信息里面添加对UITextField的监听
    [self addChangeForEventEditingChanged:self.tf_phone];
    //事故信息里面添加对UITextField的监听
    [self addChangeForEventEditingChanged:self.tf_code];
    
    [self.collectionView registerClass:[CodeCell class] forCellWithReuseIdentifier:@"CodeCellID"];
    
    UITapGestureRecognizer *keyboardUpTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(KeyboardUp)];
    [self.collectionView addGestureRecognizer:keyboardUpTap];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
}


#pragma mark - set && get

-(void)setIsCanCommit:(BOOL)isCanCommit{
    _isCanCommit = isCanCommit;
    if (_isCanCommit == NO) {
        _btn_commit.enabled = NO;
        [_btn_commit setBackgroundColor:DefaultBtnNuableColor];
    }else{
        _btn_commit.enabled = YES;
        [_btn_commit setBackgroundColor:UIColorFromRGB(0x1DBE7E)];
    }
}


#pragma mark - ButtonAction

-(void)KeyboardUp
{
    [self.tf_code becomeFirstResponder];
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
    
    LoginCheckManger *manger = [LoginCheckManger new];
    manger.param = param;
    [manger configLoadingTitle:@"登录"];
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (manger.responseModel.code == CODE_SUCCESS) {
            /*********** 归档用户 ************/
            [UserModel setUserModel:manger.userModel];
            [ShareFun openWebSocket];
            [JPUSHService setAlias:[UserModel getUserModel].userId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
            } seq:0];
            /*********** 初始化定位存储 *************/
            [[LocationStorage sharedDefault] initializationSwitchLocation];
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

- (void)textFieldDidChange:(UITextField *)textField {
    
    if (textField == _tf_code) {
        
        [self.textArr removeAllObjects];
        NSLog(@"textField:%@",textField.text);
        self.saveTextStr = textField.text;
        
        for (int i = 0; i < textField.text.length; i ++) {
            NSRange range;
            range.location = i;
            range.length = 1;
            NSString *tempString = [textField.text substringWithRange:range];
            [self.textArr addObject:tempString];
        }
        
        if (self.textArr.count == 6) {
            [self handleBtnLoginClicked:nil];
        }
        
        [self.collectionView reloadData];
    }
  
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == _tf_code) {
        if ([string isEqualToString:@""]) {
            NSLog(@"删除");
            return YES;
        }
        if (self.tf_code.text.length >= self.count)
        {
            NSLog(@"超了");
            NSLog(@"此时的self.textArr:%@",self.textArr);
    
            return NO;
        }
        
        return YES;
    }else{
        return YES;
    }
   
}


#pragma mark - UICollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    CodeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CodeCellID" forIndexPath:indexPath];
    
    if (self.textArr.count == 0) {
        cell.lb_number.text = @"";
    }else{
        if (indexPath.row <= self.textArr.count - 1) {
            cell.lb_number.text = self.textArr[indexPath.row];
        }else{
            cell.lb_number.text = @"";
        }
    }
    return cell;
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((collectionView.frame.size.width - 5 * ((collectionView.frame.size.width - 6 * 40)/5))/self.count, collectionView.frame.size.height);
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
    
}

// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return (collectionView.frame.size.width - 6 * 40)/5;
    
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


@implementation CodeCell

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.lb_number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        self.lb_number.center = CGPointMake(self.contentView.frame.size.width/2, self.contentView.frame.size.height/2);
        self.lb_number.textAlignment = NSTextAlignmentCenter;
        self.lb_number.font = [UIFont systemFontOfSize:20];
        self.lb_number.textColor = DefaultTextColor;
        self.lb_number.layer.borderWidth  = 1.f;
        self.lb_number.layer.borderColor = [DefaultColor CGColor];
        [self.contentView addSubview:self.lb_number];
        
    }
    
    return self;
    
}


@end
