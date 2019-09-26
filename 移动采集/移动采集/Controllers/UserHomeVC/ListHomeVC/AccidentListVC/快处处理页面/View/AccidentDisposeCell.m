//
//  AccidentDisposeCell.m
//  移动采集
//
//  Created by hcat on 2019/9/2.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "AccidentDisposeCell.h"
#import "BottomPickerView.h"
#import "BottomView.h"
#import "AccidentAPI.h"

@interface AccidentDisposeCell ()

@property (weak, nonatomic) IBOutlet UITextField *tf_responsibility;    //责任

@property (weak, nonatomic) IBOutlet UILabel *lb_name;

@property (nonatomic, strong) AccidentGetCodesResponse *codes; //

@end


@implementation AccidentDisposeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpClickUITextField:self.tf_responsibility];
    
    
    @weakify(self);
    
    [RACObserve(self, model) subscribeNext:^(AccidentDisposePeopelModel * _Nullable x) {
        @strongify(self);
        self.lb_name.text = x.name;
    }];
    
}

#pragma mark - 

- (AccidentGetCodesResponse *)codes{
    
    _codes = [ShareValue sharedDefault].accidentCodes;
    
    return _codes;
}

#pragma mark - 配置UITextField

- (void)setUpClickUITextField:(UITextField *)textField{
    
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 5)];
    imageView.image = [UIImage imageNamed:@"icon_dropDownArrow.png"];
    imageView.contentMode = UIViewContentModeCenter;
    textField.rightView = imageView;
    textField.rightViewMode = UITextFieldViewModeAlways;
    [textField setDelegate:(id<UITextFieldDelegate> _Nullable)self];
    
}

#pragma mark - 责任按钮点击

- (IBAction)handleBtnResponsibilityClicked:(id)sender {
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"事故责任" items:self.codes.responsibility block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        
        SW(strongSelf, weakSelf);
        strongSelf.tf_responsibility.text = title;
        strongSelf.model.responsibilityId =  @(itemId);
        [BottomView dismissWindow];
        
    }];
    
}


#pragma mark - 通用显示模态PickView视图

- (void)showBottomPickViewWithTitle:(NSString *)title items:(NSArray *)items block:(void(^)(NSString *title, NSInteger itemId, NSInteger itemType))block{
    
    BottomPickerView *t_view = [BottomPickerView initCustomView];
    [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 207)];
    t_view.pickerTitle = title;
    t_view.items = items;
    t_view.selectedAccidentBtnBlock = block;
    
    [BottomView showWindowWithBottomView:t_view];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == _tf_responsibility) {
        [self handleBtnResponsibilityClicked:nil];
        return NO;
    }
    
    return YES;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    NSLog(@"AccidentDisposeCell dealloc");
}

@end
