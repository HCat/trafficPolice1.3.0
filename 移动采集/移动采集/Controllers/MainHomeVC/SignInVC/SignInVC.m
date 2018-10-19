//
//  SignInVC.m
//  移动采集
//
//  Created by hcat on 2017/9/4.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "SignInVC.h"
#import "SignAPI.h"
#import "BorderLabel.h"
#import "UserModel.h"


#import "UITableView+Lr_Placeholder.h"

#import "NetWorkHelper.h"
#import "SignInCell.h"
#import "SignListCell.h"

#import "SRAlertView.h"
#import "LocationHelper.h"
#import "WebSocketHelper.h"
#import "StepNumberHelper.h"


@interface SignInVC ()

@property (weak, nonatomic) IBOutlet UILabel *lb_name;  //姓名
@property (weak, nonatomic) IBOutlet UILabel *lb_affiliation;   //所属大队
@property (weak, nonatomic) IBOutlet BorderLabel *lb_currentTime;   //当前时间

@property (weak, nonatomic) IBOutlet UITableView *tb_content;

@property (weak, nonatomic) IBOutlet UILabel *lb_countTip;

@property (nonatomic,strong) NSMutableArray *arr_content;

@property (nonatomic,strong) NSDate *curretnTime;

@property (nonatomic,assign) BOOL isUptime;
@property (nonatomic,assign) BOOL isFirstLoad;  //是否是第一次加载数据
@property (nonatomic,strong) LRShowHUD *hud;

@end

@implementation SignInVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title= @"签到";
    
    self.isUptime = NO;
    self.isFirstLoad = YES;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChange) name:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil];
    
    _lb_currentTime.edgeInsets = UIEdgeInsetsMake(8, 8+2, 8, 8+2);//设置内边距
    [_lb_currentTime sizeToFit];//重新计算尺寸，会执行Label内重写的方法
    _lb_currentTime.layer.cornerRadius = 5.f;
    _lb_currentTime.layer.masksToBounds = YES;
    
    _lb_name.text = [UserModel getUserModel].realName;
    _lb_affiliation.text =[UserModel getUserModel].departmentName;
    
    _tb_content.isNeedPlaceholderView = YES;
    _tb_content.firstReload = YES;
    
    _tb_content.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tb_content setSeparatorInset:UIEdgeInsetsZero];
    [_tb_content setLayoutMargins:UIEdgeInsetsZero];
    
    WS(weakSelf);
    [_tb_content setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        [strongSelf loadSignListRequest];
    }];
    
    [self loadSignListRequest];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        [strongSelf loadSignListRequest];
    };
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    
}

#pragma mark - 请求签到数据

