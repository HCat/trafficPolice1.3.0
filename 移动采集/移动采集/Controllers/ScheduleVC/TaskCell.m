//
//  TaskCell.m
//  移动采集
//
//  Created by hcat on 2018/6/15.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "TaskCell.h"

@interface TaskCell()
@property (weak, nonatomic) IBOutlet UILabel *lb_statusBg;

@property (weak, nonatomic) IBOutlet UILabel *lb_status;

@property (weak, nonatomic) IBOutlet UILabel *lb_taskName;
@property (weak, nonatomic) IBOutlet UILabel *lb_taskAddress;
@property (weak, nonatomic) IBOutlet UILabel *lb_taskTime;


@end

@implementation TaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lb_statusBg.layer.cornerRadius = 2.f;
    _lb_statusBg.layer.masksToBounds = YES;
    // Initialization code
}


- (void)setCurrentTask:(TaskModel *)currentTask{
    _currentTask = currentTask;
    
    if (_currentTask) {
        
        _lb_taskAddress.text = [ShareFun takeStringNoNull:_currentTask.address];
        _lb_taskName.text = [ShareFun takeStringNoNull:_currentTask.taskName];
        _lb_taskTime.text = [NSString stringWithFormat:@"行动时间：%@",[ShareFun timeWithTimeInterval:_currentTask.arrivalTime]];
        
        if ([_currentTask.taskStatus isEqualToNumber:@0]) {
            
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = CGRectMake(0, 0, 50, 20);
            gradientLayer.colors = @[(id)UIColorFromRGB(0x6BB3FD).CGColor,(id)UIColorFromRGB(0x3396FC).CGColor];
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1, 0);
            [_lb_statusBg.layer addSublayer:gradientLayer];
           
    
            _lb_status.text = @"未开始";
            
        }else if ([_currentTask.taskStatus isEqualToNumber:@1]) {
            
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = CGRectMake(0, 0, 50, 20);
            gradientLayer.colors = @[(id)UIColorFromRGB(0x9BDC7E).CGColor,(id)UIColorFromRGB(0x7ACC56).CGColor];
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1, 0);
            [_lb_statusBg.layer addSublayer:gradientLayer];
            _lb_status.text = @"进行中";
            
        }else if ([_currentTask.taskStatus isEqualToNumber:@2]) {
            
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = CGRectMake(0, 0, 50, 20);
            gradientLayer.colors = @[(id)UIColorFromRGB(0xFDB28E).CGColor,(id)UIColorFromRGB(0xFE9460).CGColor];
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1, 0);
            [_lb_statusBg.layer addSublayer:gradientLayer];
            _lb_status.text = @"已完成";
            
        }else if ([_currentTask.taskStatus isEqualToNumber:@3]) {
            
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = CGRectMake(0, 0, 50, 20);
            gradientLayer.colors = @[(id)UIColorFromRGB(0xDAD9D9).CGColor,(id)UIColorFromRGB(0xC7C5C5).CGColor];
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1, 0);
            [_lb_statusBg.layer addSublayer:gradientLayer];
            _lb_status.text = @"已取消";
            
        }
        
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
