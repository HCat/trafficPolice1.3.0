//
//  IllegalListCell.m
//  移动采集
//
//  Created by hcat on 2018/8/16.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalListCell.h"

@interface IllegalListCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_timeAgo;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;


@end

@implementation IllegalListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(IllegalListModel *)model{
    _model = model;
    
    if (_model) {
        _lb_timeAgo.text = [NSString stringWithFormat:@"%@小时前",_model.timeAgo];
        _lb_address.text = [ShareFun takeStringNoNull:_model.address];
        
    }

}


@end
