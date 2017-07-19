//
//  LoginHomeVC.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "LoginHomeVC.h"

#import <AFNetworking.h>

#import "LoginAPI.h"
#import "CommonAPI.h"

#import "PhoneLoginVC.h"



@interface LoginHomeVC ()

@property (weak, nonatomic) IBOutlet UIButton *btn_visitor;

@property (weak, nonatomic) IBOutlet UIButton *btn_weixinLogin;

@end

@implementation LoginHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinLoginSuccess:) name:NOTIFICATION_WX_LOGIN_SUCCESS object:nil];
    
    if (![WXApi isWXAppInstalled]) {
        self.btn_weixinLogin.hidden = YES;
        
    }else{
        self.btn_weixinLogin.hidden = NO;
    
    }
    
    self.btn_visitor.hidden = YES;
    [self judgeNeedShowVisitor];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;

}

#pragma mark -

- (void)judgeNeedShowVisitor{
    
    WS(weakSelf);
    CommonValidVisitorManger *manger = [[CommonValidVisitorManger alloc] init];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            if ([manger.responseModel.data intValue] == 0) {
                strongSelf.btn_visitor.hidden = YES;
            }else{
                strongSelf.btn_visitor.hidden = NO;
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        strongSelf.btn_visitor.hidden = YES;
    }];
    
}

#pragma mark - buttonAction 

- (IBAction)weixinLoginAction:(id)sender {
    
    SendAuthReq *req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"wxlogin" ;
    req.openID = WEIXIN_APP_ID;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];

}

- (IBAction)handleLoginOfVisitorAction:(id)sender {

    LoginVisitorManger *manger = [LoginVisitorManger new];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
    
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
       
        
    }];
    
}


#pragma mark - WeixinLoginSucessNotification

- (void)weixinLoginSuccess:(NSNotification *)notification{
    if (notification.userInfo != nil) {
        [self getOpenidAndTokenFromWxCode:[notification.userInfo objectForKey:@"code"]];
    }
}

- (void)getOpenidAndTokenFromWxCode:(NSString*)code {
    WS(weakSelf);
    
    LRShowHUD *hud = [LRShowHUD showActivityLoading:@"登录中..." inView:nil config:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", nil];
    //通过 appid  secret 认证code . 来发送获取 access_token的请求
    [manager GET:[NSString stringWithFormat:WEIXIN_BASE_URL,WEIXIN_APP_ID,WEIXIN_APP_SECRET,code] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {  //获得access_token，然后根据access_token获取用户信息请求。
        SW(strongSelf, weakSelf);
        
        if (responseObject == nil) {
            
            [LRShowHUD showError:@"微信授权错误,请重试!" duration:1.5f inView:self.view config:nil];
            
            return ;
            
        }
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        LxDBAnyVar(dic);
        
        /*
         access_token	接口调用凭证
         expires_in	access_token接口调用凭证超时时间，单位（秒）
         refresh_token	用户刷新access_token
         openid	授权用户唯一标识
         scope	用户授权的作用域，使用逗号（,）分隔
         unionid	 当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
         */
        
        [ShareValue sharedDefault].unionid  = [dic valueForKey:@"unionid"];
        NSString* unionid=[dic valueForKey:@"unionid"];
        
        LoginManger *t_loginManger = [[LoginManger alloc] init];
        t_loginManger.openId = unionid;
        [t_loginManger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            [hud hide];
            
            if(t_loginManger.responseModel.code == CODE_SUCCESS){
                [ShareValue sharedDefault].phone = t_loginManger.phone;
                
                PhoneLoginVC *t_vc = [PhoneLoginVC new];
                t_vc.phone = [ShareValue sharedDefault].phone;
                [strongSelf.navigationController pushViewController:t_vc animated:YES];
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
             [hud hide];
            
        }];
        

//        NSString* accessToken = [dic valueForKey:@"access_token"];
//        NSString* openID = [dic valueForKey:@"openid"];
//        [ShareValue sharedDefault].openid   = [dic valueForKey:@"openid"];
//        [strongSelf requestUserInfoByToken:accessToken andOpenid:openID];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LxPrintf(@"error %@",error.localizedFailureReason);
        [hud hide];
    }];
    
}

-(void)requestUserInfoByToken:(NSString *)token andOpenid:(NSString *)openID{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject == nil) {
            
            [LRShowHUD showError:@"微信授权错误,请重试!" duration:1.5f inView:self.view config:nil];
            
            return ;
            
        }
        
        NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //开发人员拿到相关微信用户信息后， 需要与后台对接，进行登录
        LxPrintf(@"login success dic  ==== %@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LxPrintf(@"error %ld",(long)error.code);
    }];
    
}


#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_WX_LOGIN_SUCCESS object:nil];
    LxPrintf(@"LoginHomeVC dealloc");

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
