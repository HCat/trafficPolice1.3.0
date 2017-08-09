//
//  AccidentMessageCell.m
//  trafficPolice
//
//  Created by hcat on 2017/6/8.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AccidentMessageCell.h"
#import <PureLayout.h>
#import "ShareFun.h"

@interface AccidentMessageCell()

@property (nonatomic,strong) NSMutableArray *arr_lables;
@property(nonatomic,strong) AccidentGetCodesResponse *codes;

@end


@implementation AccidentMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.arr_lables = [NSMutableArray array];
    // Initialization code
}

- (AccidentGetCodesResponse *)codes{

    _codes = [ShareValue sharedDefault].accidentCodes;
    
    return _codes;

}

- (void)setAccident:(AccidentModel *)accident{

    _accident = accident;
    if (_accident) {
        
        if (_arr_lables && _arr_lables.count > 0) {
            return;
        }
        
        if (_accident.causesType) {
            if (self.codes) {
                NSString * t_str = [self.codes searchNameWithModelId:[_accident.causesType integerValue] WithArray:self.codes.cause];
                [self buildLableWithTitle:@"事故成因:" AndText:t_str];
            }
        }
        
        if (_accident.happenTime) {
            NSString *t_str = [ShareFun timeWithTimeInterval:_accident.happenTime];
            [self buildLableWithTitle:@"事故时间:" AndText:t_str];
        }
        
        if (_accident.roadId) {
            if (self.codes) {
                NSString * t_str = [self.codes searchNameWithModelId:[_accident.roadId integerValue] WithArray:self.codes.road];
                [self buildLableWithTitle:@"所在位置:" AndText:t_str];
            }
        }
        
        if (_accident.address) {
            [self buildLableWithTitle:@"事故地点:" AndText:_accident.address];
        }
        
        if (_accident.weather) {
            [self buildLableWithTitle:@"天气情况:" AndText:_accident.weather];
        }
        
        if (_accident.injuredNum) {
            [self buildLableWithTitle:@"受伤人数:" AndText:_accident.injuredNum];
        }
        
        if (_accident.roadType) {
            if (self.codes) {
                NSString * t_str = [self.codes searchNameWithModelType:[_accident.roadType integerValue] WithArray:self.codes.roadType];
                [self buildLableWithTitle:@"道路类型:" AndText:t_str];
            }
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


#pragma mark -

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
