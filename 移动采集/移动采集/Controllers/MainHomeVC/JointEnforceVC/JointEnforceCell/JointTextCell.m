//
//  JointTextCell.m
//  移动采集
//
//  Created by hcat on 2017/11/30.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "JointTextCell.h"
#import "FSTextView.h"
#import "LRCameraVC.h"
#import "JointEnforceVC.h"
#import "PGDatePickManager.h"
#import "PersonLocationVC.h"
#import "JointPenaltiesVC.h"

@interface JointTextCell()<PGDatePickerDelegate>

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

@property (nonatomic,strong) NSMutableArray * arr_penalties;

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
    [self.tv_describe setDelegate:(id<UITextViewDelegate> _Nullable)self];
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
    
        [self judgeCommit];
    }
    

}

- (void)judgeCommit{
    if (_tf_carNumber.text.length > 0) {
        if (self.block) {
            self.block(YES);
        }
    }else{
        if (self.block) {
            self.block(NO);
        }
        
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
    
    [self addChangeForEventEditingChanged:_tf_carNumber];
    [self addChangeForEventEditingChanged:_tf_illegalAddress];
    [self addChangeForEventEditingChanged:_tf_illegalTimer];
    [self addChangeForEventEditingChanged:_tf_carName];
    [self addChangeForEventEditingChanged:_tf_carIdCard];
    [self addChangeForEventEditingChanged:_tf_carPhone];
    [self addChangeForEventEditingChanged:_tf_driverName];
    [self addChangeForEventEditingChanged:_tf_driverIdCard];
    [self addChangeForEventEditingChanged:_tf_driverPhone];
    
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
    
    [self judgeCommit];
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

#pragma mark - 车牌号码识别点击事件

- (IBAction)handleBtnCarNumberIdentifyClicked:(id)sender {
    WS(weakSelf);
    
    JointEnforceVC *t_vc = (JointEnforceVC *)[ShareFun findViewController:self withClass:[JointEnforceVC class]];
    LRCameraVC *home = [[LRCameraVC alloc] init];
    home.isAccident = NO;
    home.type = 1;
    home.fininshCaptureBlock = ^(LRCameraVC *camera) {
        SW(strongSelf, weakSelf);
        if (camera) {
            if (camera.type == 1) {
                strongSelf.tf_carNumber.text = camera.commonIdentifyResponse.carNo;
                strongSelf.param.plateno = camera.commonIdentifyResponse.carNo;
                [strongSelf judgeCommit];
            }
        }
    };
    [t_vc presentViewController:home
                       animated:NO
                     completion:^{
                     }];
    
}

#pragma mark - 车主身份证识别

- (IBAction)handleBtnCarIdCardIdentifyClicked:(id)sender {
    WS(weakSelf);
    
    JointEnforceVC *t_vc = (JointEnforceVC *)[ShareFun findViewController:self withClass:[JointEnforceVC class]];
    LRCameraVC *home = [[LRCameraVC alloc] init];
    home.isAccident = YES;
    home.type = 2;
    home.fininshCaptureBlock = ^(LRCameraVC *camera) {
        SW(strongSelf, weakSelf);
        if (camera) {
            if (camera.type == 2) {
                
                strongSelf.tf_carName.text = camera.commonIdentifyResponse.name;
                strongSelf.tf_carIdCard.text = camera.commonIdentifyResponse.idNo;
                
                strongSelf.param.ownerName = camera.commonIdentifyResponse.name;
                strongSelf.param.ownerIdCard = camera.commonIdentifyResponse.idNo;
            }
        }
    };
    [t_vc presentViewController:home
                       animated:NO
                     completion:^{
                     }];
    
}

#pragma mark - 手动定位事件

- (IBAction)handleBtnPersonLocationClicked:(id)sender{
    
    JointEnforceVC *t_vc = (JointEnforceVC *)[ShareFun findViewController:self withClass:[JointEnforceVC class]];
    
    PersonLocationVC *t_personLocationVc = [PersonLocationVC new];
    WS(weakSelf);
    t_personLocationVc.block = ^(LocationStorageModel *model) {
        SW(strongSelf, weakSelf);
        strongSelf.tf_illegalAddress.text = model.address;
        strongSelf.param.illegalAddress = model.address;
        
    };
    [t_vc.navigationController pushViewController:t_personLocationVc animated:YES];

}


#pragma mark - 驾驶员身份证识别

- (IBAction)handleBtnDriverIdCardIdentifyClicked:(id)sender {
    WS(weakSelf);
    
    JointEnforceVC *t_vc = (JointEnforceVC *)[ShareFun findViewController:self withClass:[JointEnforceVC class]];
    LRCameraVC *home = [[LRCameraVC alloc] init];
    home.isAccident = YES;
    home.type = 2;
    home.fininshCaptureBlock = ^(LRCameraVC *camera) {
        SW(strongSelf, weakSelf);
        if (camera) {
            if (camera.type == 2) {
                strongSelf.tf_driverName.text = camera.commonIdentifyResponse.name;
                strongSelf.tf_driverIdCard.text = camera.commonIdentifyResponse.idNo;
                
                strongSelf.param.driverName = camera.commonIdentifyResponse.name;
                strongSelf.param.driverIdCard = camera.commonIdentifyResponse.idNo;
            }
        }
    };
    [t_vc presentViewController:home
                       animated:NO
                     completion:^{
                     }];
    
}

#pragma mark - 违法条例

- (IBAction)handleBtnJointPenaltiesClicked:(id)sender {
    
    WS(weakSelf);
    
    JointEnforceVC * t_vc = (JointEnforceVC *)[ShareFun findViewController:self withClass:[JointEnforceVC class]];
    
    JointPenaltiesVC* t_jointPenalties = [[JointPenaltiesVC alloc] init];
    t_jointPenalties.arr_penalts = _arr_penalties;
    t_jointPenalties.block = ^(NSArray *arr_penalties) {
        SW(strongSelf, weakSelf);
        strongSelf.arr_penalties = arr_penalties.mutableCopy;
        
        NSMutableArray *t_arr_str = [NSMutableArray array];
        NSString *t_str_content = [NSString new];
        for (int i = 0; i < arr_penalties.count; i++) {
            JointLawIllegalCodeModel * model = arr_penalties[i];
            [t_arr_str addObject:model.illegalCode];
            
            NSString *t_formatString = nil;
            NSString *t_string = nil;
            if (model.fines.length > 0 && model.points.length > 0) {
                t_formatString = @"%@ %@.  罚款:%@  扣分:%@\n";
                t_string = [NSString stringWithFormat:t_formatString,model.illegalCode,model.content,model.fines,model.points];
            }else{
                
                if (model.fines.length > 0) {
                    t_formatString = @"%@ %@.  罚款:%@\n";
                    t_string = [NSString stringWithFormat:t_formatString,model.illegalCode,model.content,model.fines];
                }else if (model.points.length > 0){
                    t_formatString = @"%@ %@.  扣分:%@\n";
                    t_string = [NSString stringWithFormat:t_formatString,model.illegalCode,model.content,model.points];
                }else{
                    t_formatString = @"%@ %@.\n";
                    t_string = [NSString stringWithFormat:t_formatString,model.illegalCode,model.content];
                }
                
            }
            
            t_str_content = [t_str_content stringByAppendingString:t_string];
            
        }
        
        strongSelf.tv_illegalDone.text = t_str_content;
        strongSelf.param.dealResult = [t_arr_str componentsJoinedByString:@","];
        
    };
    [t_vc.navigationController pushViewController:t_jointPenalties animated:YES];
    


}
#pragma mark - 选择时间事件

- (IBAction)handleBtnChooseTimeClicked:(id)sender{
    
    JointEnforceVC *t_vc = (JointEnforceVC *)[ShareFun findViewController:self withClass:[JointEnforceVC class]];
    
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePickManager.titleLabel.text = @"选择时间";
    datePickManager.isShadeBackgroud = YES;
    
    datePicker.minimumDate = [NSDate setYear:2017 month:1 day:1 hour:00 minute:00];
    datePicker.maximumDate = [NSDate date];
    datePicker.datePickerType = PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeDateHourMinute;

    [t_vc presentViewController:datePickManager
                       animated:NO
                     completion:^{
                     }];
    
    
}


#pragma mark - PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    
    NSLog(@"dateComponents = %@", dateComponents);
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:dateComponents];
    NSDateFormatter *dataFormant = [[NSDateFormatter alloc] init];
    [dataFormant setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dataFormant stringFromDate:date];
    
    _tf_illegalTimer.text = dateStr;
    _param.illegalTimeStr = dateStr;
    
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
