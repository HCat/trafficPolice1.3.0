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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //添加对定位的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChange) name:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil];
        
    }
    return self;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    [self configTextField];
    
}

#pragma mark - set&&get

- (void)setParam:(JointLawSaveParam *)param{
    
    _param = param;
    
    if (_param) {
        _tf_carNumber.text = _param.plateno;
        _tf_illegalTimer.text = _param.illegalTimeStr;
        _tf_illegalAddress.text = _param.illegalAddress;
        
        _tf_carName.text = _param.ownerName;
        _tf_carIdCard.text = _param.ownerIdCard;
        _tf_carPhone.text = _param.ownerPhone;
        
        _tf_driverName.text = _param.driverName;
        _tf_driverIdCard.text = _param.driverIdCard;
        _tf_driverPhone.text = _param.driverPhone;
        
        _tv_illegalDone.text = _param.dealResult;
        _tv_describe.text = _param.dealRemark;
        
    }

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
    
    if(textField == _tf_carNumber){
        _param.plateno = length > 0 ? _tf_carNumber.text : nil;
    }
    
    if(textField == _tf_illegalAddress){
        _param.illegalAddress = length > 0 ? _tf_illegalAddress.text : nil;
    }
    
    if (textField == _tf_illegalTimer) {
        _param.illegalTimeStr = length > 0 ? _tf_illegalTimer.text : nil;
    }
    
    if (textField == _tf_carName) {
        _param.ownerName = length > 0 ? _tf_carName.text : nil;
    }
    
    if (textField == _tf_carIdCard) {
         _param.ownerIdCard = length > 0 ? _tf_carIdCard.text : nil;
    }
    
    if (textField == _tf_carPhone) {
        _param.ownerPhone = length > 0 ? _tf_carPhone.text : nil;
    }
    
    if (textField == _tf_driverName) {
        _param.driverName = length > 0 ? _tf_driverName.text : nil;
    }
    
    if (textField == _tf_driverIdCard) {
        _param.driverIdCard = length > 0 ? _tf_driverIdCard.text : nil;
    }
    
    if (textField == _tf_driverPhone) {
        _param.driverPhone = length > 0 ? _tf_driverPhone.text : nil;
    }
    
    
}

#pragma mark - 实时监听UITextView内容的变化
//只能监听键盘输入时的变化(setText: 方式无法监听),如果想修复可以参考http://www.jianshu.com/p/75355acdd058
- (void)textViewDidChange:(FSTextView *)textView{
    
    if (textView == _tv_illegalDone) {
        _param.dealResult = textView.formatText;
    }
    
    if (textView == _tv_describe) {
        _param.dealRemark = textView.formatText;
    }
    
}

#pragma mark - 重新定位之后的通知

-(void)locationChange{
    
    _tf_illegalAddress.text = [LocationHelper sharedDefault].address;
    _param.illegalAddress = [LocationHelper sharedDefault].address;
    
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
