//
//  IllegalCell.m
//  trafficPolice
//
//  Created by hcat on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalCell.h"
#import "ShareFun.h"
#import "CALayer+Additions.h"

@interface IllegalCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_roadName;

@property (weak, nonatomic) IBOutlet UILabel *lb_carNumber;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@end

@implementation IllegalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(IllegalParkListModel *)model{
    
    _model = model;
    
    if (_model) {
        
        _lb_roadName.text = _model.roadName;
        _lb_carNumber.text = _model.carNo;
        _lb_time.text = [ShareFun timeWithTimeInterval:_model.collectTime];;
        
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
