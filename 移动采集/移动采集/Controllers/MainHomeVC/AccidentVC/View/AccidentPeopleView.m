//
//  AccidentPeopleView.m
//  移动采集
//
//  Created by hcat on 2018/7/18.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "AccidentPeopleView.h"
#import "CALayer+Additions.h"
#import <PureLayout.h>
#import "NSArray+PureLayoutMore.h"


@interface AccidentPeopleView()


@property (weak, nonatomic) IBOutlet UIView *v_content;


@property (weak, nonatomic) IBOutlet UILabel *lb_name;              //姓名(1号方必填)
@property (weak, nonatomic) IBOutlet UILabel *lb_identityCard;      //身份证号
@property (weak, nonatomic) IBOutlet UILabel *lb_carType;           //汽车类型
@property (weak, nonatomic) IBOutlet UILabel *lb_carNumber;         //车牌号码
@property (weak, nonatomic) IBOutlet UILabel *lb_phone;             //电话号码(1号方必填)
@property (weak, nonatomic) IBOutlet UILabel *lb_drivingState;      //行驶状态


@property (weak, nonatomic) IBOutlet UILabel *lb_illegalTitle;  //违法行为title

@property (weak, nonatomic) IBOutlet UILabel *lb_illegalBehavior;   //违法行为
@property (weak, nonatomic) IBOutlet UIView *line_illegal;  //违法行为line

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_insuranceCompany;   //保险公司layout



@property (weak, nonatomic) IBOutlet UILabel *lb_insuranceCompany;  //保险公司
@property (weak, nonatomic) IBOutlet UILabel *lb_policyNo;          //保险单号
@property (weak, nonatomic) IBOutlet UILabel *lb_responsibility;    //责任

@property (weak, nonatomic) IBOutlet UILabel *lb_otherInformation;    //其他信息

@property (weak, nonatomic) IBOutlet UIView *line_otherInformation;


@property (weak, nonatomic) IBOutlet UILabel *lb_describe;           //简述

@property (assign, nonatomic) NSInteger countLabel;             //用于存储暂存数据以便计算高度

@end

@implementation AccidentPeopleView

