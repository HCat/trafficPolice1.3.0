//
//  ParkingManageListCell.m
//  移动采集
//
//  Created by hcat on 2019/9/17.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingManageListCell.h"

@interface ParkingManageListCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_status;

@property (weak, nonatomic) IBOutlet UILabel *lb_carNumber;
@property (weak, nonatomic) IBOutlet UILabel *lb_forceNumber;

@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;


@end

@implementation ParkingManageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
    
    [RACObserve(self, model) subscribeNext:^(ParkingManageListModel *  _Nullable x) {
       
        @strongify(self);
        
        if ([x.status intValue] == 0) {
            self.lb_status.text = @"已入库";
            self.lb_status.textColor = DefaultColor;
            
        }else{
            self.lb_status.text = @"已出库";
            self.lb_status.textColor = UIColorFromRGB(0x999999);
        }
        
        self.lb_carNumber.text = [ShareFun takeStringNoNull:x.carNo];
        self.lb_forceNumber.text = [ShareFun takeStringNoNull:x.mandatoryNo];
        
        self.lb_address.text = [ShareFun takeStringNoNull:x.yardName];
        self.lb_time.text = [ShareFun takeStringNoNull:x.detainDateStr];
        
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
