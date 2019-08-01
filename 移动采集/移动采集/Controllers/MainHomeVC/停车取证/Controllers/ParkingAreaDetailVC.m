//
//  ParkingAreaDetailVC.m
//  移动采集
//
//  Created by hcat on 2019/7/28.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingAreaDetailVC.h"
#import "SRAlertView.h"
#import "ParkingForensicsVC.h"

@interface ParkingAreaDetailVC ()

@property (weak, nonatomic) IBOutlet UIView *v_top;


@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *stopTime;

@property (weak, nonatomic) IBOutlet UILabel *lb_needMoney;

@property (weak, nonatomic) IBOutlet UILabel *lb_payMoney;

@property (weak, nonatomic) IBOutlet UIButton *btn_forensics;

@property (weak, nonatomic) IBOutlet UIButton *btn_noCar;

@property (nonatomic,strong) ParkingAreaDetailViewModel * viewModel;


@end

@implementation ParkingAreaDetailVC

- (instancetype)initWithViewModel:(ParkingAreaDetailViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.v_top.layer.cornerRadius = 5.f;
    self.btn_forensics.layer.cornerRadius = 3.f;
    self.btn_noCar.layer.cornerRadius = 3.f;
    self.btn_noCar.layer.borderColor = DefaultColor.CGColor;
    self.btn_noCar.layer.borderWidth = 2.f;
    
    self.title = self.viewModel.parkplaceId;

    @weakify(self);
    [self.viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        self.lb_time.text = [ShareFun takeStringNoNull:self.viewModel.areaDetailModel.starttime];
        self.stopTime.text = [ShareFun takeStringNoNull:self.viewModel.areaDetailModel.parkingtimeStr];
        self.lb_needMoney.text = [NSString stringWithFormat:@"￥%@",[ShareFun takeStringNoNull:self.viewModel.areaDetailModel.needpay]];
        self.lb_payMoney.text = [NSString stringWithFormat:@"￥%@",[ShareFun takeStringNoNull:self.viewModel.areaDetailModel.payamount]];
    }];
    
    [self.viewModel.noCarCommand.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
       
    }];
    
    [self.viewModel.requestCommand execute:nil];
    
    
    [[self.btn_forensics rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        ParkingForensicsViewModel * viewModel = [[ParkingForensicsViewModel alloc] init];
        ParkingForensicsVC * vc = [[ParkingForensicsVC alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    [[self.btn_noCar rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"是否标记为无车?"
                                                    leftActionTitle:@"否"
                                                   rightActionTitle:@"是"
                                                     animationStyle:AlertViewAnimationNone
                                                       selectAction:^(AlertViewActionType actionType) {
                                                           if (actionType == AlertViewActionTypeRight) {
                                                               [self.viewModel.noCarCommand execute:nil];
                                                           }
                                                    
                                                       }];
        alertView.blurCurrentBackgroundView = NO;
        [alertView show];
        
    }];
    
    
}

- (void)dealloc{
    LxPrintf(@"ParkingAreaDetailVC dealloc");
}

@end
