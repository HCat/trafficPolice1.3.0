//
//  TakeOutIllegalTypeTopCell.m
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutIllegalTypeTopCell.h"

@interface TakeOutIllegalTypeTopCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@end

@implementation TakeOutIllegalTypeTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(DeliveryIllegalTypeModel * _Nullable x) {
        @strongify(self);
        if (x) {
            self.lb_title.text = x.illegalName;
        }
        
        self.userInteractionEnabled = NO;
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
