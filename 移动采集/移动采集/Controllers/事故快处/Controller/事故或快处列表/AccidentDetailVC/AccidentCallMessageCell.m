//
//  AccidentCallMessageCell.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/11/16.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "AccidentCallMessageCell.h"
#import <PureLayout.h>
#import "ShareFun.h"

@interface AccidentCallMessageCell()

@property (nonatomic,strong) NSMutableArray *arr_lables;

@end

@implementation AccidentCallMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.arr_lables = [NSMutableArray array];
    // Initialization code
}


- (void)setAccident:(AccidentInfoModel *)accident{

    _accident = accident;
    if (_accident) {
        
        if (_arr_lables && _arr_lables.count > 0) {
            return;
        }
                
        if (_accident.address) {
            [self buildLableWithTitle:@"报警人姓名:" AndText:_accident.callpoliceMan];
        }
        
        if (_accident.weather) {
            [self buildLableWithTitle:@"报警人电话:" AndText:_accident.callpoliceManPhone];
        }
        
        
        [[_arr_lables firstObject] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13.f];
        [[_arr_lables firstObject] autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:45.f];
        UILabel *previousView = nil;
        for (UILabel *view in _arr_lables) {
            if (previousView) {
                [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousView withOffset:18.f];
                [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:previousView];
            }
            previousView = view;
        }
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];

    }
}


- (void)buildLableWithTitle:(NSString *)title AndText:(NSString *)text{
    
    UILabel * t_title = [UILabel newAutoLayoutView];
    t_title.font = [UIFont systemFontOfSize:14.f];
    t_title.textColor = UIColorFromRGB(0x444444);
    t_title.text = title;
    [self.contentView addSubview:t_title];
    
    UILabel * t_content = [UILabel newAutoLayoutView];
    t_content.font = [UIFont systemFontOfSize:14.f];
    t_content.textColor = UIColorFromRGB(0x444444);
    t_content.text = text;
    [self.contentView addSubview:t_content];

    [t_content autoAlignAxis:ALAxisHorizontal toSameAxisOfView:t_title ];
    [t_content autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:t_title withOffset:15.f];
    
    [_arr_lables addObject:t_title];
}



#pragma mark - publicMethods

- (float)heightWithAccident{

    if (_arr_lables && _arr_lables.count > 0) {
        
        UILabel *t_lb = (UILabel *)_arr_lables[0];
        
        return 45 + _arr_lables.count * (t_lb.frame.size.height + 18);
    }
    
    return 0;
}

@end
