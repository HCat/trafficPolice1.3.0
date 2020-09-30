//
//  VehicleCarMoreVC.m
//  移动采集
//
//  Created by hcat on 2018/5/14.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleCarMoreVC.h"
#import "LRPageMenu.h"
#import "VehicleAlarmInfoVC.h"
#import "VehicleCarInfoVC.h"
#import "VehicleUpInfoVC.h"
#import "VehicleTrafficInfoVC.h"

#import "VehicleAPI.h"
#import "SearchImportCarVC.h"
#import "SRAlertView.h"

#import "VehicleUpVC.h"
#import "AlertView.h"

@interface VehicleCarMoreVC ()


@property (nonatomic,copy) NSString * carNumber;

@property (nonatomic,strong) LRPageMenu *pageMenu;
@property (weak, nonatomic) IBOutlet UIButton *btn_up;



@end

@implementation VehicleCarMoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.carNumber = _reponse.vehicle.plateno;
    
    if ([_reponse.isBindGps isEqualToNumber:@0]) {
        self.lineType = LineTypeUnBind;
    }else{
        if ([_reponse.isOnline isEqualToNumber:@1]) {
            self.lineType = LineTypeOnLine;
        }else{
            self.lineType = LineTypeUnLine;
        }
    }
    
    NSString *t_lineType = nil;
    UIColor *t_colorType = nil;
    if (_lineType == LineTypeOnLine) {
        t_lineType = @"在线";
        t_colorType = UIColorFromRGB(0x58fb8d);
    }else if (_lineType == LineTypeUnLine){
        t_lineType = @"离线";
        t_colorType = UIColorFromRGB(0xffffff);
    }else if (_lineType == LineTypeUnBind){
        t_lineType = @"未绑定";
        t_colorType = UIColorFromRGB(0xfef85a);
    }

//    UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 150, 40))];
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_carNumber]];
////    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@(%@)",_carNumber,t_lineType]];
////    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xffffff) range:NSMakeRange(0, _carNumber.length)];
////    [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.f] range:NSMakeRange(0, _carNumber.length)];
////    [string addAttribute:NSForegroundColorAttributeName value:t_colorType range:NSMakeRange(_carNumber.length, t_lineType.length+2)];
////    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(_carNumber.length, t_lineType.length+2)];
//    label.attributedText = string;
//    self.navigationItem.titleView = label;
    self.title = _carNumber;
    
    @weakify(self);
    [self zx_setRightBtnWithImgName:@"btn_nav_carCenter" clickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
        @strongify(self);
        [self showCarCenter];
    }];
    
//    [self showRightBarButtonItemWithImage:@"btn_nav_carCenter" target:self action:@selector(showCarCenter)];

    
    
    
    [self initPageMenu];
    
    
    [self.view bringSubviewToFront:_btn_up];
}


+ (void)loadVehicleRequest:(VehicleRequestType)type withNumber:(NSString *)numberId withBlock:(void(^)(VehicleDetailReponse * vehicleDetailReponse))block{
    
    if (type == VehicleRequestTypeQRCode) {
        
        VehicleDetailByQrCodeManger *manger = [[VehicleDetailByQrCodeManger alloc] init];
        manger.qrCode = numberId;
        [manger configLoadingTitle:@"请求"];
        
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
            if (manger.responseModel.code == CODE_SUCCESS) {
                block(manger.vehicleDetailReponse);
                return ;
            }
            
            [LRShowHUD showError:manger.responseModel.msg duration:1.5f];
           
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {

        }];
        
    }else{
        
        VehicleDetailByPlateNoManger *manger = [[VehicleDetailByPlateNoManger alloc] init];
        manger.plateNo = numberId;
        [manger configLoadingTitle:@"请求"];
        
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (manger.responseModel.code == CODE_SUCCESS) {
                block(manger.vehicleDetailReponse);
                return ;
            }
            
            [LRShowHUD showError:manger.responseModel.msg duration:1.5f];
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
           
        }];
        
    }
    
}



#pragma mark - buttonAction

