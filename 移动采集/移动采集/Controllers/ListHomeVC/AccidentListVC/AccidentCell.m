//
//  AccidentCell.m
//  trafficPolice
//
//  Created by hcat on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AccidentCell.h"
#import "ShareFun.h"

@interface AccidentCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_roadName;

@property (weak, nonatomic) IBOutlet UILabel *lb_police;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@end


@implementation AccidentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(AccidentListModel *)model{

    _model = model;
    
    if (_model) {

        _lb_roadName.text = _model.address;
        _lb_police.text = _model.operatorName;
        _lb_time.text = [ShareFun timeWithTimeInterval:_model.happenTime];;
    
    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
