//
//  JointPenaltiesCell.m
//  移动采集
//
//  Created by hcat on 2018/1/22.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "JointPenaltiesCell.h"

@interface JointPenaltiesCell()

@property (weak, nonatomic) IBOutlet UIButton *btn_selected;
@property (weak, nonatomic) IBOutlet UILabel *lb_id;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;

@property (weak, nonatomic) IBOutlet UILabel *lb_pointsTitle;
@property (weak, nonatomic) IBOutlet UILabel *lb_pointsContent;

@property (weak, nonatomic) IBOutlet UILabel *lb_fineTitle;
@property (weak, nonatomic) IBOutlet UILabel *lb_fineContent;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_fineTitle;

@end


@implementation JointPenaltiesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(JointLawIllegalCodeModel *)model{

    _model = model;
    
    if (_model) {
        if (_model.isSelected) {
            [_btn_selected setImage:[UIImage imageNamed:@"btn_jointPenalties_h"] forState:UIControlStateNormal];
        }else{
            [_btn_selected setImage:[UIImage imageNamed:@"btn_jointPenalties_n"] forState:UIControlStateNormal];
        }
        
        _lb_id.text = [_model.illegalCode stringValue];
        _lb_content.text = _model.content;
        
        if (_model.points && _model.points.length > 0) {
            _lb_pointsTitle.hidden = NO;
            _lb_pointsContent.hidden = NO;
            _layout_fineTitle.constant = 80.f;
            _lb_pointsContent.text = _model.points;
        }else{
            _lb_pointsTitle.hidden = YES;
            _lb_pointsContent.hidden = YES;
            _layout_fineTitle.constant = 0.f;
            
        }
        
        if (_model.fines && _model.fines.length > 0) {
            _lb_fineTitle.hidden = NO;
            _lb_fineContent.hidden = NO;
            _lb_fineContent.text = _model.fines;
        }else{
            _lb_fineTitle.hidden = YES;
            _lb_fineContent.hidden = YES;
        }
        
        
        
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
