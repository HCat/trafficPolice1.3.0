//
//  SpecialVehicleCell.m
//  移动采集
//
//  Created by hcat on 2018/9/7.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "SpecialVehicleCell.h"

@interface SpecialVehicleCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_carNumber;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UIButton *btn_type;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_havePic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_right;


@end

@implementation SpecialVehicleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SpecialRecordModel *)model{

    _model = model;
    
    [_btn_type setTitle:_model.groupName forState:UIControlStateNormal];
    _lb_carNumber.text = _model.carno;
    _lb_time.text = [ShareFun timeWithTimeInterval:_model.happenTime];
    _lb_address.text = [ShareFun takeStringNoNull:_model.address];
    if (_model.originalPic && _model.originalPic.length > 0) {
         _imgv_havePic.hidden = NO;
        _layout_right.constant = 50;
        
    }else{
        _imgv_havePic.hidden = YES;
        _layout_right.constant = 15;
        
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

#pragma mark - dealloc

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
