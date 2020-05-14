//
//  AccidentPartyCell.m
//  trafficPolice
//
//  Created by hcat on 2017/6/8.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AccidentPartyCell.h"
#import "YUSegmentedControl.h"
#import <PureLayout.h>


@interface AccidentPeopleViewManger:NSObject

@property (nonatomic,copy)  NSString *title;
@property (nonatomic,strong) AccidentPeopleModel *model;
@property (nonatomic,strong) NSMutableArray * labelMarray;
@property (nonatomic,strong) UIView * view;

@end

@implementation AccidentPeopleViewManger

- (instancetype)init{
    
    if (self = [super init]) {
        self.labelMarray = [NSMutableArray array];
        self.view = [UIView newAutoLayoutView];
    }
    
    return self;
    
}


@end

@interface AccidentPartyCell ()

//分段控件，分别为甲方，乙方，丙方
@property (weak, nonatomic) IBOutlet YUSegmentedControl *segmentedControl;

@property (nonatomic,strong) NSMutableArray * mangerMarray;


@property(nonatomic,strong) AccidentGetCodesResponse *codes;

@property(nonatomic,assign) NSUInteger indexSelected;

@property(nonatomic,assign) BOOL isDone;

@end


@implementation AccidentPartyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.isDone = NO;
    self.mangerMarray = [NSMutableArray array];

}

#pragma mark - set&&get

- (void)setList:(NSArray<AccidentPeopleModel *> *)list{
    if (_list) {
        return;
    }else{
        _list = list;
        
        if (_list && _list.count > 0) {
            
            for (int i = 0; i < _list.count; i++) {
                AccidentPeopleModel *model = _list[i];
                
                AccidentPeopleViewManger *manger = [[AccidentPeopleViewManger alloc] init];
                manger.model = model;
                manger.title = [NSString stringWithFormat:@"%d号",[manger.model.sorting intValue]];
                [self.mangerMarray addObject:manger];
            }
            
            [self setUpSegmentedControl];
            
            if (_mangerMarray.count > 0) {
                for (int i = 0; i < _mangerMarray.count ; i++) {
                    AccidentPeopleViewManger *t_model =_mangerMarray[i];
                    [self buildParty:t_model];
                }
                
            }
            
            
            
        }
        
    }
   
}

- (AccidentGetCodesResponse *)codes{
    
    _codes = [ShareValue sharedDefault].accidentCodes;
    
    return _codes;
    
}
#pragma mark - 配置分段选择控件

