//
//  DutyPoliceCell.m
//  移动采集
//
//  Created by hcat on 2018/6/13.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "DutyPoliceCell.h"
#import <PureLayout.h>
#import "NSArray+PureLayoutMore.h"
#import "DutyAPI.h"
#import "AlertView.h"


@interface DutyPoliceCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (nonatomic,strong) NSMutableArray * arr_view;


@end

@implementation DutyPoliceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.arr_view = [NSMutableArray array];
    
}

- (void)setArr_group:(NSArray *)arr_group{
    
    _arr_group = arr_group;
    
    if (_type == 0) {
        _lb_title.text = @"值班民警";
    }else{
        _lb_title.text = @"值班辅警";
    }
    
    if (_arr_group && _arr_group.count > 0) {
        [self buildViewWith:_arr_group];
    }
    
}




- (IBAction)btnTagAction:(id)sender{
    
    UIButton *t_btn = (UIButton *)sender;
    NSInteger  tag = t_btn.tag;
    
    NSInteger row  = tag/1000;
    NSInteger line = tag%1000 - 100;
    
    NSArray *t_arr_date = nil;
    DutyGroupModel * model = (DutyGroupModel *)_arr_group[row];
    if (_type == 0) {
        t_arr_date = model.policeList;
    }else{
        t_arr_date = model.helpList;
    }
    if (t_arr_date && t_arr_date.count > 0) {
        DutyPeopleModel *peopleModel = t_arr_date[line];
        [AlertView showWindowWithMakePhoneViewWith:peopleModel];
        
    }
    
    
    
}

- (void)buildViewWith:(NSArray *)arr_source{
    
    if (arr_source && arr_source.count > 0) {
        
        if (_arr_view && _arr_view.count > 0) {
            
            for (int i = 0;i < [_arr_view count]; i++) {
               
                UIView *t_view = _arr_view[i];
                [t_view removeFromSuperview];

            }
            
            [_arr_view removeAllObjects];
            
        }
            
        for (int i = 0; i < arr_source.count; i++) {
            DutyGroupModel * model = (DutyGroupModel *)arr_source[i];
            UIView *t_view = [UIView new];
            t_view.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:t_view];
            [t_view configureForAutoLayout];
            [self.arr_view addObject:t_view];
            
            NSArray *t_arr_date = nil;
            if (_type == 0) {
                t_arr_date = model.policeList;
            }else{
                t_arr_date = model.helpList;
            }
            CGFloat height = [self getHeightWithPeople:t_arr_date];
            [t_view autoSetDimension:ALDimensionHeight toSize:height];
            
            if (i == 0) {
                [t_view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_lb_title withOffset:5.f];
                [t_view autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView withOffset:95.f];
                [t_view autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-25.f];
                
                
            }else{
                
                UIView *t_view_before = self.arr_view[i-1];
                [t_view autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:t_view_before];
                [t_view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:t_view_before withOffset:2.f];
                [t_view autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:t_view_before];
                
            }
            
            if (t_arr_date && t_arr_date.count > 0) {
                [self buildGroupTitle:model.name withArray:t_arr_date withTag:i inView:t_view];
            }
            
            
            
        }
        
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    
    
    
    
}


- (void)buildGroupTitle:(NSString *)name withArray:(NSArray *)arr_source withTag:(int)tag inView:(UIView *)view{
    
    UILabel *t_lb = [UILabel newAutoLayoutView];
    t_lb.text = name;
    t_lb.tag  = tag * 1000 + 1;
    t_lb.font = [UIFont systemFontOfSize:14];
    t_lb.textColor = DefaultTextColor;
    [view addSubview:t_lb];
    [t_lb autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_lb_title];
    [t_lb autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:view withOffset:19];
    
    UIView *t_line = [UIView newAutoLayoutView];
    [t_line setBackgroundColor:UIColorFromRGB(0xE5E5E5)];
    [view addSubview:t_line];
    [t_line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
    [t_line autoSetDimension:ALDimensionHeight toSize:0.5f];
    
    [self buildButtonsWith:arr_source startView:t_lb withTag:tag inView:view];

}



- (void)buildButtonsWith:(NSArray *)arr_source startView:(UILabel *)lb_start withTag:(NSInteger)tag inView:(UIView *)view{
    
    NSMutableArray *arr_all = [NSMutableArray new];
    NSMutableArray *arr_v = [NSMutableArray new];
    
    for (int i = 0;i < [arr_source count]; i++) {
        DutyPeopleModel *t_model = arr_source[i];
        UIButton *t_button = [UIButton newAutoLayoutView];
        [t_button setTitle:t_model.realName forState:UIControlStateNormal];
        t_button.titleLabel.font = [UIFont systemFontOfSize:15];
        [t_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [t_button setBackgroundColor:DefaultColor];
        t_button.tag = tag * 1000 + 100 + i;
        t_button.layer.cornerRadius = 5.0f;
        t_button.layer.masksToBounds = YES;
        [t_button addTarget:self action:@selector(btnTagAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:t_button];
        [arr_all addObject:t_button];
        
        if ( i % 3 == 0) {
            
            if (arr_v && [arr_v count] > 0) {
                [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:3.0 withFixedLeading:0 withFixedTrailing:0 matchedSizes:YES];
                [arr_v removeAllObjects];
            }
            
            if ( i ==  0){
                [t_button autoAlignAxis:ALAxisHorizontal toSameAxisOfView:lb_start];
            }else{
                UIButton *btn_before = arr_all[i - 3];
                [t_button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:btn_before withOffset:7.0];
                
            }
            
        }
        
        [arr_v addObject:t_button];
        
    }
    
    
    if ([arr_v count] == 1) {
        
        UIButton *btn_before = arr_v[0];
        [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 25 - 95 - 2*3)/3];
        [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
        
    }else if ([arr_v count] == 2){
        
        UIButton *btn_before = arr_v[0];
        UIButton *btn_after = arr_v[1];
        [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 25 - 95 - 2*3)/3];
        [btn_after autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 25 - 95 - 2*3)/3];
        
        [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
        [btn_after autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:btn_before withOffset:3.0];
        
        [arr_v autoAlignViewsToAxis:ALAxisHorizontal];
        
    }else if ([arr_v count] == 3 ){
        
        [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:3.0 withFixedLeading:0 withFixedTrailing:0 matchedSizes:YES];
        
    }
    
    [arr_v removeAllObjects];
    
    for (int i = 0;i < [arr_all count]; i++) {
        UIButton *t_button  = arr_all[i];
        [t_button autoSetDimension:ALDimensionHeight toSize:30.f];
    }
    

}


- (CGFloat)getHeightWithPeople:(NSArray *)arr_people{
    
    CGFloat height = 0.f;
    height += 19.f;
    
    if (arr_people && arr_people.count > 0) {
        
        if (arr_people.count % 3 == 0 ) {
            height = height - 6 + ( arr_people.count/3 ) * 37.f + 7;
        }else{
            height = height - 6 + ( arr_people.count/3 + 1) * 37.f + 7;
        }
        
    }else{
        
        height += 18 + 15.f;
    }
    
    return height;
    
}


- (CGFloat)getHeightWithArr:(NSArray *)arr_group{
    CGFloat height = 0.0f;
    
    for (int i = 0 ; i < arr_group.count; i++) {
        DutyGroupModel *t_model = arr_group[i];
        NSArray *t_arr = nil;
        if (self.type == 0) {
            t_arr = t_model.policeList;
        }else{
            t_arr = t_model.helpList;
        }
        
        height += [self getHeightWithPeople:t_arr];
        
    }
    
    height = height + 35 + 20 + 20;
    
    return height;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
