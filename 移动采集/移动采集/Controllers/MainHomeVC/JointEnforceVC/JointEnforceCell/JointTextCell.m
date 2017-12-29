//
//  JointTextCell.m
//  移动采集
//
//  Created by hcat on 2017/11/30.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "JointTextCell.h"
#import "FSTextView.h"

@interface JointTextCell()

@property (weak, nonatomic) IBOutlet UITextField *tf_carNumber;
@property (weak, nonatomic) IBOutlet UITextField *tf_illegalAddress;
@property (weak, nonatomic) IBOutlet UITextField *tf_illegalTimer;
@property (weak, nonatomic) IBOutlet UITextField *tf_carName;
@property (weak, nonatomic) IBOutlet UITextField *tf_carIdCard;
@property (weak, nonatomic) IBOutlet UITextField *tf_carPhone;
@property (weak, nonatomic) IBOutlet UITextField *tf_driverName;
@property (weak, nonatomic) IBOutlet UITextField *tf_driverIdCard;
@property (weak, nonatomic) IBOutlet UITextField *tf_driverPhone;

@property (weak, nonatomic) IBOutlet FSTextView *tv_illegalDone;           //违法处理
@property (weak, nonatomic) IBOutlet FSTextView *tv_describe;           //备注内容

@end

@implementation JointTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configTextField];
    
}

#pragma mark - 配置UI

- (void)configTextField{
    
    [self setUpCommonUITextField:_tf_carNumber];
    [self setUpCommonUITextField:_tf_illegalAddress];
    [self setUpCommonUITextField:_tf_illegalTimer];
    [self setUpCommonUITextField:_tf_carName];
    [self setUpCommonUITextField:_tf_carIdCard];
    [self setUpCommonUITextField:_tf_carPhone];
    [self setUpCommonUITextField:_tf_driverName];
    [self setUpCommonUITextField:_tf_driverIdCard];
    [self setUpCommonUITextField:_tf_driverPhone];
    _tf_carNumber.attributedPlaceholder = [ShareFun highlightInString:@"请输入车牌号码(必填)" withSubString:@"(必填)"];
    
    
    
    
    
}

#pragma mark - 配置通用UITextField

- (void)setUpCommonUITextField:(UITextField *)textField{
    
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    
}

#pragma mark - 添加监听Textfield的变化，用于给参数实时赋值

- (void)addChangeForEventEditingChanged:(UITextField *)textField{
    [textField addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 实时监听UITextField内容的变化

-(void)passConTextChange:(id)sender{
    
    UITextField* textField = (UITextField*)sender;
    LxDBAnyVar(textField.text);
    NSInteger length =  textField.text.length;
    
    
    
    
}

#pragma mark -

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


#pragma mark - dealloc

- (void)dealloc{
    LxPrintf(@"JointTextCell dealloc");
    
}


@end
