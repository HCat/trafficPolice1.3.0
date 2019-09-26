//
//  ParkingAreaCell.m
//  移动采集
//
//  Created by hcat on 2019/7/26.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingAreaCell.h"

@interface ParkingAreaCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_number;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;

@property (weak, nonatomic) IBOutlet UILabel *lb_status;

@end



@implementation ParkingAreaCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.lb_status.layer.cornerRadius = 3.f;
    self.lb_status.layer.borderWidth = 1.f;
    
    @weakify(self);
    
    [RACObserve(self, model) subscribeNext:^(ParkingOccPercentModel *  _Nullable x) {
        @strongify(self);
        
        self.lb_number.text = [ShareFun takeStringNoNull:x.placenum];
        self.lb_address.text = [ShareFun takeStringNoNull:x.parklotname];
        
        if ([x.status isEqualToNumber:@0]) {
            self.lb_status.text = @"空闲";
            self.lb_status.textColor = UIColorFromRGB(0xBFBFBF);
            self.lb_status.layer.borderColor = UIColorFromRGB(0xBFBFBF).CGColor;
        }else if ([x.status isEqualToNumber:@1]) {
            self.lb_status.text = @"未登记";
            self.lb_status.textColor = UIColorFromRGB(0xff1e1e);
            self.lb_status.layer.borderColor = UIColorFromRGB(0xff1e1e).CGColor;
        }else if ([x.status isEqualToNumber:@2]) {
            self.lb_status.text = @"已登记";
            self.lb_status.textColor = UIColorFromRGB(0x5DCB58);
            self.lb_status.layer.borderColor = UIColorFromRGB(0x5DCB58).CGColor;
        }else{
            self.lb_status.text = @"已取证";
            self.lb_status.textColor = UIColorFromRGB(0x3396FC);
            self.lb_status.layer.borderColor = UIColorFromRGB(0x3396FC).CGColor;
        }

        
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
