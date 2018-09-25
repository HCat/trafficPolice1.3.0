//
//  ActionDetailCell.m
//  移动采集
//
//  Created by hcat on 2018/8/3.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "ActionDetailCell.h"
#import <PureLayout.h>
#import "NSArray+PureLayoutMore.h"
#import "DutyAPI.h"
#import "AlertView.h"

@interface ActionDetailCell()

@property (nonatomic,strong) NSMutableArray *arr_view;
@property (weak, nonatomic) IBOutlet UILabel *lb_taskTitle;

@property (weak, nonatomic) IBOutlet UILabel *lb_status;
@property (weak, nonatomic) IBOutlet UILabel *lb_statusBg;
@property (nonatomic,strong) NSLayoutConstraint *layout_bottom;


@end

@implementation ActionDetailCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.arr_view  = [NSMutableArray array];;
    
}

#pragma mark -

- (void)setModel:(ActionTaskListModel *)model{
    
    _model = model;
    
    if (_model) {
        _lb_taskTitle.text = [ShareFun takeStringNoNull:_model.taskTitle];
        
        if (_model.actionStatus) {
            _lb_statusBg.hidden = NO;
            _lb_status.hidden = NO;
            
            if ([_model.actionStatus isEqualToNumber:@1]) {
                CAGradientLayer *gradientLayer = [CAGradientLayer layer];
                gradientLayer.frame = CGRectMake(0, 0, 50, 20);
                gradientLayer.colors = @[(id)UIColorFromRGB(0x9BDC7E).CGColor,(id)UIColorFromRGB(0x7ACC56).CGColor];
                gradientLayer.startPoint = CGPointMake(0, 0);
                gradientLayer.endPoint = CGPointMake(1, 0);
                [_lb_statusBg.layer addSublayer:gradientLayer];
                _lb_status.text = @"进行中";
            }else if ([_model.actionStatus isEqualToNumber:@2]) {
                
                CAGradientLayer *gradientLayer = [CAGradientLayer layer];
                gradientLayer.frame = CGRectMake(0, 0, 50, 20);
                gradientLayer.colors = @[(id)UIColorFromRGB(0xFDB28E).CGColor,(id)UIColorFromRGB(0xFE9460).CGColor];
                gradientLayer.startPoint = CGPointMake(0, 0);
                gradientLayer.endPoint = CGPointMake(1, 0);
                [_lb_statusBg.layer addSublayer:gradientLayer];
                _lb_status.text = @"已完成";
                
            }
            
            
        }else{
            _lb_status.hidden = YES;
            _lb_statusBg.hidden = YES;
            
        }
        
        if (self.layout_bottom) {
            [self.contentView removeConstraint:self.layout_bottom];
            self.layout_bottom = nil;
        }
        
        
        if (_arr_view && _arr_view.count > 0) {
            
            for (UIView *t_view in _arr_view) {
                [t_view removeFromSuperview];
            }
            
            [_arr_view removeAllObjects];
        }
        
        
        if (_model.taskShowList && _model.taskShowList.count > 0) {
           
            for (int i = 0; i < _model.taskShowList.count; i++) {
                ActionShowListModel *model = _model.taskShowList[i];
                
                if ([model.type isEqualToNumber:@0]) {
                    [self buildTitle:model.name withType:model.type withContent:model.content];
                }else if([model.type isEqualToNumber:@1]){
                    [self buildTitle:model.name withType:model.type withContent:model.content];
                }else if([model.type isEqualToNumber:@2]){
                    [self buildTitle:model.name withArr:model.peopleArr withRow:i];
                }
 
            }
            
            if (_arr_view && _arr_view.count > 0) {
                UIView *t_view = _arr_view.lastObject;
                [t_view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-10.f];
            }
            
            
        }else{
            
        
            self.layout_bottom = [_lb_taskTitle autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-10.f];
        }
        
        [self.contentView setNeedsLayout];
        [self.contentView layoutIfNeeded];
        
        
    }
    
}



