//
//  SpecialNoticeCell.m
//  移动采集
//
//  Created by hcat on 2018/9/10.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "SpecialNoticeCell.h"

@interface SpecialNoticeCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgv_selected;
@property (weak, nonatomic) IBOutlet UILabel *lb_notice;


@end

@implementation SpecialNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SpecialNoticeModel *)model{
    
    _model = model;
    
    _lb_notice.text = [ShareFun takeStringNoNull:_model.name];
    
    if (_model.flag == 1) {
        [_imgv_selected setImage:[UIImage imageNamed:@"icon_specialnotice_n"]];
    }else{
        [_imgv_selected setImage:[UIImage imageNamed:@"icon_specialnotice_h"]];
    }
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
