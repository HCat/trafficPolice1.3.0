//
//  TakeOutIllegalCell.m
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutIllegalCell.h"

@interface TakeOutIllegalCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UILabel *lb_content;


@end

@implementation TakeOutIllegalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(DeliveryIllegalModel *  _Nullable x) {
        @strongify(self);
        if (x) {
            self.lb_title.text = x.illegalName;
            self.lb_content.text = [NSString stringWithFormat:@"-%d",[x.deduction intValue]];
        }
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
