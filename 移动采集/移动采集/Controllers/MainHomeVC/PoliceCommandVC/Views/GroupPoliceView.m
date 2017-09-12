//
//  GroupPoliceView.m
//  移动采集
//
//  Created by hcat on 2017/9/12.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "GroupPoliceView.h"

@implementation GroupPoliceView


+ (GroupPoliceView *)initCustomView{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"GroupPoliceView" owner:self options:nil];
    
    GroupPoliceView * t_view = [nibView objectAtIndex:0];
    [t_view setUpClickUITextField:t_view.tf_groupName];
    
    return t_view;
}


- (void)dismiss{
    [self removeFromSuperview];
    
}

#pragma mark -  private methods

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

#pragma mark - button methods

- (IBAction)handleBtnMakeSureClicked:(id)sender {
    
    self.groupName = _tf_groupName.text;
    
    if (self.groupName == nil || self.groupName.length == 0) {
        [LRShowHUD showError:@"请选择小组" duration:1.5f];
        return;
    }
    
    if (self.makeSureBlock) {
        self.makeSureBlock(self.groupName,self.groupId);
    }
    
    [self dismiss];
    
}

- (IBAction)handleBtnCancleClicked:(id)sender {
    [self dismiss];
    
}


#pragma mark - textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self handleBtnShowSelecedListClicked:nil];
    return NO;

}


- (void)handleBtnShowSelecedListClicked:(id)sender{

    if (self.selectedBlock) {
        self.selectedBlock(self);
    }

}

#pragma mark - dealloc

- (void)dealloc{
    
    LxPrintf(@"GroupPoliceView dealloc");

}

@end
