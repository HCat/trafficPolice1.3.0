//
//  MessageCell.m
//  移动采集
//
//  Created by hcat on 2017/8/31.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "MessageCell.h"
#import "PersistentBackgroundLabel.h"

@interface MessageCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet PersistentBackgroundLabel *lb_type;
@property (weak, nonatomic) IBOutlet UIImageView *imgeV_state;

@end


@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(IdentifyModel *)model{
    
    _model = model;
    
    if (_model) {
        _lb_time.text = [ShareFun timeWithTimeInterval:_model.createTime];
        _lb_content.text = _model.content;
        
        if ([_model.type isEqualToNumber:@1]) {
            _lb_type.text = @"特殊车辆";
            _imgeV_state.hidden = YES;
            if ([_model.flag isEqualToNumber:@0]) {
                [_lb_type setPersistentBackgroundColor:UIColorFromRGB(0xf26262)];
            }else{
                [_lb_type setPersistentBackgroundColor:UIColorFromRGB(0xa8b2cb)];
            
            }
            
        }else if ([_model.type isEqualToNumber:@2]){
        
            _lb_type.text = @"出警任务";
            
            if ([_model.flag isEqualToNumber:@0]) {
                 [_lb_type setPersistentBackgroundColor:UIColorFromRGB(0x5491f5)];
                _imgeV_state.hidden = YES;
               
            }else{
                [_lb_type setPersistentBackgroundColor:UIColorFromRGB(0xa8b2cb)];
                if ([_model.state isEqualToNumber:@0]) {
                    _imgeV_state.hidden = NO;
                }else{
                    _imgeV_state.hidden = YES;
                }
            }
            
        }else if ([_model.type isEqualToNumber:@3]){
        
            _lb_type.text = @"警务消息";
            _imgeV_state.hidden = YES;
            if ([_model.flag isEqualToNumber:@0]) {
                 [_lb_type setPersistentBackgroundColor:UIColorFromRGB(0xf8a72f)];
               
            }else{
                [_lb_type setPersistentBackgroundColor:UIColorFromRGB(0xa8b2cb)];
               
            }
            
        }else if ([_model.type isEqualToNumber:@100] || [_model.type isEqualToNumber:@101] ){
            
            _lb_type.text = @"系统消息";
            _imgeV_state.hidden = YES;
            if ([_model.flag isEqualToNumber:@0]) {
                [_lb_type setPersistentBackgroundColor:UIColorFromRGB(0x868bf4)];
                
            }else{
                [_lb_type setPersistentBackgroundColor:UIColorFromRGB(0xa8b2cb)];
                
            }

        }else if ([_model.type isEqualToNumber:@4]){
            
            _lb_type.text = @"非法营运";
            _imgeV_state.hidden = YES;
            if ([_model.flag isEqualToNumber:@0]) {
                [_lb_type setPersistentBackgroundColor:UIColorFromRGB(0xf88852)];
                
            }else{
                [_lb_type setPersistentBackgroundColor:UIColorFromRGB(0xa8b2cb)];
                
            }
            
        }
        
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
