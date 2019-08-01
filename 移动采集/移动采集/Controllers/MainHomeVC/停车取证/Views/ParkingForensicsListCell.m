//
//  ParkingForensicsListCell.m
//  移动采集
//
//  Created by hcat on 2019/7/24.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingForensicsListCell.h"

@interface ParkingForensicsListCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_status;
@property (weak, nonatomic) IBOutlet UILabel *lb_number;

@property (weak, nonatomic) IBOutlet UILabel *lb_address;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;


@end

@implementation ParkingForensicsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lb_status.layer.borderColor = DefaultColor.CGColor;
    self.lb_status.layer.borderWidth = 1.f;
    self.lb_status.textColor = DefaultColor;
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(ParkingForensicsModel * _Nullable x) {
        @strongify(self);
        self.lb_time.text = [ShareFun takeStringNoNull:x.dispatchTimeStr];
        self.lb_number.text = [ShareFun takeStringNoNull:x.placenum];
        self.lb_address.text = [ShareFun takeStringNoNull:x.parklotname];
        self.lb_status.text = [ShareFun takeStringNoNull:x.stateName];
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
