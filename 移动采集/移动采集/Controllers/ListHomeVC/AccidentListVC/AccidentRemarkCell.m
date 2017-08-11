//
//  AccidentRemarkCell.m
//  移动采集
//
//  Created by hcat on 2017/8/11.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AccidentRemarkCell.h"
#import "CALayer+Additions.h"

@interface AccidentRemarkCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_name;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_remark;

@property (weak, nonatomic) IBOutlet UILabel *lb_remarkCount;

@end


@implementation AccidentRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRemarkModel:(RemarkModel *)remarkModel{

    _remarkModel = remarkModel;

    if (_remarkModel) {

        _lb_name.text = _remarkModel.createName;
        _lb_time.text = [ShareFun timeWithTimeInterval:_remarkModel.createTime];
        _lb_remark.text = _remarkModel.contents;
        
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