- (IBAction)btnActionUpClicked:(id)sender {
    
    WS(weakSelf);
    
    if (_reponse.driverList.count > 1) {
        [AlertView showWindowWithDriverChooseViewWith:_reponse.driverList complete:^(VehicleDriverModel *driverModel) {
            SW(strongSelf, weakSelf);
            VehicleCarlUpParam *param = [[VehicleCarlUpParam alloc] init];
            param.plateNo = strongSelf.reponse.vehicle.plateno;
            
            if (driverModel) {
                param.driver = driverModel.driverName;
                param.idCardNum = driverModel.driverCode;
            }
            VehicleUpVC *t_vc = [[VehicleUpVC alloc] init];
            t_vc.param = param;
            [strongSelf.navigationController pushViewController:t_vc animated:YES];
            
            
        }];
        
    }else{
        
        VehicleCarlUpParam *param = [[VehicleCarlUpParam alloc] init];
        param.plateNo = _reponse.vehicle.plateno;
        
        if (_reponse.driverList && _reponse.driverList.count > 0) {
            VehicleDriverModel *driverModel = _reponse.driverList[0];
            if (driverModel) {
                param.driver = driverModel.driverName;
                param.idCardNum = driverModel.driverCode;
            }
          
        }
        
        VehicleUpVC *t_vc = [[VehicleUpVC alloc] init];
        t_vc.param = param;
        [self.navigationController pushViewController:t_vc animated:YES];
        
       
    }
    

}

#pragma mark - initPageMenu

- (void)initPageMenu{
    
    NSMutableArray *t_arr = [NSMutableArray array];
    
    VehicleCarInfoVC *carInfo = [[VehicleCarInfoVC alloc] init];
    carInfo.reponse = _reponse;
    carInfo.type = _type;
    carInfo.nummberId = _numberId;
    carInfo.title = @"相关信息";
    [t_arr addObject:carInfo];
    
    VehicleTrafficInfoVC *trafficInfo = [[VehicleTrafficInfoVC alloc] init];
    trafficInfo.vehicleId = _reponse.vehicle.vehicleid;
    trafficInfo.title = @"通行信息";
    [t_arr addObject:trafficInfo];
    
    VehicleUpInfoVC * upInfo = [[VehicleUpInfoVC alloc] init];
    upInfo.vehicleId = _reponse.vehicle.vehicleid;
    upInfo.plateNo = _reponse.vehicle.plateno;
    upInfo.title = @"上报记录";
    [t_arr addObject:upInfo];
    
    VehicleAlarmInfoVC *alarmInfo = [[VehicleAlarmInfoVC alloc] init];
    alarmInfo.vehicleId = _reponse.vehicle.vehicleid;
    alarmInfo.plateNo = _reponse.vehicle.plateno;
    alarmInfo.title = @"报警记录";
    
    [t_arr addObject:alarmInfo];
    
    
    NSArray *arr_controllers = [NSArray arrayWithArray:t_arr];
    NSDictionary *dic_options = @{LRPageMenuOptionUseMenuLikeSegmentedControl:@(YES),
                                  LRPageMenuOptionSelectedTitleColor:DefaultMenuSelectedColor,
                                  LRPageMenuOptionUnselectedTitleColor:DefaultMenuUnSelectedColor,
                                  LRPageMenuOptionSelectionIndicatorColor:DefaultMenuSelectedColor,
                                  LRPageMenuOptionScrollMenuBackgroundColor:[UIColor whiteColor],
                                  LRPageMenuOptionSelectionIndicatorWidth:@(80),
                                  LRPageMenuOptionBottomMenuHairlineColor:[UIColor clearColor],
                                  LRPageMenuOptionSelectedTitleFont:[UIFont systemFontOfSize:15.f],
                                  LRPageMenuOptionUnselectedTitleFont:[UIFont systemFontOfSize:14.f],
                                  
                                  };
    _pageMenu = [[LRPageMenu alloc] initWithViewControllers:arr_controllers frame:CGRectMake(0.0, Height_NavBar, ScreenWidth, self.view.frame.size.height-Height_NavBar) options:dic_options];
    
    [self.view addSubview:_pageMenu.view];
    
}


#pragma mark - 显示车辆位置

- (void)showCarCenter{
    
    WS(weakSelf);
    VehicleLocationByPlateNoManger *manger = [[VehicleLocationByPlateNoManger alloc] init];
    manger.plateNo = _carNumber;
    manger.isNeedLoadHud = YES;
    manger.loadingMessage =  @"搜索中..";
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        
        if(manger.vehicleGPSModel){
            
            SearchImportCarVC *t_vc = [[SearchImportCarVC alloc] init];
            t_vc.search_vehicleModel = manger.vehicleGPSModel;
            [strongSelf.navigationController pushViewController:t_vc animated:YES];
            
        }else{
            
            [strongSelf showAlertViewWithcontent:@"未找到车辆相关位置" leftTitle:nil rightTitle:@"确定" block:^(AlertViewActionType actionType) {
                
            }];
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        
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

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"VehicleCarMoreVC dealloc");
    
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
