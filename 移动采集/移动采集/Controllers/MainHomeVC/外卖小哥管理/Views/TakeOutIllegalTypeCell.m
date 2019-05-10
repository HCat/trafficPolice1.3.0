//
//  TakeOutIllegalTypeCell.m
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutIllegalTypeCell.h"

@interface TakeOutIllegalTypeCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_tip;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;


@end

@implementation TakeOutIllegalTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(DeliveryIllegalTypeModel * _Nullable x) {
        @strongify(self);
        if (x) {
            
            if (x.isSelected) {
                [self.imageV_tip setImage:[UIImage imageNamed:@"btn_takeout_h"]];
            }else{
                [self.imageV_tip setImage:[UIImage imageNamed:@"btn_takeout_n"]];
            }
            
            self.lb_title.text = x.illegalName;
            self.lb_content.text = [NSString stringWithFormat:@"-%d",[x.deduction intValue]];
            
        }
    
        self.userInteractionEnabled = YES;
        
    }];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
