//
//  SpecialMemberCell.m
//  移动采集
//
//  Created by hcat on 2018/9/11.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "SpecialMemberCell.h"

@interface SpecialMemberCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_carNumber;


@end

@implementation SpecialMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SpecialCarModel *)model{
    
    _model = model;
    
    if (_model) {
        _lb_carNumber.text = _model.name;
    }
    
}

- (IBAction)handleBtnEditClicked:(id)sender {
    
    if (self.editBlock) {
        self.editBlock(_model);
    }
    
    
}

- (IBAction)handleBtnDeleteClicked:(id)sender {
    
    if (self.deleteBlock) {
        self.deleteBlock(_model);
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