-(void)setUpSegmentedControl{
    
    NSMutableArray *t_marray = [NSMutableArray array];
    if (_mangerMarray.count > 0) {
        for (int i = 0; i < _mangerMarray.count ; i++) {
            AccidentPeopleViewManger *t_model =_mangerMarray[i];
            [t_marray addObject:t_model.title];
        }
        
    }
    
    [_segmentedControl setUpWithTitles:t_marray];
    [_segmentedControl setTextAttributes:@{
                                           NSFontAttributeName: [UIFont systemFontOfSize:14.0 weight:UIFontWeightLight],
                                           NSForegroundColorAttributeName: DefaultMenuUnSelectedColor
                                           } forState:YUSegmentedControlStateNormal];
    [_segmentedControl setTextAttributes:@{
                                           NSFontAttributeName: [UIFont systemFontOfSize:14.0 weight:UIFontWeightLight],
                                           NSForegroundColorAttributeName: DefaultMenuSelectedColor
                                           } forState:YUSegmentedControlStateSelected];
    _segmentedControl.indicator.backgroundColor = DefaultMenuSelectedColor;
    [_segmentedControl addTarget:self action:@selector(segmentedControlTapped:) forControlEvents:UIControlEventValueChanged];
    [_segmentedControl setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
    _segmentedControl.showsVerticalDivider = YES;
    _segmentedControl.showsTopSeparator = YES;
    _segmentedControl.showsBottomSeparator = NO;
 

    _indexSelected = _segmentedControl.selectedSegmentIndex;
    
    
    if (_mangerMarray.count > 0) {
        for (int i = 0; i < _mangerMarray.count ; i++) {
            AccidentPeopleViewManger *t_model =_mangerMarray[i];
            if (_indexSelected == i) {
                [self.contentView addSubview:t_model.view];
                [t_model.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
                [t_model.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_segmentedControl withOffset:15.f];
                
            }
        }
        
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

#pragma mark -

- (void)buildParty:(AccidentPeopleViewManger *)accident{

    if (accident.model.name && accident.model.name.length > 0) {
        [self buildLableWithTitle:@"姓 名:" AndText:accident.model.name WithArr:accident.labelMarray inView:accident.view];
    }
    
    if (accident.model.idNo && accident.model.idNo.length > 0) {
        [self buildLableWithTitle:@"身份证号:" AndText:accident.model.idNo WithArr:accident.labelMarray inView:accident.view];
    }
    
    if (accident.model.vehicleId) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.model.vehicleId integerValue] WithArray:self.codes.vehicle];
            [self buildLableWithTitle:@"车辆类型:" AndText:t_str WithArr:accident.labelMarray inView:accident.view];
        }
    }
    
    if (accident.model.carNo && accident.model.carNo.length > 0) {
        [self buildLableWithTitle:@"车牌号码:" AndText:accident.model.carNo WithArr:accident.labelMarray inView:accident.view];
    }
    
    if (accident.model.phone && accident.model.phone.length > 0) {
        [self buildLableWithTitle:@"联系电话:" AndText:accident.model.phone WithArr:accident.labelMarray inView:accident.view];
    }
    
    if (accident.model.directId) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelType:[accident.model.directId integerValue] WithArray:self.codes.driverDirect];
            [self buildLableWithTitle:@"行驶状态:" AndText:t_str WithArr:accident.labelMarray inView:accident.view];
        }
    }
    
    if (accident.model.behaviourId) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.model.behaviourId integerValue] WithArray:self.codes.behaviour];
            [self buildLableWithTitle:@"违法行为:" AndText:t_str WithArr:accident.labelMarray inView:accident.view];
        }
    }
    
    if (accident.model.insuranceCompanyId) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.model.insuranceCompanyId integerValue] WithArray:self.codes.insuranceCompany];
            [self buildLableWithTitle:@"保险公司:" AndText:t_str WithArr:accident.labelMarray inView:accident.view];
        }
    }
    
    if (accident.model.policyNo && accident.model.policyNo.length > 0) {
        [self buildLableWithTitle:@"保险单号:" AndText:accident.model.policyNo WithArr:accident.labelMarray inView:accident.view];
    }
    
    
    if (accident.model.responsibilityId) {
        if (self.codes) {
            NSString * t_str = [self.codes searchNameWithModelId:[accident.model.responsibilityId integerValue] WithArray:self.codes.responsibility];
            [self buildLableWithTitle:@"责 任:" AndText:t_str WithArr:accident.labelMarray inView:accident.view];
        }
    }
    
    /**************************/
    if (accident.model.isZkCl && accident.model.isZkCl.integerValue == 1) {
        [self buildLableWithTitle:@"是否暂扣车辆:"   WithArr:accident.labelMarray inView:accident.view];
    }
    
    if (accident.model.isZkXsz && accident.model.isZkXsz.integerValue == 1) {
        [self buildLableWithTitle:@"是否暂扣行驶证:"   WithArr:accident.labelMarray inView:accident.view];
    }
    
    if (accident.model.isZkJsz && accident.model.isZkJsz.integerValue == 1) {
        [self buildLableWithTitle:@"是否暂扣驾驶证:"  WithArr:accident.labelMarray inView:accident.view];
    }
    
    if (accident.model.isZkSfz && accident.model.isZkSfz.integerValue == 1) {
        [self buildLableWithTitle:@"是否暂扣身份证:"   WithArr:accident.labelMarray inView:accident.view];
        
    }

    [self addLayoutInViews:accident.labelMarray];
    
    /**************************/
    
    if (accident.model.resume && accident.model.resume.length > 0) {
        [self buildTextViewWithText:accident.model.resume BottomInArr:accident.labelMarray InView:accident.view];
    }

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];

}

#pragma mark -

- (void)buildLableWithTitle:(NSString *)title AndText:(NSString *)text WithArr:(NSMutableArray *)arr inView:(UIView *)view{
    
    UILabel * t_title = [UILabel newAutoLayoutView];
    t_title.font = [UIFont systemFontOfSize:14.f];
    t_title.textColor = UIColorFromRGB(0x444444);
    t_title.text = title;
    [view addSubview:t_title];
    
    UILabel * t_content = [UILabel newAutoLayoutView];
    t_content.font = [UIFont systemFontOfSize:14.f];
    t_content.textColor = UIColorFromRGB(0x444444);
    t_content.text = text;
    [view addSubview:t_content];
    
    [t_content autoAlignAxis:ALAxisHorizontal toSameAxisOfView:t_title ];
    [t_content autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:t_title withOffset:15.f];
    
    [arr addObject:t_title];
}


