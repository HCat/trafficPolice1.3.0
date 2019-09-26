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

@property (weak, nonatomic) IBOutlet UILabel *lb_noPayMoney;

@property (weak, nonatomic) IBOutlet UIButton *btn_forensics;

@property (weak, nonatomic) IBOutlet UIView *v_status;
@property (weak, nonatomic) IBOutlet UILabel *lb_status;

@property (weak, nonatomic) IBOutlet UIView *v_noCar;


@property (nonatomic,strong) ParkingAreaDetailViewModel * viewModel;


@end

@implementation ParkingAreaDetailVC

- (instancetype)initWithViewModel:(ParkingAreaDetailViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parkingForensicsSuccess) name:NOTIFICATION_PARKINGFORENSICS_SUCCESS object:nil];
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.v_top.layer.cornerRadius = 3.f;
    self.v_top.layer.masksToBounds = YES;
    self.btn_forensics.layer.cornerRadius = 3.f;
    self.v_noCar.layer.cornerRadius = 3.f;
    self.v_top.layer.masksToBounds = YES;
    self.v_status.layer.cornerRadius = 3.f;
    self.v_top.layer.masksToBounds = YES;
    
    self.title = self.viewModel.placenum;

    @weakify(self);
    [self.viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        self.lb_time.text = [ShareFun timeWithTimeInterval:self.viewModel.areaDetailModel.startTime];
        
        NSString * t_time = @"";
        if ([self.viewModel.areaDetailModel.dateDiff.day intValue] != 0) {
            t_time = [t_time stringByAppendingString:[NSString stringWithFormat:@"%d天",[self.viewModel.areaDetailModel.dateDiff.day intValue]]];
        }
        
        if ([self.viewModel.areaDetailModel.dateDiff.hour intValue] != 0) {
             t_time = [t_time stringByAppendingString:[NSString stringWithFormat:@"%d小时",[self.viewModel.areaDetailModel.dateDiff.hour intValue]]];
        }
        
        if ([self.viewModel.areaDetailModel.dateDiff.minute intValue] != 0) {
             t_time = [t_time stringByAppendingString:[NSString stringWithFormat:@"%d分钟",[self.viewModel.areaDetailModel.dateDiff.minute intValue]]];
        }
        
        if ([self.viewModel.areaDetailModel.dateDiff.seconde intValue] != 0) {
             t_time = [t_time stringByAppendingString:[NSString stringWithFormat:@"%d秒",[self.viewModel.areaDetailModel.dateDiff.seconde intValue]]];
        }
        
        self.stopTime.text = [ShareFun takeStringNoNull:t_time];
        self.lb_needMoney.text = [NSString stringWithFormat:@"￥%.2f元",[self.viewModel.areaDetailModel.payAmount floatValue]];
        self.lb_payMoney.text = [NSString stringWithFormat:@"￥%.2f元",[self.viewModel.areaDetailModel.payedAmount floatValue]];
        self.lb_noPayMoney.text = [NSString stringWithFormat:@"￥%.2f元",[self.viewModel.areaDetailModel.waitPayAmount floatValue]];
        //泊位状态:0 空闲；1 有车未登记；2 有车已登记；3 有车已取证；"
        if ([self.viewModel.areaDetailModel.status intValue] == 0) {
            self.v_top.hidden = YES;
            self.v_noCar.hidden = NO;
            self.v_status.hidden = YES;
            self.btn_forensics.hidden = YES;
        }else if ([self.viewModel.areaDetailModel.status intValue] == 1) {
            self.v_top.hidden = NO;
            self.v_noCar.hidden = YES;
            self.v_status.hidden = YES;
            self.btn_forensics.hidden = NO;
        }else if ([self.viewModel.areaDetailModel.status intValue] == 2) {
            self.v_top.hidden = NO;
            self.v_noCar.hidden = YES;
            self.v_status.hidden = NO;
            self.btn_forensics.hidden = YES;
            self.lb_status.text = @"已登记";
        }else {
            self.v_top.hidden = NO;
            self.v_noCar.hidden = YES;
            self.v_status.hidden = NO;
            self.btn_forensics.hidden = YES;
            self.lb_status.text = @"已取证";
        }
        
    }];
    
    [self.viewModel.requestCommand execute:nil];
    
    
    [[self.btn_forensics rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        ParkingForensicsViewModel * viewModel = [[ParkingForensicsViewModel alloc] init];
        viewModel.fkParkplaceId = self.viewModel.parkplaceId;
        ParkingForensicsVC * vc = [[ParkingForensicsVC alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    
}

#pragma mark - notification

- (void)parkingForensicsSuccess{
    
    [self.viewModel.requestCommand execute:nil];
    
}

- (void)dealloc{
    LxPrintf(@"ParkingAreaDetailVC dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_PARKINGFORENSICS_SUCCESS object:nil];
}

@end
