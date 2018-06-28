//
//  MessageCell.m
//  移动采集
//
//  Created by hcat on 2017/8/31.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_type;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_type;

@property (weak, nonatomic) IBOutlet UILabel *lb_state;
@property (weak, nonatomic) IBOutlet UILabel *lb_stateBg;


@property (weak, nonatomic) IBOutlet UILabel *lb_flag;
@property (weak, nonatomic) IBOutlet UILabel *lb_flagBg;


@end


@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lb_flagBg.layer.cornerRadius = 2.f;
    _lb_flagBg.layer.masksToBounds = YES;
    
    _lb_flag.textColor = [UIColor whiteColor];
    _lb_flag.layer.borderWidth = 1.0f;
    _lb_flag.layer.borderColor = [UIColor clearColor].CGColor;
    
    _lb_stateBg.layer.cornerRadius = 8.f;
    _lb_stateBg.layer.masksToBounds = YES;
    _lb_state.textColor = [UIColor whiteColor];
    // Initialization code
}

- (void)setModel:(IdentifyModel *)model{
    
    _model = model;
    
    if (_model) {
        _lb_time.text = [ShareFun timeWithTimeInterval:_model.createTime];
        _lb_content.text = _model.content;
        
        if ([_model.type isEqualToNumber:@1]) {
            _lb_type.text = @"特殊车辆报警";
            [_imgv_type setImage:[UIImage imageNamed:@"img_message_specialCar"]];
            _lb_state.hidden = YES;
            _lb_stateBg.hidden = YES;
            [self setFlagState];
            
        }else if ([_model.type isEqualToNumber:@2]){
        
            _lb_type.text = @"事故报警";
            [_imgv_type setImage:[UIImage imageNamed:@"img_message_accident"]];
            [self setFlagState];
            _lb_state.hidden = NO;
            _lb_stateBg.hidden = NO;
            
            if ([_model.state isEqualToNumber:@0]) {
                _lb_state.text = @"待处理";

                CAGradientLayer *gradientLayer = [CAGradientLayer layer];
                gradientLayer.frame = CGRectMake(0, 0, 44, 16);
                gradientLayer.colors = @[(id)UIColorFromRGB(0xCCCBCB).CGColor,(id)UIColorFromRGB(0x999999).CGColor];
                gradientLayer.startPoint = CGPointMake(0, 0);
                gradientLayer.endPoint = CGPointMake(1, 0);
                [_lb_stateBg.layer addSublayer:gradientLayer];
            }else if([_model.state isEqualToNumber:@1]){
                
                _lb_state.text = @"已处理";
                
                CAGradientLayer *gradientLayer = [CAGradientLayer layer];
                gradientLayer.frame = CGRectMake(0, 0, 44, 16);
                gradientLayer.colors = @[(id)UIColorFromRGB(0xFBC573).CGColor,(id)UIColorFromRGB(0xF5AE42).CGColor];
                gradientLayer.startPoint = CGPointMake(0, 0);
                gradientLayer.endPoint = CGPointMake(1, 0);
                [_lb_stateBg.layer addSublayer:gradientLayer];
            }else{
                _lb_state.hidden = YES;
                _lb_stateBg.hidden = YES;
            }
            
        }else if ([_model.type isEqualToNumber:@3]){
        
            _lb_type.text = @"警务消息";
            [_imgv_type setImage:[UIImage imageNamed:@"img_message_police"]];
            _lb_state.hidden = YES;
            _lb_stateBg.hidden = YES;
            [self setFlagState];
            
        }else if ([_model.type isEqualToNumber:@100] || [_model.type isEqualToNumber:@101] ){
            
            _lb_type.text = @"系统消息";
            [_imgv_type setImage:[UIImage imageNamed:@"img_message_system"]];
            _lb_state.hidden = YES;
            _lb_stateBg.hidden = YES;
            [self setFlagState];

        }else if ([_model.type isEqualToNumber:@4]){
            
            _lb_type.text = @"非法营运工程车报警";
            [_imgv_type setImage:[UIImage imageNamed:@"img_message_illegalCar"]];
            _lb_state.hidden = YES;
            _lb_stateBg.hidden = YES;
            [self setFlagState];
        
        }
        
    }
    
}


- (void)setFlagState{
    
    if ([_model.flag isEqualToNumber:@0]) {
        _lb_flag.text = @"未读";
        _lb_flag.textColor = [UIColor whiteColor];
        _lb_flag.layer.borderColor = [UIColor clearColor].CGColor;
        
        _lb_flagBg.hidden = NO;
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 40, 20);
        gradientLayer.colors = @[(id)UIColorFromRGB(0x6BB3FD).CGColor,(id)UIColorFromRGB(0x3396FC).CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        [_lb_flagBg.layer addSublayer:gradientLayer];
        
    }else{
        _lb_flag.text = @"已读";
        _lb_flag.textColor = UIColorFromRGB(0x999999);
        _lb_flag.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        
        _lb_flagBg.hidden = YES;
        
    }
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
