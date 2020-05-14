//
//  AccidentRemarkListCell.m
//  移动采集
//
//  Created by hcat on 2017/8/14.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AccidentRemarkListCell.h"
#import "CALayer+Additions.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"

@interface AccidentRemarkListCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_name;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_remark;

@end


@implementation AccidentRemarkListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRemarkModel:(RemarkModel *)remarkModel{
    
    _remarkModel = remarkModel;
    
    if (_remarkModel) {
        
        _lb_name.text = _remarkModel.createName;
        _lb_time.text = [NSString stringWithFormat:@"(%@)",[ShareFun timeWithTimeInterval:_remarkModel.createTime]];
        _lb_remark.text = _remarkModel.contents;
        [UILabel changeLineSpaceForLabel:_lb_remark WithSpace:3.f];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
