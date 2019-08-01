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
        
        switch ([x.parkingstatus intValue]) {
            case 0:
                
                self.lb_status.text = @"空闲";
                self.lb_status.textColor = UIColorFromRGB(0x333333);
                self.lb_status.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
                
                break;
                
            case 1:
                self.lb_status.text = @"正常";
                self.lb_status.textColor = UIColorFromRGB(0x44C93D);
                self.lb_status.layer.borderColor = UIColorFromRGB(0x44C93D).CGColor;
                break;
                
            case 2:
                self.lb_status.text = @"未登记";
                self.lb_status.textColor = UIColorFromRGB(0xFAAD34);
                self.lb_status.layer.borderColor = UIColorFromRGB(0xFAAD34).CGColor;
                break;
                
            case 3:
                self.lb_status.text = @"欠费";
                self.lb_status.textColor = UIColorFromRGB(0xFD3240);
                self.lb_status.layer.borderColor = UIColorFromRGB(0xFD3240).CGColor;
                break;
                
            default:
                break;
        }
        
        
        
        
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
