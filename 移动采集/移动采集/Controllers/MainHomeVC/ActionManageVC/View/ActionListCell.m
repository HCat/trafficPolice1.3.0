//
//  ActionListCell.m
//  移动采集
//
//  Created by hcat on 2018/8/2.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "ActionListCell.h"
#import <PureLayout.h>
#import "DutyAPI.h"
#import "AlertView.h"

@interface ActionListCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_title;


@property (weak, nonatomic) IBOutlet UIView *view_first;
@property (weak, nonatomic) IBOutlet UIButton *btn_first;
@property (weak, nonatomic) IBOutlet UILabel *lb_first;



@property (weak, nonatomic) IBOutlet UIView *view_second;
@property (weak, nonatomic) IBOutlet UIButton *btn_second;
@property (weak, nonatomic) IBOutlet UILabel *lb_second;



@property (weak, nonatomic) IBOutlet UIView *view_third;
@property (weak, nonatomic) IBOutlet UIButton *btn_third;
@property (weak, nonatomic) IBOutlet UILabel *lb_third;



@property (weak, nonatomic) IBOutlet UILabel *lb_status;
@property (weak, nonatomic) IBOutlet UILabel *lb_statusBg;


@end


@implementation ActionListCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
}

- (void)setModel:(ActionListModel *)model{
    
    _model = model;
    
    
    if (_model) {
    
        _lb_title.text = [ShareFun takeStringNoNull:_model.actionName];
        
        if ([_model.status isEqualToNumber:@0]) {
            _lb_status.text = @"待发布";
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = CGRectMake(0, 0, 50, 20);
            gradientLayer.colors = @[(id)UIColorFromRGB(0x6BB3FD).CGColor,(id)UIColorFromRGB(0x3396FC).CGColor];
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1, 0);
            [_lb_statusBg.layer addSublayer:gradientLayer];
        }else if ([_model.status isEqualToNumber:@1]){
            _lb_status.text = @"已发布";
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = CGRectMake(0, 0, 50, 20);
            gradientLayer.colors = @[(id)UIColorFromRGB(0xFDB28E).CGColor,(id)UIColorFromRGB(0xFE9460).CGColor];
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1, 0);
            [_lb_statusBg.layer addSublayer:gradientLayer];
        }else if ([_model.status isEqualToNumber:@2]){
            _lb_status.text = @"已结束";
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = CGRectMake(0, 0, 50, 20);
            gradientLayer.colors = @[(id)UIColorFromRGB(0xDAD9D9).CGColor,(id)UIColorFromRGB(0xC7C5C5).CGColor];
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1, 0);
            [_lb_statusBg.layer addSublayer:gradientLayer];
        }else{
            _lb_status.hidden = YES;
            _lb_statusBg.hidden = YES;
        }
        
        _view_first.hidden = YES;
        _view_second.hidden = YES;
        _view_third.hidden = YES;
        
        if (_model.createName && _model.createName.length > 0) {
            
            [_btn_first setTitle:[ShareFun takeStringNoNull:_model.createName] forState:UIControlStateNormal];
            _lb_first.text = [NSString stringWithFormat:@"创建时间:%@",[ShareFun timeWithTimeInterval:_model.createTime]];
            _view_first.hidden = NO;
           
        }
        
        if (_model.publishName && _model.publishName.length > 0) {
            
            if (_model.createName) {
                
                [_btn_second setTitle:[ShareFun takeStringNoNull:_model.publishName] forState:UIControlStateNormal];
                _lb_second.text = [NSString stringWithFormat:@"发布时间:%@",[ShareFun timeWithTimeInterval:_model.publishTime]];
                _view_second.hidden = NO;
               
                
            }else{
                
                [_btn_first setTitle:[ShareFun takeStringNoNull:_model.publishName] forState:UIControlStateNormal];
                _lb_first.text = [NSString stringWithFormat:@"发布时间:%@",[ShareFun timeWithTimeInterval:_model.createTime]];
                _view_first.hidden = NO;
                
            }
  
        }
        
        if (_model.endName && _model.endName.length > 0) {
            
            if (_model.createName.length > 0 && _model.publishName.length > 0) {
                
                [_btn_third setTitle:[ShareFun takeStringNoNull:_model.endName] forState:UIControlStateNormal];
                _lb_third.text = [NSString stringWithFormat:@"结束时间:%@",[ShareFun timeWithTimeInterval:_model.endTime]];
                _view_third.hidden = NO;
                
                
            }else if (_model.createName.length > 0 || _model.publishName.length > 0){
                
                [_btn_second setTitle:[ShareFun takeStringNoNull:_model.endName] forState:UIControlStateNormal];
                _lb_second.text = [NSString stringWithFormat:@"结束时间:%@",[ShareFun timeWithTimeInterval:_model.endTime]];
                _view_second.hidden = NO;
               
                
            }else{
                
                [_btn_first setTitle:[ShareFun takeStringNoNull:_model.endName] forState:UIControlStateNormal];
                _lb_first.text = [NSString stringWithFormat:@"结束时间:%@",[ShareFun timeWithTimeInterval:_model.endTime]];
                _view_first.hidden = NO;
               
            }
            
        }
        
        [self getHeightforModel:_model];
    }
    
}

