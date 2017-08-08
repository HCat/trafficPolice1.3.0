//
//  AccidentCell.m
//  trafficPolice
//
//  Created by hcat on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AccidentCell.h"
#import "CALayer+Additions.h"

@interface AccidentCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_roadName;

@property (weak, nonatomic) IBOutlet UILabel *lb_collect;

@property (weak, nonatomic) IBOutlet UILabel *lb_handle;

@property (weak, nonatomic) IBOutlet UILabel *lb_state;

@end


@implementation AccidentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(AccidentListModel *)model{

    _model = model;
    
    if (_model) {
        
        _lb_state.layer.cornerRadius = 9.f;
        _lb_state.layer.masksToBounds = YES;
        _lb_state.hidden = YES;
        
        if ([_model.state isEqualToNumber:@3]) {
            _lb_handle.hidden = NO;
        }
        
        _lb_time.text       = [ShareFun timeWithTimeInterval:_model.happenTime];
        _lb_roadName.text   = [NSString stringWithFormat:@"%@%@",_model.roadName,_model.address];
        _lb_collect.text     = _model.entryManName;
        _lb_handle.text     =  _model.operatorName;

    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
