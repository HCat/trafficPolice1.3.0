//
//  VehicleUpInfoDetailCell.m
//  移动采集
//
//  Created by hcat on 2018/5/29.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleUpInfoDetailCell.h"
#import "UserModel.h"

@interface VehicleUpInfoDetailCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_upName;
@property (weak, nonatomic) IBOutlet UILabel *lb_upTime;
@property (weak, nonatomic) IBOutlet UILabel *lb_driverName;
@property (weak, nonatomic) IBOutlet UILabel *lb_driverIDNumber;
@property (weak, nonatomic) IBOutlet UILabel *lb_road;
@property (weak, nonatomic) IBOutlet UILabel *lb_position;
@property (weak, nonatomic) IBOutlet UILabel *lb_illegalType;

@end


@implementation VehicleUpInfoDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - set && get

- (void)setModel:(VehicleUpDetailModel *)model{
    
    _model = model;
    
    if (_model) {
        
        _lb_upName.text = [ShareFun takeStringNoNull:_model.creatorName];
        _lb_upTime.text = [ShareFun takeStringNoNull:[ShareFun timeWithTimeInterval:_model.entryDate dateFormat:@"yyyy-MM-dd HH:mm:ss"]];
        _lb_driverName.text = [ShareFun takeStringNoNull:_model.driver];
        _lb_driverIDNumber.text = [ShareFun takeStringNoNull:_model.idCardNum];
        _lb_road.text = [ShareFun takeStringNoNull:_model.road];
        _lb_position.text = [ShareFun takeStringNoNull:_model.position];
        _lb_illegalType.text = [ShareFun takeStringNoNull:[_model.illegalType stringByReplacingOccurrencesOfString:@" ," withString:@"、"]];
    
    }
    
    
    
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - dealloc

- (void)dealloc{
    
    LxPrintf(@"VehicleUpInfoDetailCell dealloc");
}

@end