- (IBAction)handleBtnFirstClicked:(id)sender {
    
    
    if (_model.createName.length > 0 && _model.createName) {
        
        DutyPeopleModel *t_model = [[DutyPeopleModel alloc] init];
        t_model.realName = _model.createName;
        t_model.telNum = _model.createName;
        t_model.name = _model.createPhone;
        [AlertView showWindowWithMakePhoneViewWith:t_model];
        
        return;
    }
    
    if (_model.publishName.length > 0 && _model.publishName) {
        
        DutyPeopleModel *t_model = [[DutyPeopleModel alloc] init];
        t_model.realName = _model.publishName;
        t_model.telNum = _model.publishName;
        t_model.name = _model.publishPhone;
        [AlertView showWindowWithMakePhoneViewWith:t_model];
        
        return;
    }
    
    if (_model.endName.length > 0 && _model.endName) {
        
        DutyPeopleModel *t_model = [[DutyPeopleModel alloc] init];
        t_model.realName = _model.endName;
        t_model.telNum = _model.endName;
        t_model.name = _model.endPhone;
        [AlertView showWindowWithMakePhoneViewWith:t_model];
        
        return;
    }
    
}

- (IBAction)handleBtnSecondClicked:(id)sender {

    if (_model.publishName.length > 0 && _model.publishName) {
        
        DutyPeopleModel *t_model = [[DutyPeopleModel alloc] init];
        t_model.realName = _model.publishName;
        t_model.telNum = _model.publishName;
        t_model.name = _model.publishPhone;
        [AlertView showWindowWithMakePhoneViewWith:t_model];
        
        return;
    }
    
    if (_model.endName.length > 0 && _model.endName) {
        
        DutyPeopleModel *t_model = [[DutyPeopleModel alloc] init];
        t_model.realName = _model.endName;
        t_model.telNum = _model.endName;
        t_model.name = _model.endPhone;
        [AlertView showWindowWithMakePhoneViewWith:t_model];
        
        return;
    }
    
}


- (IBAction)handleBtnThridClicked:(id)sender {
    
    if (_model.endName.length > 0 && _model.endName) {
        
        DutyPeopleModel *t_model = [[DutyPeopleModel alloc] init];
        t_model.realName = _model.endName;
        t_model.telNum = _model.endName;
        t_model.name = _model.endPhone;
        [AlertView showWindowWithMakePhoneViewWith:t_model];
        
        return;
    }
    
}

- (void)getHeightforModel:(ActionListModel *)model{
    
    if (model) {
        
        NSInteger tag = 0;
        
        if (model.createName && model.createName.length > 0) {
            tag += 1;
        }
        
        if (model.publishName && model.publishName.length > 0) {
            tag += 1;
        }
        
        if (model.endName && model.endName.length > 0) {
            tag += 1;
        }
        
        _layout_title.constant = tag > 0 ? tag * 26 + 40 : 20;
        
        [self.contentView setNeedsLayout];
        [self.contentView layoutIfNeeded];
       
        
    }
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