+ (AccidentPeopleView *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AccidentPeopleView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

- (void)setModel:(AccidentPeopleMapModel *)model{
    _model = model;
    
    if (_model) {
        self.lb_name.text = _model.name;
        self.lb_identityCard.text = _model.idNo;
        self.lb_carType.text =  _model.vehicle;
        self.lb_carNumber.text = _model.carNo;
        self.lb_phone.text = _model.phone;
        self.lb_drivingState.text = _model.direct;
        self.lb_illegalBehavior.text = _model.behaviour;
        self.lb_insuranceCompany.text = _model.insuranceCompany;
        self.lb_policyNo.text = _model.policyNo;
        self.lb_responsibility.text = _model.responsibility;
    
        
        if (self.accidentType == AccidentTypeFastAccident) {
            _lb_illegalBehavior.hidden = YES;
            _lb_illegalTitle.hidden = YES;
            _line_illegal.hidden = YES;
            _layout_insuranceCompany.constant = 27.f;
            
        }
        
        
        //构建暂扣信息
        [self buildWithholdingInfo];
        self.lb_describe.text = _model.resume ;
        
    
    }
    
}

- (CGFloat)height{
    
    CGFloat t_height = 0.0f;
    
    t_height += 10.f; //contentView距离父视图高度
    t_height += 20.f; //姓名距离父视图高度
    if (_accidentType == AccidentTypeFastAccident) {
        t_height += (27+17) * 9;
    }else{
        t_height += (27+17) * 10;
    }
    
    t_height += 17.f; //其他信息高度
    t_height += 15.f;
    if (self.countLabel > 0) {
        
        if (self.countLabel % 3 == 0 ) {
            t_height += (self.countLabel/3 ) * 35.f ;
        }else{
            t_height += (self.countLabel/3 + 1) * 37.f ;
        }
        
        t_height += 10.0f;
    
    }
    
    if (_model.resume.length > 0) {
        
        CGFloat width = SCREEN_WIDTH - (30 *2 + 60 + 10);
        CGFloat heightDescribe = [_lb_describe sizeThatFits:CGSizeMake(width,MAXFLOAT)].height;
        t_height += heightDescribe;
    
    }else{
        t_height += 17.f;
    }
    
    t_height += 20;
    
    t_height += 10;
    
    
    
    return t_height;
}


- (void)buildWithholdingInfo{
    
    NSMutableArray *t_mArr = [NSMutableArray array];
    
    if ([_model.isZkCl isEqualToNumber:@1]) {
        [t_mArr addObject:@"暂扣车辆"];
    }
    
    if ([_model.isZkXsz isEqualToNumber:@1]) {
        [t_mArr addObject:@"暂扣行驶证"];
    }
    
    if ([_model.isZkJsz isEqualToNumber:@1]) {
        [t_mArr addObject:@"暂扣驾驶证"];
    }
    
    if ([_model.isZkSfz isEqualToNumber:@1]) {
        [t_mArr addObject:@"暂扣身份证"];
    }
    
    self.countLabel = t_mArr.count;
    
    if (self.countLabel > 0) {
        
        NSMutableArray *t_arr_view = [NSMutableArray new];
        NSMutableArray *arr_v = [NSMutableArray new];
        
        for (int i = 0;i < [t_mArr count]; i++) {
            
            UILabel *t_lb = [UILabel newAutoLayoutView];
            t_lb.backgroundColor = UIColorFromRGB(0xDBECFD);
            t_lb.textColor = DefaultColor;
            t_lb.textAlignment = NSTextAlignmentCenter;
            t_lb.text = t_mArr[i];
            t_lb.tag = i;
            t_lb.layer.cornerRadius = 5.0f;
            t_lb.layer.masksToBounds = YES;
            
            [self.v_content addSubview:t_lb];
            [t_arr_view addObject:t_lb];
            
            [t_lb autoSetDimension:ALDimensionHeight toSize:25.f];
            
            if ( i % 3 == 0) {
                
                if (arr_v && [arr_v count] > 0) {
                    [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:10.0 withFixedLeading:15 withFixedTrailing:15 matchedSizes:YES];
                    [arr_v removeAllObjects];
                }
                
                if ( i ==  0){
                    [t_lb autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.lb_otherInformation withOffset:15.0];
                }else{
                    
                    UILabel *lb_before = t_arr_view[i - 3];
                    [t_lb autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lb_before withOffset:10.0];
                    
                }
                
            }
            
            [arr_v addObject:t_lb];
        }
        
        if ([arr_v count] == 1) {
            
            UILabel *t_lb = arr_v[0];
            [t_lb autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 2*30 - 2*10)/3];
            [t_lb autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:15.0f];
        }else if ([arr_v count] == 2){
            
            UILabel *lb_before = arr_v[0];
            UILabel *lb_after = arr_v[1];
            [lb_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 2*30 - 2*10)/3];
            [lb_after autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 2*30 - 2*10)/3];
            
            [lb_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:15.0f];
            [lb_after autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:lb_before withOffset:10.0];
            
            [arr_v autoAlignViewsToAxis:ALAxisHorizontal];
        }else if ([arr_v count] == 3 ){
            [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:10.0 withFixedLeading:15 withFixedTrailing:15 matchedSizes:YES];
            
        }
        
        [arr_v removeAllObjects];
        
        UILabel *t_label = t_arr_view.lastObject;
        
        [_line_otherInformation autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:t_label withOffset:13.5f];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
    }else{
        _line_otherInformation.hidden = YES;
        [_line_otherInformation autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_lb_otherInformation withOffset:5.5f];
    }
    
}


#pragma mark - buttonAction

- (IBAction)handleBtnChangeClicked:(id)sender {

    if (self.block) {
        self.block(_index);
    }

}


@end