- (void)loadSignListRequest{
    
    WS(weakSelf);
    
    self.lb_currentTime.hidden = YES;
    
    if (_arr_content && _arr_content.count > 0) {
        [_arr_content removeAllObjects];
    }
    
    SignListManger *manger = [[SignListManger alloc] init];
    if (_isFirstLoad) {
        [manger configLoadingTitle:@"加载"];
    }
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        strongSelf.isFirstLoad = NO;
        
        if (manger.responseModel.code == CODE_SUCCESS) {
        
            strongSelf.arr_content = [manger.signListReponse.list mutableCopy];
            strongSelf.lb_currentTime.hidden = NO;
            strongSelf.lb_currentTime.text = [ShareFun timeWithTimeInterval:manger.signListReponse.currentTime dateFormat:@"yyyy.MM.dd"];
            NSString * t_currentTime = [ShareFun timeWithTimeInterval:manger.signListReponse.currentTime dateFormat:@"HH:mm:ss"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"HH:mm:ss"];
            strongSelf.curretnTime = [formatter dateFromString:t_currentTime];
            strongSelf.isUptime = YES;
            [strongSelf.tb_content reloadData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf,weakSelf);
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            if (strongSelf.arr_content.count > 0) {
                [strongSelf.arr_content removeAllObjects];
            }
            strongSelf.tb_content.isNetAvailable = YES;
            [strongSelf.tb_content reloadData];
        }
        
    }];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    if (_arr_content) {
        count = _arr_content.count + 1;
    }else{
        count = 1;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0;
    if (indexPath.row == 0) {
        height = 250;
    }else{
        height = 140;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        SignInCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SignInCellID"];
        if (cell == nil) {
            [_tb_content registerNib:[UINib nibWithNibName:@"SignInCell" bundle:nil] forCellReuseIdentifier:@"SignInCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"SignInCellID"];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (_isUptime) {
            cell.currentDate = _curretnTime;
            self.isUptime = NO;
        }
        
        cell.workstate = [UserModel getUserModel].workstate;
        
        [cell setDelegate:(id<SignInCellDelegate>)self];
        
        return cell;
        
    }else{
        
        SignListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SignListCellID"];
        if (cell == nil) {
            [_tb_content registerNib:[UINib nibWithNibName:@"SignListCell" bundle:nil] forCellReuseIdentifier:@"SignListCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"SignListCellID"];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.signModel = _arr_content[indexPath.row-1];
        
        
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

#pragma mark - delegate 

- (void)handleBtnSignInOrOut{
    
    WS(weakSelf);
    
    if ([UserModel getUserModel].workstate == YES ) {
        SW(strongSelf, weakSelf);
        SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"是否下班签退"
                                                    leftActionTitle:@"否"
                                                   rightActionTitle:@"是"
                                                     animationStyle:AlertViewAnimationNone
                                                       selectAction:^(AlertViewActionType actionType) {
                                                           if(actionType == AlertViewActionTypeRight) {
                                                               
                                                               strongSelf.hud = [LRShowHUD showWhiteLoadingWithText:@"签退中" inView:nil config:nil];
                                                               [[LocationHelper sharedDefault] startLocation];
                                                               
                                                           }
                                                       }];
        alertView.blurCurrentBackgroundView = NO;
        [alertView show];


    }else{
       self.hud = [LRShowHUD showWhiteLoadingWithText:@"签到中" inView:nil config:nil];
       [[LocationHelper sharedDefault] startLocation];
        
    }
    
}

#pragma mark - notication

- (void)locationChange{

    WS(weakSelf);
    if ([UserModel getUserModel].workstate == YES ) {
        SignOutManger *manger = [[SignOutManger alloc] init];
        manger.address = [LocationHelper sharedDefault].address;
        manger.longitude = @([LocationHelper sharedDefault].longitude);
        manger.latitude  = @([LocationHelper sharedDefault].latitude);
        
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf, weakSelf);
            [strongSelf.hud hide];
            [LRShowHUD showSuccess:@"签退成功" duration:1.5f];
            UserModel *userModel = [UserModel getUserModel];
            userModel.workstate = !userModel.workstate;
            [UserModel setUserModel:userModel];
            [[StepNumberHelper sharedDefault] stopCountStep];
            [[WebSocketHelper sharedDefault] judgeNeedSeedLocation];
            [strongSelf loadSignListRequest];
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf, weakSelf);
            [strongSelf.hud hide];
            [LRShowHUD showSuccess:@"签退失败" duration:1.5f];

        }];
        
        
    }else{
        
        SignManger *manger = [[SignManger alloc] init];
        manger.address = [LocationHelper sharedDefault].address;
        manger.longitude = @([LocationHelper sharedDefault].longitude);
        manger.latitude  = @([LocationHelper sharedDefault].latitude);
        
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf, weakSelf);
            [strongSelf.hud hide];
            [LRShowHUD showSuccess:@"签到成功" duration:1.5f];
            
            UserModel *userModel = [UserModel getUserModel];
            userModel.workstate = !userModel.workstate;
            [UserModel setUserModel:userModel];
            
            BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:[ShareValue sharedDefault].upStepTime];
            
            if (!isToday) {
                [ShareValue sharedDefault].upStepTime = [NSDate dateWithTimeIntervalSinceNow:0];
            }
            
            [[StepNumberHelper sharedDefault] startCountStep:[ShareValue sharedDefault].upStepTime];
            [[WebSocketHelper sharedDefault] judgeNeedSeedLocation];
            [strongSelf loadSignListRequest];
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            SW(strongSelf, weakSelf);
            [strongSelf.hud hide];
            [LRShowHUD showSuccess:@"签到失败" duration:1.5f];
        }];
        
        
    }
    

}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    LxPrintf(@"SignInVC dealloc");

}

@end
