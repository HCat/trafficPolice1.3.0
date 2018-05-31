//
//  VehicleRouteCell.m
//  移动采集
//
//  Created by hcat on 2017/12/14.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "VehicleRouteCell.h"

@interface VehicleRouteCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_jobAddress; //作业地点
@property (weak, nonatomic) IBOutlet UILabel *lb_quantity;  //土方运量
@property (weak, nonatomic) IBOutlet UILabel *lb_jobStartTime;  //开始时间
@property (weak, nonatomic) IBOutlet UILabel *lb_jobEndTime;    //结束时间
@property (weak, nonatomic) IBOutlet UILabel *lb_route;         //行驶路线


@end


@implementation VehicleRouteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRoute:(VehicleRouteModel *)route{
    
    _route = route;
    
    if (_route) {
        
        _lb_jobAddress.text = [ShareFun takeStringNoNull:_route.jobSite];
        _lb_quantity.text = [ShareFun takeStringNoNull:[NSString stringWithFormat:@"%ld方",[_route.quantity integerValue]]];
        
         _lb_jobStartTime.text = [ShareFun takeStringNoNull:[ShareFun timeWithTimeInterval:_route.jobStartTime dateFormat:@"yyyy年MM月dd日"]];
         _lb_jobEndTime.text = [ShareFun takeStringNoNull:[ShareFun timeWithTimeInterval:_route.jobEndTime dateFormat:@"yyyy年MM月dd日"]];
         _lb_route.text = [ShareFun takeStringNoNull:_route.route];
        
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    
    LxPrintf(@"VehicleRouteCell dealloc");
    
}

@end
