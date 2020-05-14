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

@property (weak, nonatomic) IBOutlet UILabel *lb_handleTitle;

@property (weak, nonatomic) IBOutlet UILabel *lb_handle;

@property (weak, nonatomic) IBOutlet UILabel *lb_state;

@property (weak, nonatomic) IBOutlet UIImageView *img_state;

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
        
        if ([_model.state isEqualToNumber:@3] && _accidentType != AccidentTypeFastAccident) {
            _lb_state.hidden = NO;
        }
        
        if (_accidentType == AccidentTypeAccident) {
            if ([_model.state isEqualToNumber:@1]) {
                [_img_state setImage:[UIImage imageNamed:@"icon_accident_done"]];
            }else{
                [_img_state setImage:[UIImage imageNamed:@"icon_accident_undone"]];
            }
            
            _lb_handleTitle.text = @"事故处理:";
            _lb_handle.text     =  _model.operatorName;
            
        }else{
            //快处 ("未认定",0),("已认定",9),("未审核",11),("有疑义",12),
            if ([_model.state isEqualToNumber:@9]) {
                [_img_state setImage:[UIImage imageNamed:@"icon_accident_recognized"]];
            }else if([_model.state isEqualToNumber:@11]){
                [_img_state setImage:[UIImage imageNamed:@"icon_accident_undone"]];
            }else{
                [_img_state setImage:[UIImage imageNamed:@"icon_accident_unRecognized"]];
            }
            _lb_handleTitle.text = @"事故认定:";
            _lb_handle.text     =  _model.identPoliceName;
            
        }
        
        
        _lb_time.text       = [ShareFun timeWithTimeInterval:_model.happenTime];
        _lb_roadName.text   = _model.roadName ? [NSString stringWithFormat:@"%@%@",_model.roadName,_model.address] : _model.address;
        _lb_collect.text     = _model.entryManName;
        

    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
