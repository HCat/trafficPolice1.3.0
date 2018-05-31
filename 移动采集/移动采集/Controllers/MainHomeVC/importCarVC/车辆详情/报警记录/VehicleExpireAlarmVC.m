//
//  VehicleExpireAlarmVC.m
//  移动采集
//
//  Created by hcat on 2018/5/24.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleExpireAlarmVC.h"

@interface VehicleExpireAlarmVC ()

@property (weak, nonatomic) IBOutlet UILabel *lb_inspectTimeEndDate;

@property (weak, nonatomic) IBOutlet UILabel *lb_compInsuranceTimeEndDate;

@property (weak, nonatomic) IBOutlet UILabel *lb_bussInsuranceTimeEndDate;

@property (weak, nonatomic) IBOutlet UILabel *lb_affiliatdTimeEndDate;

@property (weak, nonatomic) IBOutlet UILabel *lb_ins_info;
@property (weak, nonatomic) IBOutlet UILabel *lb_com_info;
@property (weak, nonatomic) IBOutlet UILabel *lb_bus_info;
@property (weak, nonatomic) IBOutlet UILabel *lb_aff_info;
@end

@implementation VehicleExpireAlarmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"车辆到期";
    _lb_ins_info.layer.borderColor = UIColorFromRGB(0x4281E8).CGColor;
    _lb_ins_info.layer.borderWidth = 1.f;
    _lb_com_info.layer.borderColor = UIColorFromRGB(0x4281E8).CGColor;
    _lb_com_info.layer.borderWidth = 1.f;
    _lb_bus_info.layer.borderColor = UIColorFromRGB(0x4281E8).CGColor;
    _lb_bus_info.layer.borderWidth = 1.f;
    _lb_aff_info.layer.borderColor = UIColorFromRGB(0x4281E8).CGColor;
    _lb_aff_info.layer.borderWidth = 1.f;
    
    
    if (_model) {
        
        if ([_model.inspectTimeEnd isEqualToNumber:@1]) {
            _lb_ins_info.hidden = NO;
        }else{
            _lb_ins_info.hidden = YES;
        }
        
        if ([_model.compInsuranceTimeEnd isEqualToNumber:@1]) {
            _lb_com_info.hidden = NO;
        }else{
            _lb_com_info.hidden = YES;
        }
        
        if ([_model.bussInsuranceTimeEnd isEqualToNumber:@1]) {
            _lb_bus_info.hidden = NO;
        }else{
            _lb_bus_info.hidden = YES;
        }
        
        if ([_model.affiliatdTimeEnd isEqualToNumber:@1]) {
            _lb_aff_info.hidden = NO;
        }else{
            _lb_aff_info.hidden = YES;
        }
        
        _lb_inspectTimeEndDate.text = [ShareFun timeWithTimeInterval:_model.inspectTimeEndDate dateFormat:@"yyyy-MM-dd"];
        _lb_compInsuranceTimeEndDate.text = [ShareFun timeWithTimeInterval:_model.compInsuranceTimeEndDate dateFormat:@"yyyy-MM-dd"];
        _lb_bussInsuranceTimeEndDate.text = [ShareFun timeWithTimeInterval:_model.bussInsuranceTimeEndDate dateFormat:@"yyyy-MM-dd"];
        _lb_affiliatdTimeEndDate.text = _model.affiliatdTimeEndDate;
        
    }

}





#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"VehicleExpireAlarmVC dealloc");
    
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
