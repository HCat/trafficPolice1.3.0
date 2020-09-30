//
//  ExpressRegulationDetailVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/30.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ExpressRegulationDetailVC.h"

@interface ExpressRegulationDetailVC ()

@property(nonatomic,strong) ExpressRegulationDetailViewModel * viewModel;


@property (weak, nonatomic) IBOutlet UILabel *lb_name;

@property (weak, nonatomic) IBOutlet UILabel *lb_idNO;

@property (weak, nonatomic) IBOutlet UILabel *lb_phone;

@property (weak, nonatomic) IBOutlet UILabel *lb_carNumber;

@property (weak, nonatomic) IBOutlet UILabel *lb_dongNumber;

@property (weak, nonatomic) IBOutlet UILabel *lb_gongsi;

@property (weak, nonatomic) IBOutlet UILabel *lb_quyu;

@property (weak, nonatomic) IBOutlet UILabel *lb_quyufuzheren;

@property (weak, nonatomic) IBOutlet UILabel *lb_quyuphone;

@end

@implementation ExpressRegulationDetailVC

- (instancetype)initWithViewModel:(ExpressRegulationDetailViewModel *)viewModel{
    
    if (self = [super init]) {
        
        self.viewModel = viewModel;
    
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)lr_bindViewModel{
    
    @weakify(self);
    
    self.title = @"详情";
    
    [self.viewModel.detail_command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x isKindOfClass:[ExpressRegulationDetailReponse class]]) {
            [LRShowHUD showSuccess:@"加载成功" duration:1.f];
            ExpressRegulationDetailReponse * t_x = (ExpressRegulationDetailReponse *)x;
            self.lb_name.text = [ShareFun takeStringNoNull:t_x.name];
            self.lb_idNO.text = [ShareFun takeStringNoNull:t_x.licenseNo];
            self.lb_phone.text = [ShareFun takeStringNoNull:t_x.telephone];
            self.lb_carNumber.text = [ShareFun takeStringNoNull:t_x.frameNo];
            self.lb_dongNumber.text = [ShareFun takeStringNoNull:t_x.powerNo];
            self.lb_gongsi.text = [ShareFun takeStringNoNull:t_x.companyName];
            self.lb_quyu.text = [ShareFun takeStringNoNull:t_x.address];
            self.lb_quyufuzheren.text = [ShareFun takeStringNoNull:t_x.chargePerson];
            self.lb_quyuphone.text = [ShareFun takeStringNoNull:t_x.chargePhone];

        }
        
        
    }];
    
    
    [self.viewModel.detail_command execute:nil];
    
    
}


- (IBAction)handleBtnphoneClicked:(id)sender {
    
    if (self.lb_quyuphone.text.length > 0) {
        NSMutableString *str= [[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.lb_quyuphone.text];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    }
    
}




@end
