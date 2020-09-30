//
//  ProcessResultCell.m
//  移动采集
//
//  Created by hcat on 2017/8/30.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "ProcessResultCell.h"

@interface ProcessResultCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UILabel *lb_content;


@end


@implementation ProcessResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title{

    _title = title;
    
    self.lb_title.text = _title;

}

- (void)setContent:(NSString *)content{

    _content = content;
    
    if (!_content || _content.length == 0) {
        _content = @"无";
    }
    
    self.lb_content.text = _content;

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
