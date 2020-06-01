//
//  IllegalRoadCell.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/5/29.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "IllegalRoadCell.h"

@interface IllegalRoadCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UIImageView *image_seleced;

@end


@implementation IllegalRoadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
    
    [RACObserve(self, model) subscribeNext:^(CommonGetRoadModel * _Nullable x) {
        
        @strongify(self);
        
        self.lb_address.text = x.getRoadName;
        
        if (x.isSelected) {
            self.lb_address.textColor = UIColorFromRGB(0x47A0FC);
            [self.image_seleced setHidden:NO];
        }else{
            self.lb_address.textColor = UIColorFromRGB(0x333333);
            [self.image_seleced setHidden:YES];
        }
    
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
