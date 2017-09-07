//
//  VehicleCarCell.m
//  移动采集
//
//  Created by hcat on 2017/9/7.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "VehicleCarCell.h"

@interface VehicleCarCell()

@property (nonatomic,weak) IBOutlet UILabel * lb_plateno;                    //车牌号
@property (nonatomic,weak) IBOutlet UILabel * lb_carType;                    //车辆类型:1土方车 2水泥砼车 3砂石子车
@property (nonatomic,weak) IBOutlet UILabel * lb_inspectTimeEnd;             //年审截止日期
@property (nonatomic,weak) IBOutlet UILabel * lb_compInsuranceTimeEnd;       //强制险截止日期
@property (nonatomic,weak) IBOutlet UILabel * lb_bussInsuranceTimeEnd;       //商业险截止日期
@property (nonatomic,weak) IBOutlet UILabel * lb_factoryno;                  //车架号码
@property (nonatomic,weak) IBOutlet UILabel * lb_motorid;                    //发动机号码
@property (nonatomic,weak) IBOutlet UILabel * lb_description;                //车辆描述
@property (nonatomic,weak) IBOutlet UILabel * lb_driver;                     //车主姓名
@property (nonatomic,weak) IBOutlet UILabel * lb_dvrcard;                    //车主身份证
@property (nonatomic,weak) IBOutlet UILabel * lb_drivermobile;               //车主电话
@property (nonatomic,weak) IBOutlet UILabel * lb_carHopper;                  //车斗信息
@property (nonatomic,weak) IBOutlet UILabel * lb_status;                     //车辆状态
@property (nonatomic,weak) IBOutlet UILabel * lb_remark;                     //备注
@property (nonatomic,weak) IBOutlet UILabel * lb_vehicleImgList;             //证件照片
@end

@implementation VehicleCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setVehicle:(VehicleModel *)vehicle{

    _vehicle = vehicle;
    
    if (_vehicle) {
        
        _lb_plateno.text = _vehicle.plateno;  //车牌号
        
        //车辆类型:1土方车 2水泥砼车 3砂石子车
        if ([_vehicle.carType isEqualToNumber:@1]) {
            _lb_carType.text = @"土方车";
        }else if ([_vehicle.carType isEqualToNumber:@2]){
            _lb_carType.text = @"水泥砼车";
        }else{
            _lb_carType.text = @"砂石子车";
        }
        
        _lb_inspectTimeEnd.text = [ShareFun timeWithTimeInterval:_vehicle.inspectTimeEnd dateFormat:@"yyyy年MM月dd日"];             //年审截止日期
        _lb_compInsuranceTimeEnd.text = [ShareFun timeWithTimeInterval:_vehicle.compInsuranceTimeEnd dateFormat:@"yyyy年MM月dd日"]; //强制险截止日期
        _lb_bussInsuranceTimeEnd.text = [ShareFun timeWithTimeInterval:_vehicle.bussInsuranceTimeEnd dateFormat:@"yyyy年MM月dd日"]; //商业险截止日期
        _lb_factoryno.text = _vehicle.factoryno;            //车架号码
        _lb_motorid.text = _vehicle.motorid;                //发动机号码
        _lb_description.text = _vehicle.description_text;   //车辆描述
        _lb_driver.text = _vehicle.driver;                  //车主姓名
        _lb_dvrcard.text = _vehicle.dvrcard;                //车主身份证
        _lb_drivermobile.text = _vehicle.drivermobile;      //车主电话
        
        //车斗信息
        _lb_carHopper.text = [NSString stringWithFormat:@"%@x%@x%@(单位cm)",_vehicle.carHopperL,_vehicle.carHopperW,_vehicle.carHopperH];
        
        //车辆状态：1正常 0暂停运营 2停止运营 3未审核 4未提交 5审核未通过
        if ([_vehicle.status isEqualToNumber:@0]) {
            _lb_status.text = @"暂停运营";
        }else if ([_vehicle.status isEqualToNumber:@1]){
            _lb_status.text = @"正常";
        }else if ([_vehicle.status isEqualToNumber:@2]){
            _lb_status.text = @"停止运营";
        }else if ([_vehicle.status isEqualToNumber:@3]){
            _lb_status.text = @"未审核";
        }else if ([_vehicle.status isEqualToNumber:@4]){
            _lb_status.text = @"未提交";
        }else{
            _lb_status.text = @"审核未通过";
        }

        _lb_remark.text = _vehicle.remark;                  //备注
        
        
    }

    



}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{

    LxPrintf(@"VehicleCarCell dealloc");

}

@end