- (void) buildTitle:(NSString *)title withType:(NSNumber *)type withContent:(NSString *)content{
    
    UIView * t_top = nil;
    
    if (_arr_view && _arr_view.count > 0) {
        t_top = _arr_view.lastObject;
    }else{
        t_top = _lb_taskTitle;
    }

    UIView *t_view = [UIView newAutoLayoutView];
    [t_view setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:t_view];
    
    
    UILabel *lb_title = [UILabel newAutoLayoutView];
    lb_title.font = [UIFont systemFontOfSize:13];
    lb_title.textColor = UIColorFromRGB(0x999999);
    NSString *t_title = [NSString stringWithFormat:@"%@:",title];
    lb_title.text = t_title;
    [t_view addSubview:lb_title];
    [lb_title setContentCompressionResistancePriority:752 forAxis:UILayoutConstraintAxisHorizontal];
    [lb_title autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [lb_title autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    
    UILabel *lb_content = [UILabel newAutoLayoutView];
    lb_content.font = [UIFont systemFontOfSize:13];
    lb_content.textColor = UIColorFromRGB(0x666666);
    lb_content.numberOfLines = 0;
    
    if ([type isEqualToNumber:@1]) {
        NSNumber *time = @([content floatValue]);
        lb_content.text = [ShareFun timeWithTimeInterval:time];
    }else{
        lb_content.text = [ShareFun takeStringNoNull:content];;
    }
    
    [t_view addSubview:lb_content];
    
    [lb_content autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [lb_content autoPinEdge:ALEdgeLeft  toEdge:ALEdgeRight ofView:lb_title withOffset:9.f];
    [lb_content autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    
    
    [t_view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:t_top withOffset:12.f];
    [t_view autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:t_top];
    [t_view autoPinEdge:ALEdgeTrailing  toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-22.f];
    [t_view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:lb_content];
    
    
    [self.arr_view addObject:t_view];

}

- (void)buildTitle:(NSString *)title withArr:(NSArray *)peopleList withRow:(NSInteger)row{
    
    UIView * t_top = nil;
    
    if (_arr_view && _arr_view.count > 0) {
        t_top = _arr_view.lastObject;
    }else{
        t_top = _lb_taskTitle;
    }
    
    UIView *t_view = [UIView newAutoLayoutView];
    [t_view setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:t_view];
    
    
    UILabel *lb_title = [UILabel newAutoLayoutView];
    lb_title.font = [UIFont systemFontOfSize:13];
    lb_title.textColor = UIColorFromRGB(0x999999);
    NSString *t_title = [NSString stringWithFormat:@"%@:",title];
    lb_title.text = t_title;
    [t_view addSubview:lb_title];
    [lb_title setContentCompressionResistancePriority:752 forAxis:UILayoutConstraintAxisHorizontal];
    [lb_title autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [lb_title autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    
    if (!peopleList || peopleList.count == 0) {
        
        [t_view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:t_top withOffset:12.f];
        [t_view autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:t_top];
        [t_view autoPinEdge:ALEdgeTrailing  toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-22.f];
        [t_view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:lb_title];
        
        [self.arr_view addObject:t_view];
        
        return;
        
    }
    
    UIView *btn_View = [UIView newAutoLayoutView];
    [t_view addSubview:btn_View];
    [btn_View setBackgroundColor:[UIColor whiteColor]];
    [btn_View autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [btn_View autoPinEdge:ALEdgeLeft  toEdge:ALEdgeRight ofView:lb_title withOffset:9.f];
    [btn_View autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    
    NSMutableArray *arr_all = [NSMutableArray new];
    NSMutableArray *arr_v = [NSMutableArray new];
    
    for (int i = 0;i < [peopleList count]; i++) {
        ActionPeopleModel *t_model = peopleList[i];
        UIButton *t_button = [UIButton newAutoLayoutView];
        [t_button setTitle:t_model.userName forState:UIControlStateNormal];
        t_button.titleLabel.font = [UIFont systemFontOfSize:15];
        [t_button setTitleColor:DefaultColor forState:UIControlStateNormal];
        [t_button setBackgroundColor:[UIColor whiteColor]];
        t_button.layer.borderColor = DefaultColor.CGColor;
        t_button.layer.borderWidth = 1.f;
        t_button.layer.masksToBounds = YES;
        t_button.tag = row * 1000 + i;
        
        [t_button addTarget:self action:@selector(btnTagAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn_View addSubview:t_button];
        [arr_all addObject:t_button];
        
        if ( i % 3 == 0) {
            
            if (arr_v && [arr_v count] > 0) {
                [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:3.0 withFixedLeading: 0 withFixedTrailing:0 matchedSizes:YES];
                [arr_v removeAllObjects];
            }
            
            if ( i ==  0){
                [t_button autoPinEdgeToSuperviewEdge:ALEdgeTop];
            }else{
                UIButton *btn_before = arr_all[i - 3];
                [t_button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:btn_before withOffset:7.0];
                
            }
            
        }
        
        [arr_v addObject:t_button];
        
    }
    
    
    if ([arr_v count] == 1) {
        
        UIButton *btn_before = arr_v[0];
        [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 22 - 60 - 2*3)/3];
        [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
        
    }else if ([arr_v count] == 2){
        
        UIButton *btn_before = arr_v[0];
        UIButton *btn_after = arr_v[1];
        [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 22 - 60 - 2*3)/3];
        [btn_after autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 22 - 60 - 2*3)/3];
        
        [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
        [btn_after autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:btn_before withOffset:3.0];
        
        [arr_v autoAlignViewsToAxis:ALAxisHorizontal];
        
    }else if ([arr_v count] == 3 ){
        
        UIButton *btn_before = arr_v[0];
        UIButton *btn_after = arr_v[1];
        UIButton *btn_last = arr_v[2];
        [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 22 - 60 - 2*3)/3];
        [btn_after autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 22 - 60 - 2*3)/3];
        [btn_last autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 22 - 60 - 2*3)/3];
        
        [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
        [btn_after autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:btn_before withOffset:3.0];
        [btn_last autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:btn_after withOffset:3.0];
        
        [arr_v autoAlignViewsToAxis:ALAxisHorizontal];
        
    }
    
    [arr_v removeAllObjects];
    
    for (int i = 0;i < [arr_all count]; i++) {
        UIButton *t_button  = arr_all[i];
        [t_button autoSetDimension:ALDimensionHeight toSize:21.f];
        if (i == arr_all.count - 1) {
            [btn_View autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:t_button];
        }
    }
    
    [t_view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:t_top withOffset:12.f];
    [t_view autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:t_top];
    [t_view autoPinEdge:ALEdgeTrailing  toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-22.f];
    [t_view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:btn_View];
 
    [self.arr_view addObject:t_view];
}

- (IBAction)btnTagAction:(id)sender{
    
    UIButton *t_btn = (UIButton *)sender;
    NSInteger  tag = t_btn.tag;
    
    NSInteger row  = tag/1000;
    NSInteger line = tag%1000;
    
    if (_model.taskShowList.count > 0) {
        ActionShowListModel *model  = _model.taskShowList[row];
        if (model) {
            NSArray * peoplelist = model.peopleArr;
            if (peoplelist.count > 0) {
                ActionPeopleModel *model = peoplelist[line];
                
                DutyPeopleModel *t_model = [[DutyPeopleModel alloc] init];
                t_model.realName = model.userName;
                t_model.telNum = model.userPhone;
                t_model.name = model.userName;
                [AlertView showWindowWithMakePhoneViewWith:t_model];
            }
        }
        
        
    }

}


#pragma mark - dealloc

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
