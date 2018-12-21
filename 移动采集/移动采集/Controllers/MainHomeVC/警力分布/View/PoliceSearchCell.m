//
//  PoliceSearchCell.m
//  移动采集
//
//  Created by hcat on 2018/12/21.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "PoliceSearchCell.h"

@interface PoliceSearchCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIImageView *image_type;


@end

@implementation PoliceSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    [RACObserve(self, viewModel) subscribeNext:^(id  _Nullable x) {
        self.lb_title.text = self.viewModel.title;
        if ([self.viewModel.type isEqualToNumber:@1]) {
            [self.image_type setImage:[UIImage imageNamed:@"icon_policeList_police"]];
        }else{
            [self.image_type setImage:[UIImage imageNamed:@"icon_policeLocation_blue"]];
        }
    
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
