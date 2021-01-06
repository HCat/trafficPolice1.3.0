//
//  FiltrateView.m
//  ElectricityManager
//
//  Created by 黄芦荣 on 2020/6/17.
//  Copyright © 2020 hcat. All rights reserved.
//

#import "FiltrateView.h"

#import "NSArray+MASConstraint.h"
#import "PGDatePickManager.h"
#import "AccidentListVC.h"


@interface FiltrateView ()<PGDatePickerDelegate>


@property (weak, nonatomic) IBOutlet UIButton * btn_makeSure;
@property (weak, nonatomic) IBOutlet UIButton * btn_clearn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_top;

@end


@implementation FiltrateView

+ (FiltrateView *)initCustomView{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"FiltrateView" owner:self options:nil];
    return [nibView objectAtIndex:0];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layout_top.constant = Height_StatusBar;
    
    [self.tf_startTime setDelegate:(id<UITextFieldDelegate> _Nullable)self];
    [self.tf_endTime setDelegate:(id<UITextFieldDelegate> _Nullable)self];
    
    @weakify(self);
    
    self.btn_makeSure.layer.cornerRadius = 5.f;
    self.btn_clearn.layer.cornerRadius = 5.f;
    self.btn_clearn.layer.borderColor = DefaultColor.CGColor;
    self.btn_clearn.layer.borderWidth = 1.f;
    
    
    RAC(self, string_car) = [self.tf_car.rac_textSignal skip:1];
    RAC(self, string_name) = [self.tf_name.rac_textSignal skip:1];
    RAC(self, string_address) = [self.tf_address.rac_textSignal skip:1];
    RAC(self, string_startTime) = [self.tf_startTime.rac_textSignal skip:1];
    RAC(self, string_endTime) = [self.tf_endTime.rac_textSignal skip:1];
    
    [[self.btn_makeSure rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        
        if (self.string_car.length == 0) {
            self.string_car = nil;
        }
        
        if (self.string_name.length == 0) {
            self.string_name = nil;
        }
        
        if (self.string_address.length == 0) {
            self.string_address = nil;
        }
        
        if (self.string_startTime.length == 0) {
            self.string_startTime = nil;
        }
        
        if (self.string_endTime.length == 0) {
            self.string_endTime = nil;
        }
        
        RACTuple * tuple = RACTuplePack(self.string_car, self.string_name, self.string_address, self.string_startTime, self.string_endTime);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"筛选视图点击事件" object:tuple];
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"筛选视图消失事件" object:nil];
        
        [self.tf_car resignFirstResponder];
        [self.tf_name resignFirstResponder];
        [self.tf_address resignFirstResponder];
        [self.tf_startTime resignFirstResponder];
        [self.tf_endTime resignFirstResponder];
        
    }];
    
    [[self.btn_clearn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        
        self.tf_car.text = nil;
        self.tf_name.text = nil;
        self.tf_address.text = nil;
        self.tf_startTime.text = nil;
        self.tf_endTime.text = nil;
        
        self.string_car = nil;
        self.string_name = nil;
        self.string_address = nil;
        self.string_startTime = nil;
        self.string_endTime = nil;
        
    }];
    
    
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == _tf_startTime) {
        [self handleBtnShowTime1Clicked:nil];
        return NO;
    }
    
    if (textField == _tf_endTime) {
        [self handleBtnShowTime2Clicked:nil];
        return NO;
    }
    
    return YES;
    
}

- (IBAction)handleBtnShowTime1Clicked:(id)sender{
    
    AccidentListVC *t_vc = (AccidentListVC *)[ShareFun findViewController:self withClass:[AccidentListVC class]];
    
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.tag = 1;
    datePickManager.titleLabel.text = @"选择时间";
    datePickManager.isShadeBackgroud = YES;
    
    datePicker.minimumDate = [NSDate setYear:2017 month:1 day:1 hour:00 minute:00];
    datePicker.maximumDate = [NSDate date];
    datePicker.datePickerType = PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeDateHourMinute;

    [t_vc.navigationController presentViewController:datePickManager
                       animated:NO
                     completion:^{
                     }];
    
}

- (IBAction)handleBtnShowTime2Clicked:(id)sender{
    
    AccidentListVC *t_vc = (AccidentListVC *)[ShareFun findViewController:self withClass:[AccidentListVC class]];
    
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.tag = 2;
    datePickManager.titleLabel.text = @"选择时间";
    datePickManager.isShadeBackgroud = YES;
    
    datePicker.minimumDate = [NSDate setYear:2017 month:1 day:1 hour:00 minute:00];
    datePicker.maximumDate = [NSDate date];
    datePicker.datePickerType = PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeDateHourMinute;

    [t_vc.navigationController presentViewController:datePickManager
                       animated:NO
                     completion:^{
                     }];
    
    
}


#pragma mark - PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    
    NSInteger t_tag = datePicker.tag;
    
    NSLog(@"dateComponents = %@", dateComponents);
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:dateComponents];
    NSDateFormatter *dataFormant = [[NSDateFormatter alloc] init];
    [dataFormant setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dataFormant stringFromDate:date];
    
    if (t_tag == 1) {
        self.tf_startTime.text = dateStr;
        self.string_startTime = dateStr;
    }else{
        self.tf_endTime.text = dateStr;
        self.string_endTime = dateStr;
    }
   
}



@end