- (void)buildLableWithTitle:(NSString *)title  WithArr:(NSMutableArray *)arr inView:(UIView *)view{
    
    UILabel * t_title = [UILabel newAutoLayoutView];
    t_title.font = [UIFont systemFontOfSize:14.f];
    t_title.textColor = UIColorFromRGB(0x444444);
    t_title.text = title;
    [view addSubview:t_title];
    
    UIImageView * t_content = [UIImageView newAutoLayoutView];
    [t_content setImage:[UIImage imageNamed:@"btn_dot_h.png"]];
    [view addSubview:t_content];
    
    [t_content autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:50];
    [t_content autoAlignAxis:ALAxisHorizontal toSameAxisOfView:t_title ];
    
    [arr addObject:t_title];
}

- (void)buildTextViewWithText:(NSString *)text BottomInArr:(NSMutableArray *)arr InView:(UIView *)view{


    UILabel * t_title = [UILabel newAutoLayoutView];
    t_title.font = [UIFont systemFontOfSize:14.f];
    t_title.textColor = UIColorFromRGB(0x444444);
    t_title.text = @"简 述:";
    [view addSubview:t_title];
    
    if (arr && arr.count > 0) {
        [t_title autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:[arr lastObject] withOffset:18.f];
        [t_title autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:[arr lastObject]];
    }else{
        [t_title autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13.f];
        [t_title autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.f];
    }
    
    UITextView *t_tv = [UITextView newAutoLayoutView];
    t_tv.text = text;
    t_tv.textColor = UIColorFromRGB(0x444444);
    [t_tv setEditable:NO];
    t_tv.font = [UIFont systemFontOfSize:14.f];
    t_tv.layer.cornerRadius = 5.0f;
    [t_tv setBackgroundColor:UIColorFromRGB(0xe6e6e6)];
    [view addSubview:t_tv];
    [t_tv autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:t_title withOffset:10.f];
    [t_tv autoSetDimension:ALDimensionHeight toSize:99.f];
    [t_tv autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:13.f];
    [t_tv autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:13.f];
    
}

- (void)addLayoutInViews:(NSMutableArray *)arr{
    
    if (arr && arr.count > 0) {
        
        [[arr firstObject] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13.f];
        [[arr firstObject] autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.f];
        UIView * previousView = nil;
        for (UIView *view in arr) {
            if (previousView) {
                [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousView withOffset:18.f];
                [view autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:previousView];
            }
            previousView = view;
        }
    }
}

#pragma mark - 分段控件选中之后的处理

- (void)segmentedControlTapped:(YUSegmentedControl *)sender {
    
    NSUInteger selectedIndex = _segmentedControl.selectedSegmentIndex;
    LxDBAnyVar(selectedIndex);
    
    if (_indexSelected != selectedIndex) {
        
        for (int i = 0; i < _mangerMarray.count ; i++) {
            AccidentPeopleViewManger *t_model =_mangerMarray[i];
            if (_indexSelected == i) {
                [t_model.view removeFromSuperview];
                break;
            }
        
        }
        
        for (int i = 0; i < _mangerMarray.count ; i++) {
            AccidentPeopleViewManger *t_model =_mangerMarray[i];
            if (selectedIndex == i) {
                [self.contentView addSubview:t_model.view];
                [t_model.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
                [t_model.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_segmentedControl withOffset:15.f];
                 break;
            }
            
        }
        
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        _indexSelected = selectedIndex;
        
        if (self.block) {
            self.block();
        }
    }
    

}

#pragma mark - publicMethods

- (float)heightWithAccident{
    
    
    if (_mangerMarray && _mangerMarray.count > 0) {
        
        for (int i = 0; i < _mangerMarray.count; i++) {
            AccidentPeopleViewManger *manger = _mangerMarray[i];
            
            if (_indexSelected == i) {
                
                if (manger.labelMarray && manger.labelMarray.count > 0) {
                    
                    UILabel *t_lb = (UILabel *)manger.labelMarray[0];
                    
                    if (manger.model.resume && manger.model.resume.length > 0) {
                        return 84 + 15 + manger.labelMarray.count * (t_lb.frame.size.height + 18) + t_lb.frame.size.height + 10 + 99 + 10;
                        
                    }else{
                        return 84 + 15 + manger.labelMarray.count * (t_lb.frame.size.height + 18);
                        
                    }
                    
                }else{
                    
                    if (manger.model.resume && manger.model.resume.length > 0) {
                        //segenControl底部距离顶部高度 + 15间距 + label高度 + textView和简述间隔 + textView高度 + textView到底部
                        return 84 + 15 + 17 + 10 + 99  + 10;
                    }else{
                        return 84 + 15;
                    }
                    
                }
                
            }
            
            
        }
    
    }
    
    return 84 + 15;
}



#pragma mark -

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
