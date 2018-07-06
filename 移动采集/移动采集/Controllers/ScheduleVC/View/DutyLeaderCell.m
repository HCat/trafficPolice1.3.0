//
//  DutyLeaderCell.m
//  移动采集
//
//  Created by hcat on 2018/6/13.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "DutyLeaderCell.h"
#import <PureLayout.h>
#import "NSArray+PureLayoutMore.h"
#import "DutyAPI.h"
#import "AlertView.h"

@interface DutyLeaderCell()

@property (nonatomic,strong) NSMutableArray *arr_view;
@property (weak, nonatomic) IBOutlet UILabel *lb_leader;


@end

@implementation DutyLeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.arr_view = [NSMutableArray array];
}

- (void)setArr_leader:(NSArray *)arr_leader{
    _arr_leader = arr_leader;
    
    if (_arr_leader&& _arr_leader.count > 0) {
       
        if (_arr_view && _arr_view.count > 0) {
            
            for (int i = 0;i < [_arr_view count]; i++) {
                
                UIButton *t_btn = _arr_view[i];
                [t_btn removeFromSuperview];
                
            }
            
            [_arr_view removeAllObjects];
            
        }
            
        NSMutableArray *arr_v = [NSMutableArray new];
        
        for (int i = 0;i < [_arr_leader count]; i++) {
            DutyPeopleModel * model = _arr_leader[i];
            
            UIButton *t_button = [UIButton newAutoLayoutView];
            [t_button setTitle:model.realName forState:UIControlStateNormal];
            t_button.titleLabel.font = [UIFont systemFontOfSize:15];
            [t_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [t_button setBackgroundColor:DefaultColor];
            t_button.tag = i + 100;
            t_button.layer.cornerRadius = 5.0f;
            t_button.layer.masksToBounds = YES;
            [t_button addTarget:self action:@selector(btnTagAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:t_button];
            [_arr_view addObject:t_button];
            
            if ( i % 3 == 0) {
                
                if (arr_v && [arr_v count] > 0) {
                    [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:3.0 withFixedLeading:95 withFixedTrailing:25 matchedSizes:YES];
                    [arr_v removeAllObjects];
                }
                
                if ( i ==  0){
                    [t_button autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_lb_leader];
                }else{
                    UIButton *btn_before = _arr_view[i - 3];
                    [t_button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:btn_before withOffset:7.0];
                    
                }
                
            }
            
            [arr_v addObject:t_button];
            
        }
        
        
        if ([arr_v count] == 1) {
            
            UIButton *btn_before = arr_v[0];
            [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 25 - 95 - 2*3)/3];
            [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:95];
            
        }else if ([arr_v count] == 2){
            
            UIButton *btn_before = arr_v[0];
            UIButton *btn_after = arr_v[1];
            [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 25 - 95 - 2*3)/3];
            [btn_after autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 25 - 95 - 2*3)/3];
            
            [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:95];
            [btn_after autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:btn_before withOffset:3.0];
            
            [arr_v autoAlignViewsToAxis:ALAxisHorizontal];
            
        }else if ([arr_v count] == 3 ){
            
            [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:3.0 withFixedLeading:95 withFixedTrailing:25 matchedSizes:YES];
            
        }
        
        [arr_v removeAllObjects];
        
        for (int i = 0;i < [_arr_view count]; i++) {
            UIButton *t_button  = _arr_view[i];
            [t_button autoSetDimension:ALDimensionHeight toSize:30.f];
            
        }
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        
    }
    

}

- (IBAction)btnTagAction:(id)sender{
    
    UIButton *t_btn = (UIButton *)sender;
    NSInteger  tag = t_btn.tag;

    NSInteger line = tag - 100;
    
    if (_arr_leader && _arr_leader.count > 0) {
        DutyPeopleModel *peopleModel = _arr_leader[line];
        [AlertView showWindowWithMakePhoneViewWith:peopleModel];
        
    }
    
    
    
    
}

- (CGFloat)getHeightWithArray:(NSArray *)array{
    CGFloat height = 35.0f;
    
    if (array && array.count > 0) {
        
        if (array.count % 3 == 0 ) {
            height = height - 6 + ( array.count/3 ) * 37.f + 15.f;
        }else{
            height = height - 6 + ( array.count/3 + 1) * 37.f + 15.f;
        }
        
    }else{
        
        height = height + 18.f + 30.f;
    }

    return height;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
