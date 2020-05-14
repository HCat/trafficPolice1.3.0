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
@property (weak, nonatomic) IBOutlet UILabel *lb_statusTime;

@property (weak, nonatomic) IBOutlet UIView *v_noCar;
@property (nonatomic,strong) dispatch_source_t timer;


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
            self.lb_statusTime.text = nil;
        }else if ([self.viewModel.areaDetailModel.status intValue] == 1) {
            self.v_top.hidden = NO;
            self.v_noCar.hidden = YES;
            self.v_status.hidden = YES;
            self.btn_forensics.hidden = NO;
            self.lb_statusTime.text = nil;
        }else if ([self.viewModel.areaDetailModel.status intValue] == 2) {
            self.v_top.hidden = NO;
            self.v_noCar.hidden = YES;
            self.v_status.hidden = NO;
            self.btn_forensics.hidden = YES;
            self.lb_status.text = @"已登记";
            self.lb_statusTime.text = nil;
        }else {
            self.v_top.hidden = NO;
            self.v_noCar.hidden = YES;
            self.v_status.hidden = NO;
            self.btn_forensics.hidden = YES;
            self.lb_status.text = @"取证时间";
            self.lb_statusTime.text = [ShareFun timeWithTimeInterval:self.viewModel.areaDetailModel.evidenceDate];
        }
        
        if ([self.viewModel.areaDetailModel.hasQzAuthority intValue] == 2) {
            
            if ([self.viewModel.areaDetailModel.delaySecond longValue] > 0) {
                @strongify(self);
                __block NSInteger second = [self.viewModel.areaDetailModel.delaySecond integerValue];
                dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
                dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
                dispatch_source_set_event_handler(self.timer, ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        @strongify(self);
                        NSLog(@"%ld",second);
                        if (second == 0) {
                            self.btn_forensics.userInteractionEnabled = YES;
                            [self.btn_forensics setTitle:[NSString stringWithFormat:@"取证"] forState:UIControlStateNormal];
                           
                            [self.btn_forensics setBackgroundColor:DefaultBtnColor];
                            
                            
                            [self.viewModel.requestCommand execute:nil];
                            dispatch_cancel(self.timer);
                        } else {
                            self.btn_forensics.userInteractionEnabled = NO;
                            [self.btn_forensics setTitle:[NSString stringWithFormat:@"%ld分钟后才可以取证", second/60 + 1] forState:UIControlStateNormal];
                            [self.btn_forensics setBackgroundColor:UIColorFromRGB(0xa6a6a6)];
                            second--;
                        }
                    });
                });
                dispatch_resume(self.timer);
                return ;
            }else{
                self.btn_forensics.hidden = YES;
                [LRShowHUD showError:@"网络异常，请稍后再试" duration:1.5];
            }
            
        }
        
    }];
    
    [self.viewModel.requestCommand execute:nil];
    
    
    [[self.btn_forensics rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        if ([self.viewModel.areaDetailModel.hasQzAuthority intValue] == 0) {
            [LRShowHUD showError:@"已派单" duration:1.5];
            return ;
        }
    
        ParkingForensicsViewModel * viewModel = [[ParkingForensicsViewModel alloc] init];
        viewModel.fkParkplaceId = self.viewModel.parkplaceId;
        viewModel.placenum = self.viewModel.placenum;
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
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_PARKINGFORENSICS_SUCCESS object:nil];
}

@end
