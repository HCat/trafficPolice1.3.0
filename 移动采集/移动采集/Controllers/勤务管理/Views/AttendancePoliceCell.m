//
//  AttendancePoliceCell.m
//  移动采集
//
//  Created by hcat on 2019/4/3.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "AttendancePoliceCell.h"

@interface AttendancePoliceCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_name;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;



@end


@implementation AttendancePoliceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.lb_name.text = [ShareFun takeStringNoNull:self.viewModel.realName];
        self.lb_time.text = [ShareFun takeStringNoNull:self.viewModel.workTimeStr];
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
