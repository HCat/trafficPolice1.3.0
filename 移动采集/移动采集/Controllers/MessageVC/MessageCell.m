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
            
            if ([_model.flag isEqualToNumber:@0]) {
                [_lb_type setPersistentBackgroundColor:UIColorFromRGB(0xf26262)];
            }else{
                [_lb_type setPersistentBackgroundColor:UIColorFromRGB(0xa8b2cb)];
                
            }
            
        }else if ([_model.type isEqualToNumber:@2]){
        
            _lb_type.text = @"出警任务";
            
            if ([_model.flag isEqualToNumber:@0]) {
                 [_lb_type setPersistentBackgroundColor:UIColorFromRGB(0x5491f5)];
               
            }else{
                [_lb_type setPersistentBackgroundColor:UIColorFromRGB(0xa8b2cb)];
                
            }
            
        }else{
        
            _lb_type.text = @"警务消息";
            
            if ([_model.flag isEqualToNumber:@0]) {
                 [_lb_type setPersistentBackgroundColor:UIColorFromRGB(0xf8a72f)];
               
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
