//
//  DailyPatrolListCell.m
//  移动采集
//
//  Created by hcat-89 on 2020/1/8.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "DailyPatrolListCell.h"

@interface DailyPatrolListCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_shiftNum;
@property (weak, nonatomic) IBOutlet UILabel *lb_partrolName;

@end


@implementation DailyPatrolListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(DailyPatrolListModel *  _Nullable x) {
       
        @strongify(self);
        
        self.lb_shiftNum.text = [NSString stringWithFormat:@"班次%@",[ShareFun translationArabicNum:[x.shiftNum integerValue]]];
        self.lb_time.text = [NSString stringWithFormat:@"%@:%@-%@:%@",x.startHour,x.startMinute,x.endHour,x.endMinute];
        self.lb_partrolName.text = [ShareFun takeStringNoNull:x.partrolName];
        
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
