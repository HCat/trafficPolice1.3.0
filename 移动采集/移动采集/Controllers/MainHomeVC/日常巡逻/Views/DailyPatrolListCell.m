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
@property (weak, nonatomic) IBOutlet UILabel *lb_type;




@end


@implementation DailyPatrolListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lb_type.layer.cornerRadius = 5.f;
    self.lb_type.layer.masksToBounds = YES;
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(DailyPatrolListModel *  _Nullable x) {
       
        @strongify(self);
        
        self.lb_shiftNum.text = [NSString stringWithFormat:@"班次%@",[ShareFun translationArabicNum:[x.shiftNum integerValue]]];
        
        self.lb_time.text = [NSString stringWithFormat:@"%02d:%02d-%02d:%02d",[x.startHour intValue],[x.startMinute intValue],[x.endHour intValue],[x.endMinute intValue]];
        self.lb_partrolName.text = [ShareFun takeStringNoNull:x.partrolName];
        
        if ([x.type isEqualToNumber:@1]) {
            self.lb_type.backgroundColor = UIColorFromRGB(0x44C07E);
            self.lb_type.text = @"站勤岗";
        }else{
            self.lb_type.backgroundColor = UIColorFromRGB(0x3396FC);
            self.lb_type.text = @"巡逻岗";
        }
        
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
