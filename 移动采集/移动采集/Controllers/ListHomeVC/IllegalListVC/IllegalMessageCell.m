//
//  IllegalMessageCell.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/6/10.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalMessageCell.h"
#import <PureLayout.h>


@interface IllegalMessageCell()

@property (nonatomic,strong) NSMutableArray *arr_lables;
@property(nonatomic,strong) NSArray<CommonGetRoadModel *> *codes;

@end

@implementation IllegalMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.arr_lables = [NSMutableArray array];
}

#pragma mark - 

- (NSArray<CommonGetRoadModel *> *)codes{
    
    _codes = [ShareValue sharedDefault].roadModels;
    
    return _codes;
    
}

-(void)setIllegalCollect:(IllegalCollectModel *)illegalCollect{

    _illegalCollect = illegalCollect;
    if (_illegalCollect) {
        
        if (_arr_lables && _arr_lables.count > 0) {
            return;
        }
        
        if (_illegalCollect.carNo && _illegalCollect.carNo.length > 0) {
            [self buildLableWithTitle:@"车牌号码:" AndText:_illegalCollect.carNo];
        }
        
        if (_illegalCollect.collectTime) {
            NSString *t_str = [ShareFun timeWithTimeInterval:_illegalCollect.collectTime];
            [self buildLableWithTitle:@"采集时间:" AndText:t_str];
        }
        
        if (_illegalCollect.roadId) {
            
            if ([_illegalCollect.roadId isEqualToNumber:@0]) {
                if (_illegalCollect.roadName && _illegalCollect.roadName.length > 0) {
                    [self buildLableWithTitle:@"路段:" AndText:_illegalCollect.roadName];
                }
            }else{
                NSString * t_str = nil;
                if (self.codes && self.codes.count > 0) {
                    for(CommonGetRoadModel *model in _codes){
                        if ([model.getRoadId isEqualToNumber:_illegalCollect.roadId]) {
                            t_str = model.getRoadName;
                            break;
                        }
                    }
                }
                [self buildLableWithTitle:@"路段:" AndText:t_str];
            
            }
            
        }
        
        if (_illegalCollect.address && _illegalCollect.address.length > 0) {
            [self buildLableWithTitle:@"所在位置:" AndText:_illegalCollect.address];
        }
        
        if (_illegalCollect.stateName && _illegalCollect.stateName.length > 0 && _subType != ParkTypeCarInfoAdd) {
            [self buildLableWithTitle:@"状态:" AndText:_illegalCollect.stateName];
        }
        
        [[_arr_lables firstObject] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13.f];
        [[_arr_lables firstObject] autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.f];
        UILabel *previousView = nil;
        for (UILabel *view in _arr_lables) {
            if (previousView) {
                if ([view.text isEqualToString:@"状态:"]) {
                    [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousView withOffset:25.f];
                }else{
                    [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousView withOffset:18.f];
                }
                
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
    [self.contentView addSubview:t_content];
    t_content.font = [UIFont systemFontOfSize:14.f];
    if ([t_title.text isEqualToString:@"车牌号码:"]) {
        t_content.textColor = UIColorFromRGB(0x4281E8);
    }else if ([t_title.text isEqualToString:@"状态:"]){
        t_content.textColor = UIColorFromRGB(0xeb422a);
    }else{
        t_content.textColor = UIColorFromRGB(0x444444);
    }
    
    t_content.text = text;
    
    t_content.textAlignment = NSTextAlignmentLeft;

    if ([t_title.text isEqualToString:@"所在位置:"]) {
        [t_content autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:t_title];
    }else{
        [t_content autoAlignAxis:ALAxisHorizontal toSameAxisOfView:t_title ];
    }
    
    [t_content autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:t_title withOffset:15.f];
    if ([t_title.text isEqualToString:@"所在位置:"]) {
        [t_content autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:15.f relation:NSLayoutRelationGreaterThanOrEqual];
        t_content.numberOfLines = 2;
    }
    
    [_arr_lables addObject:t_title];
}



#pragma mark - publicMethods

- (float)heightWithIllegal{
    
    if (_arr_lables && _arr_lables.count > 0) {
        
        UILabel *t_lb = (UILabel *)_arr_lables[0];
        
        return 15 + _arr_lables.count * (t_lb.frame.size.height + 18);
    }
    
    return 0;
}


#pragma mark -

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
