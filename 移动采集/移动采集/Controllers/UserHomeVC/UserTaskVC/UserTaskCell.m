//
//  UserTaskCell.m
//  移动采集
//
//  Created by hcat on 2017/11/3.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "UserTaskCell.h"

@interface UserTaskCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UIView *v_taskCancel;

@end


@implementation UserTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCurrentTask:(TaskModel *)currentTask{
    _currentTask = currentTask;
    
    if (_currentTask) {
        
        if ([_currentTask.taskStatus isEqualToNumber:@3]) {
            _v_taskCancel.hidden = NO;
        }else{
            _v_taskCancel.hidden = YES;
            _lb_address.text = _currentTask.address;
            _lb_name.text = _currentTask.taskName;
            _lb_time.text = [ShareFun timeWithTimeInterval:_currentTask.arrivalTime];
            
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
